# =============================================================================
# find_replace.R
#
# Searches all text files in the repo for a string and replaces it.
#
# Usage (from repo root in RStudio):
#   Set SEARCH_STRING and REPLACE_STRING below, then source("find_replace.R")
#
# By default runs in DRY_RUN mode — prints matches without changing files.
# Set DRY_RUN <- FALSE to apply changes.
# =============================================================================

# --- Configuration -----------------------------------------------------------

SEARCH_STRING  <- "kathrynnapier.github.io"   # string to find
REPLACE_STRING <- "irim-mongolia.github.io"   # string to replace with

DRY_RUN <- FALSE   # set to FALSE to actually apply changes

# File extensions to search (add/remove as needed)
EXTENSIONS <- c("Rmd", "md", "R", "yaml", "yml", "txt", "html", "json")

# Folders to skip
SKIP_DIRS <- c(".git", "renv", "site", "node_modules")

# =============================================================================

library(fs)

# Build glob patterns for each extension
all_files <- unlist(lapply(EXTENSIONS, function(ext) {
  tryCatch(
    as.character(dir_ls(".", recurse = TRUE, glob = paste0("*.", ext))),
    error = function(e) character(0)
  )
}))

# Remove files inside skipped directories
skip_pattern <- paste(SKIP_DIRS, collapse = "|")
all_files <- all_files[!grepl(paste0("/(", skip_pattern, ")/"), all_files)]

message(sprintf("Searching %d files for: %s", length(all_files), SEARCH_STRING))
message(sprintf("Will replace with:      %s", REPLACE_STRING))
if (DRY_RUN) message("DRY RUN — no files will be changed\n")

matches_found <- 0
files_changed <- 0

for (f in all_files) {
  # Read as raw lines to preserve encoding
  con   <- file(f, open = "r", encoding = "UTF-8")
  lines <- tryCatch(readLines(con, warn = FALSE), error = function(e) NULL)
  close(con)
  if (is.null(lines)) next
  
  # Find matching lines
  hits <- grep(SEARCH_STRING, lines, fixed = TRUE)
  if (length(hits) == 0) next
  
  matches_found <- matches_found + length(hits)
  files_changed <- files_changed + 1
  
  message(sprintf("Found in: %s", f))
  for (h in hits) {
    message(sprintf("  Line %d: %s", h, trimws(lines[h])))
  }
  
  if (!DRY_RUN) {
    new_lines <- gsub(SEARCH_STRING, REPLACE_STRING, lines, fixed = TRUE)
    out_text  <- paste(new_lines, collapse = "\n")
    Encoding(out_text) <- "UTF-8"
    bin_con <- file(f, open = "wb")
    writeBin(charToRaw(enc2utf8(out_text)), bin_con)
    close(bin_con)
    message("  → Updated")
  }
}

message(sprintf(
  "\n=== %s ===\nMatches: %d across %d file(s)",
  if (DRY_RUN) "Dry run complete" else "Done",
  matches_found, files_changed
))

if (DRY_RUN && files_changed > 0) {
  message("\nTo apply changes, set DRY_RUN <- FALSE and re-run.")
}