# =============================================================================
# translate_en_mn.R
#
# Translates Carpentries Workbench .Rmd/.md episodes from English (EN) to Mongolian (MN)
# using direct HTTP calls to Google Translate (no API key required).
#
# Two modes:
#
#   LOCAL:  source("translate_en_mn.R")  from your repo root
#           Translates ALL episodes/*.md files, index.md and learners/setup.md in-place (overwrites files).
#           Run this from inside a local checkout of the mn branch.
#
#   CI:     Called by GitHub Actions with env vars:
#             CHANGED_FILES_PATH  — file listing changed source paths
#             SOURCE_REPO         — path to main-repo checkout (read English from)
#             TARGET_REPO         — path to mn-repo checkout (write Mongolian to)
#
# In both modes, translated files land in episodes/*.md learners/setup.md and index.md, so
# sandpaper can build the mn branch as a complete Mongolian site with all
# fig/, data/, files/ paths resolving correctly.
# =============================================================================

for (pkg in c("httr2", "fs", "jsonlite")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}
library(httr2)
library(fs)
library(jsonlite)

# --- Configuration -----------------------------------------------------------
SOURCE_LANG  <- "en"
TARGET_LANG  <- "mn"
EPISODES_DIR <- "episodes"
INDEX_FILE   <- "index.md"
SETUP_FILE   <- "setup.md"
SLEEP_SECS   <- 1.5

# CI mode: separate source and target repo paths
# Local mode: both default to current working directory
source_repo <- Sys.getenv("SOURCE_REPO", unset = ".")
target_repo <- Sys.getenv("TARGET_REPO", unset = ".")

# --- Translation via direct HTTP (clean UTF-8) -------------------------------
safe_translate <- function(text, retries = 3) {
  if (trimws(text) == "") return(text)
  
  for (i in seq_len(retries)) {
    tryCatch({
      resp <- request("https://translate.googleapis.com/translate_a/single") |>
        req_url_query(
          client = "gtx",
          sl     = SOURCE_LANG,
          tl     = TARGET_LANG,
          dt     = "t",
          q      = text
        ) |>
        req_headers("Content-Type" = "application/json; charset=UTF-8") |>
        req_perform()
      
      raw_bytes <- resp_body_raw(resp)
      json_text <- rawToChar(raw_bytes)
      Encoding(json_text) <- "UTF-8"
      parsed <- fromJSON(json_text, simplifyVector = FALSE)
      
      translated <- paste(sapply(parsed[[1]], function(x) x[[1]]), collapse = "")
      Encoding(translated) <- "UTF-8"
      
      Sys.sleep(SLEEP_SECS)
      return(translated)
      
    }, error = function(e) {
      message("  Retry ", i, "/", retries, " — ", conditionMessage(e))
      Sys.sleep(SLEEP_SECS * i)
    })
  }
  
  warning("Translation failed after retries. Returning original.")
  return(text)
}

# --- Inline code protection --------------------------------------------------
# Replaces all backtick-delimited spans with PLACEHOLDERn tokens before
# translation, then restores them after.
#
# Uses a character-by-character state machine rather than regex:
#   - counts the opening run of backticks (1, 2, 3, ...)
#   - scans forward for a closing run of the exact same length
#   - replaces the entire span (including backticks) with PLACEHOLDERn
# This correctly handles nested spans like `` `r` `` and ``` ``r "..."`` ```.

