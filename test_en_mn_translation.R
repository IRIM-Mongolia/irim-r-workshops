# =============================================================================
# test_translation.R
#
# Test script: translates a single episode file from English (EN) to Mongolian (MN) and saves the
# result to a temporary output folder so you can inspect it without touching
# your actual mn branch.
#
# Usage (from your repo root in RStudio):
#   source("test_translation.R")
#
# Or to test a specific file, set TEST_FILE first:
#   TEST_FILE <- "episodes/introduction-r-packages-markdown.Rmd"
#   source("test_translation.R")
#
# Output: test-translation-output/<filename>.Rmd
#   Open this file to check the Mongolian text and confirm:
#     - Code chunks are untouched
#     - Headings are translated
#     - Prose is translated
#     - Figure paths like fig/packages_pane.png are unchanged
# =============================================================================

# TEST_FILE <- "episodes/introduction-r-rstudio.Rmd"
# TEST_FILE <- "episodes/introduction-r-packages-markdown.Rmd"
# TEST_FILE <- "episodes/starting-with-data.Rmd"
# TEST_FILE <- "episodes/manipulating_data.Rmd"
TEST_FILE <- "learners/setup.md"


for (pkg in c("httr2", "fs", "jsonlite")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}
library(httr2)
library(fs)
library(jsonlite)

# --- Configuration -----------------------------------------------------------
SOURCE_LANG  <- "en"
TARGET_LANG  <- "mn"
SLEEP_SECS   <- 1.5
OUT_DIR      <- "test-translation-output"

# --- Pick file to test -------------------------------------------------------
# Defaults to first .Rmd found in episodes/ or learners/
if (!exists("TEST_FILE")) {
  candidates <- c(
    fs::dir_ls("episodes", glob = "*.Rmd"),
    fs::dir_ls("episodes", glob = "*.md"),
    fs::dir_ls("learners", glob = "*.Rmd"),
    fs::dir_ls("learners", glob = "*.md")
  )
  if (length(candidates) == 0)
    stop("No .Rmd/.md files found in episodes/ or learners/. ",
         "Are you running from the repo root?")
  TEST_FILE <- candidates[[1]]
}

if (!file_exists(TEST_FILE)) {
  stop("File not found: ", TEST_FILE, "\nAre you running from the repo root?")
}

output_path <- file.path(OUT_DIR, path_file(TEST_FILE))

message("=== Test translation ===")
message("Input:   ", TEST_FILE)
message("Output:  ", output_path)
message("Lang:    ", SOURCE_LANG, " -> ", TARGET_LANG)
message("")

# --- Translation (same as translate_en_mn.R) ---------------------------------
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