protect_inline <- function(text) {
  chars        <- strsplit(text, "")[[1]]
  n            <- length(chars)
  placeholders <- list()
  counter      <- 0L
  result       <- character(0)
  i            <- 1L
  
  while (i <= n) {
    if (chars[i] == "`") {
      # Count opening backtick run
      j <- i
      while (j <= n && chars[j] == "`") j <- j + 1L
      tick_count <- j - i
      
      # Search for matching closing run of same length
      k     <- j
      found <- FALSE
      while (k <= n) {
        if (chars[k] == "`") {
          # Count this run
          end <- k
          while (end <= n && chars[end] == "`") end <- end + 1L
          if ((end - k) == tick_count) {
            # Matching close found — capture entire span
            span <- paste(chars[i:(end - 1L)], collapse = "")
            key  <- paste0("PLACEHOLDER", counter)
            placeholders[[key]] <- span
            result  <- c(result, key)
            counter <- counter + 1L
            i       <- end
            found   <- TRUE
            break
          } else {
            k <- end   # skip non-matching run
          }
        } else {
          k <- k + 1L
        }
      }
      
      if (!found) {
        # No matching close — output backticks as-is
        result <- c(result, paste(chars[i:(j - 1L)], collapse = ""))
        i <- j
      }
    } else {
      result <- c(result, chars[i])
      i <- i + 1L
    }
  }
  
  list(text = paste(result, collapse = ""), placeholders = placeholders)
}

restore_inline <- function(text, placeholders) {
  for (key in names(placeholders)) {
    text <- gsub(key, placeholders[[key]], text, fixed = TRUE)
  }
  text
}

# Wrap safe_translate with inline protection
translate_line <- function(text) {
  if (trimws(text) == "") return(text)
  protected  <- protect_inline(text)
  translated <- safe_translate(protected$text)
  restore_inline(translated, protected$placeholders)
}

# --- Translate a single Rmd/md file ------------------------------------------
translate_rmd_file <- function(input_path, output_path) {
  message("\nTranslating: ", input_path, " -> ", output_path)
  
  in_con <- file(input_path, open = "r", encoding = "UTF-8")
  lines  <- readLines(in_con, warn = FALSE)
  close(in_con)
  
  out_lines  <- character(length(lines))
  in_yaml    <- FALSE
  yaml_start <- FALSE
  in_code    <- FALSE
  open_fence <- ""
  
  i <- 1
  while (i <= length(lines)) {
    line <- lines[i]
    
    # YAML front matter
    if (i == 1 && trimws(line) == "---") {
      in_yaml <- TRUE; yaml_start <- TRUE
      out_lines[i] <- line; i <- i + 1; next
    }
    if (in_yaml) {
      if (trimws(line) == "---" && !yaml_start) {
        in_yaml <- FALSE
        out_lines[i] <- line; i <- i + 1; next
      }
      yaml_start <- FALSE
      if (grepl("^title:", line)) {
        key   <- sub("^(title:\\s*).*", "\\1", line)
        value <- sub("^title:\\s*['\"]?(.*?)['\"]?\\s*$", "\\1", line)
        translated    <- translate_line(value)
        # Always wrap in double quotes — Mongolian chars/colons break unquoted YAML
        out_lines[i]  <- paste0(key, '"', translated, '"')
      } else {
        out_lines[i] <- line
      }
      i <- i + 1; next
    }
    
    # Fenced code/verbatim blocks
    # Handles all fence styles: ```{r}, ```{verbatim}, ````{verbatim}, plain ```
    # Uses the opening fence string to match the correct closing fence,
    # so ````{verbatim} is only closed by ```` and not by ```.
    fence_match <- regmatches(line, regexpr("^(`{3,}|~{3,})", line))
    if (length(fence_match) > 0) {
      fence_char <- fence_match[[1]]
      is_close   <- grepl(paste0("^`{", nchar(fence_char), "}\\s*$"), line)
      if (!in_code) {
        in_code    <- TRUE
        open_fence <- fence_char
      } else if (is_close && fence_char == open_fence) {
        in_code    <- FALSE
        open_fence <- ""
      }
      out_lines[i] <- line; i <- i + 1; next
    }
    if (in_code) {
      out_lines[i] <- line; i <- i + 1; next
    }
    if (in_code) {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Empty lines
    if (trimws(line) == "") {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Callout/div fences  ::: ::::
    if (grepl("^:{2,}", line)) {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Chunk options  #|
    if (grepl("^#\\|", line)) {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Image lines  ![...](...) — preserve entirely (fig/ paths must not change)
    if (grepl("^!\\[", line)) {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Markdown table rows
    if (grepl("^\\s*\\|", line)) {
      out_lines[i] <- line; i <- i + 1; next
    }
    
    # Headings
    if (grepl("^#{1,6}\\s", line)) {
      prefix <- sub("^(#{1,6}\\s).*", "\\1", line)
      text   <- sub("^#{1,6}\\s", "", line)
      out_lines[i] <- paste0(prefix, translate_line(text))
      i <- i + 1; next
    }
    
    # Blockquotes
    if (grepl("^>\\s?", line)) {
      prefix <- sub("^(>\\s?).*", "\\1", line)
      text   <- sub("^>\\s?", "", line)
      out_lines[i] <- if (trimws(text) == "") line else
        paste0(prefix, translate_line(text))
      i <- i + 1; next
    }
    
    # List items
    if (grepl("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s)", line)) {
      prefix <- sub("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s).*", "\\1", line)
      text   <- sub("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s)", "", line)
      out_lines[i] <- if (trimws(text) == "") line else
        paste0(prefix, translate_line(text))
      i <- i + 1; next
    }
    
    # Plain prose
    out_lines[i] <- translate_line(line)
    i <- i + 1
  }
  
  # Write as raw UTF-8 bytes — bypasses locale re-encoding on Windows
  dir_create(path_dir(output_path))
  out_text <- paste(out_lines, collapse = "\n")
  Encoding(out_text) <- "UTF-8"
  bin_con <- file(output_path, open = "wb")
  writeBin(charToRaw(enc2utf8(out_text)), bin_con)
  close(bin_con)
}

# --- Determine which files to translate --------------------------------------
changed_files_path <- Sys.getenv("CHANGED_FILES_PATH", unset = "")

if (nchar(changed_files_path) > 0 && file.exists(changed_files_path)) {
  message("CI mode — source: ", source_repo, "  target: ", target_repo)
  files_to_translate <- readLines(changed_files_path)
  files_to_translate <- files_to_translate[nchar(trimws(files_to_translate)) > 0]
} else {
  message("Local mode: translating all episodes in current directory")
  episode_files <- c(
    fs::dir_ls(EPISODES_DIR, glob = "*.Rmd"),
    fs::dir_ls(EPISODES_DIR, glob = "*.md")
  )
  files_to_translate <- c(episode_files, INDEX_FILE, SETUP_FILE)
  files_to_translate <- files_to_translate[file_exists(files_to_translate)]
  
  # --- Resume support --------------------------------------------------------
  # If the script failed partway through, list already-translated files here
  # to skip them and resume from where it left off.
  # Example:
  #   SKIP_FILES <- c(
  #     "episodes/01-introduction.Rmd",
  #     "episodes/02-r-basics.Rmd"
  #   )
  # Leave as SKIP_FILES <- c() to translate everything.
  # SKIP_FILES <- c(
  #   "episodes/manipulating_data.Rmd",
  #   "episodes/introduction-r-rstudio.Rmd",
  #   "episodes/introduction-r-packages-markdown.Rmd",
  #   "episodes/starting-with-data.Rmd"
  # )
  SKIP_FILES <- c()
  
  if (length(SKIP_FILES) > 0) {
    skipping <- basename(files_to_translate) %in% basename(SKIP_FILES)
    message("Skipping ", sum(skipping), " already-translated file(s):")
    for (f in files_to_translate[skipping]) message("  ", f)
    files_to_translate <- files_to_translate[!skipping]
  }
}

message("Files to translate: ", length(files_to_translate))

# --- Run translations --------------------------------------------------------
for (f in files_to_translate) {
  # Input: read from source_repo (English)
  input_path <- file.path(source_repo, f)
  
  # Output: write to same relative path inside target_repo (mn branch)
  output_path <- file.path(target_repo, f)
  
  if (!file_exists(input_path)) {
    message("  Source file not found, skipping: ", input_path)
    next
  }
  
  translate_rmd_file(input_path, output_path)
}

message("\n=== Done! Check translated files in: ", target_repo)