protect_inline <- function(text) {
  chars        <- strsplit(text, "")[[1]]
  n            <- length(chars)
  placeholders <- list()
  counter      <- 0L
  result       <- character(0)
  i            <- 1L
  
  while (i <= n) {
    if (chars[i] == "`") {
      j <- i
      while (j <= n && chars[j] == "`") j <- j + 1L
      tick_count <- j - i
      
      k     <- j
      found <- FALSE
      while (k <= n) {
        if (chars[k] == "`") {
          end <- k
          while (end <= n && chars[end] == "`") end <- end + 1L
          if ((end - k) == tick_count) {
            span <- paste(chars[i:(end - 1L)], collapse = "")
            key  <- paste0("PLACEHOLDER", counter)
            placeholders[[key]] <- span
            result  <- c(result, key)
            counter <- counter + 1L
            i       <- end
            found   <- TRUE
            break
          } else {
            k <- end
          }
        } else {
          k <- k + 1L
        }
      }
      
      if (!found) {
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

translate_line <- function(text) {
  if (trimws(text) == "") return(text)
  protected  <- protect_inline(text)
  translated <- safe_translate(protected$text)
  restore_inline(translated, protected$placeholders)
}

# --- Line-by-line processor with progress + summary -------------------------
translate_rmd_file <- function(input_path, output_path) {
  in_con <- file(input_path, open = "r", encoding = "UTF-8")
  lines  <- readLines(in_con, warn = FALSE)
  close(in_con)
  
  total      <- length(lines)
  out_lines  <- character(total)
  in_yaml    <- FALSE
  yaml_start <- FALSE
  in_code    <- FALSE
  open_fence <- ""
  
  n_translated <- 0L
  n_skipped    <- 0L
  n_code       <- 0L
  
  i <- 1L
  while (i <= length(lines)) {
    line <- lines[i]
    
    # Progress every 10 translated lines
    if (n_translated > 0L && n_translated %% 10L == 0L)
      message(sprintf("  line %d / %d  (translated: %d  skipped: %d  in-code: %d)",
                      i, total, n_translated, n_skipped, n_code))
    
    # YAML front matter
    if (i == 1L && trimws(line) == "---") {
      in_yaml <- TRUE; yaml_start <- TRUE
      out_lines[i] <- line; i <- i + 1L; next
    }
    if (in_yaml) {
      if (trimws(line) == "---" && !yaml_start) {
        in_yaml <- FALSE
        out_lines[i] <- line; i <- i + 1L; next
      }
      yaml_start <- FALSE
      if (grepl("^title:", line)) {
        key        <- sub("^(title:\\s*).*", "\\1", line)
        value      <- sub("^title:\\s*['\"]?(.*?)['\"]?\\s*$", "\\1", line)
        translated <- translate_line(value)
        out_lines[i] <- paste0(key, '"', translated, '"')
        n_translated <- n_translated + 1L
      } else {
        out_lines[i] <- line
        n_skipped <- n_skipped + 1L
      }
      i <- i + 1L; next
    }
    
    # Fenced code blocks
    fence_match <- regmatches(line, regexpr("^(`{3,}|~{3,})", line))
    if (length(fence_match) > 0) {
      fence_char <- fence_match[[1]]
      is_close   <- grepl(paste0("^`{", nchar(fence_char), "}\\s*$"), line)
      if (!in_code) {
        in_code <- TRUE; open_fence <- fence_char
      } else if (is_close && fence_char == open_fence) {
        in_code <- FALSE; open_fence <- ""
      }
      out_lines[i] <- line; i <- i + 1L; next
    }
    if (in_code) {
      out_lines[i] <- line
      n_code <- n_code + 1L
      i <- i + 1L; next
    }
    
    # Lines never translated
    if (trimws(line) == "" ||
        grepl("^:{2,}", line) ||
        grepl("^#\\|", line) ||
        grepl("^!\\[", line) ||
        grepl("^\\s*\\|", line)) {
      out_lines[i] <- line
      n_skipped <- n_skipped + 1L
      i <- i + 1L; next
    }
    
    # Headings
    if (grepl("^#{1,6}\\s", line)) {
      prefix <- sub("^(#{1,6}\\s).*", "\\1", line)
      text   <- sub("^#{1,6}\\s", "", line)
      out_lines[i] <- paste0(prefix, translate_line(text))
      n_translated <- n_translated + 1L
      i <- i + 1L; next
    }
    
    # Blockquotes
    if (grepl("^>\\s?", line)) {
      prefix <- sub("^(>\\s?).*", "\\1", line)
      text   <- sub("^>\\s?", "", line)
      if (trimws(text) == "") {
        out_lines[i] <- line; n_skipped <- n_skipped + 1L
      } else {
        out_lines[i] <- paste0(prefix, translate_line(text))
        n_translated <- n_translated + 1L
      }
      i <- i + 1L; next
    }
    
    # List items
    if (grepl("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s)", line)) {
      prefix <- sub("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s).*", "\\1", line)
      text   <- sub("^(\\s*[-*+]\\s|\\s*\\d+\\.\\s)", "", line)
      if (trimws(text) == "") {
        out_lines[i] <- line; n_skipped <- n_skipped + 1L
      } else {
        out_lines[i] <- paste0(prefix, translate_line(text))
        n_translated <- n_translated + 1L
      }
      i <- i + 1L; next
    }
    
    # Plain prose
    out_lines[i] <- translate_line(line)
    n_translated <- n_translated + 1L
    i <- i + 1L
  }
  
  # Write output
  dir_create(path_dir(output_path))
  out_text <- paste(out_lines, collapse = "\n")
  Encoding(out_text) <- "UTF-8"
  bin_con <- file(output_path, open = "wb")
  writeBin(charToRaw(enc2utf8(out_text)), bin_con)
  close(bin_con)
  
  message("")
  message("=== Summary ===")
  message(sprintf("  Total lines:  %d", total))
  message(sprintf("  Translated:   %d", n_translated))
  message(sprintf("  Skipped:      %d", n_skipped))
  message(sprintf("  Inside code:  %d", n_code))
  message("")
  message("Output: ", output_path)
  message("")
  message("Check:")
  message("  1. Mongolian text is not garbled")
  message("  2. Code chunks are untouched")
  message("  3. Inline code like `kable()` is untouched")
  message("  4. Figure paths like fig/xyz.png are unchanged")
  message("  5. YAML title is quoted")
  message("  6. ::: callout fences are unchanged")
}

# --- Run ---------------------------------------------------------------------
fs::dir_create(OUT_DIR)
translate_rmd_file(TEST_FILE, output_path)
