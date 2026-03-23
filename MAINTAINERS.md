# IRIM R Workshops — Maintainer Guide

This guide explains how to edit workshop content and how the automated workflows keep the English and Mongolian sites in sync.

## Live Sites

| Language  | URL                                                    |
|-----------|--------------------------------------------------------|
| English   | <https://irim-mongolia.github.io/irim-r-workshops/>    |
| Mongolian | <https://irim-mongolia.github.io/irim-r-workshops/mn/> |

------------------------------------------------------------------------

## Repository Structure

```         
irim-r-workshops/
├── episodes/          ← Workshop lesson files (.Rmd)
├── learners/          ← Setup and reference files for learners (.md)
├── instructors/       ← Instructor notes
├── index.md           ← Homepage content
├── config.yaml        ← Site title, episode order, settings
├── translate_en_mn.R  ← Translation script (English → Mongolian)
├── test_en_mn_translation.R  ← Test a single file translation locally
└── .github/workflows/
    ├── docker_build_deploy.yaml   ← Builds and deploys the English site
    ├── translate-mongolian.yml    ← Auto-translates changed files → opens PR
    └── deploy-site-mn.yaml       ← Builds and deploys the Mongolian site
```

The repo has two long-lived branches:

| Branch | Purpose                                                       |
|--------|---------------------------------------------------------------|
| `main` | English source content — always edit here                     |
| `mn`   | Mongolian content — never edit directly, managed by workflows |

------------------------------------------------------------------------

## How to Edit Content

### Editing an existing episode

1.  Open the file in `episodes/` on the `main` branch (e.g. `episodes/introduction-r-rstudio.Rmd`)
2.  Make your changes
3.  Commit and push to `main`

That's it — the workflows handle everything else automatically (see below).

### Adding a new episode

1.  Create a new `.Rmd` file in `episodes/` on `main`
2.  Add the filename to `config.yaml` under the `episodes:` list in the order you want it to appear
3.  Commit and push to `main`

### Editing learner-facing pages

Setup instructions and reference material live in `learners/`. Edit `.md` files there directly on `main`.

### Editing the homepage

Edit `index.md` on `main`.

### Adding or replacing figures

Place image files in `episodes/fig/` and reference them in your `.Rmd` with:

``` markdown
![](fig/your-image.png){alt="Description of the image"}
```

Keep alt text free of special characters and inner quotes to avoid rendering issues.

------------------------------------------------------------------------

## How the Workflows Work

### 1. English site — `docker_build_deploy.yaml`

**Triggers:** any push to `main`

Builds the English lesson using the Carpentries Workbench Docker container and deploys it to the root of the `gh-pages` branch, which serves the English site at the root URL.

You do not need to do anything — this runs automatically on every push.

### 2. Translate to Mongolian — `translate-mongolian.yml`

**Triggers:** push to `main` that changes any file in `episodes/`, `learners/`, or `index.md`

This workflow:

1.  Detects which files changed in your push
2.  Translates only those files from English to Mongolian using Google Translate
3.  Opens a pull request into the `mn` branch titled **🇲🇳 Update Mongolian translations — filename.Rmd**

You then:

1.  Go to the **Pull requests** tab
2.  Review the translated files (ideally with a native Mongolian speaker)
3.  Merge the PR when satisfied

### 3. Deploy Mongolian site — `deploy-site-mn.yaml`

**Triggers:** any push to the `mn` branch (i.e. when a translation PR is merged)

Builds the Mongolian lesson using the same Carpentries Workbench Docker container and deploys it into the `mn/` subfolder of `gh-pages`, serving the Mongolian site at the `/mn/` URL.

This runs automatically when a translation PR is merged — no manual steps needed.

------------------------------------------------------------------------

## Full Pipeline: From Edit to Published

```         
You edit an episode on main and push
            ↓
English site rebuilds automatically
            ↓
translate-mongolian.yml detects the change
            ↓
Opens PR: auto/mongolian-translations → mn
            ↓
You review and merge the PR
            ↓
deploy-site-mn.yaml triggers on push to mn
            ↓
Mongolian site rebuilds and publishes
```

------------------------------------------------------------------------

## What Gets Translated (and What Doesn't)

The translation script processes `.Rmd` and `.md` files line by line. Understanding what is and isn't translated helps when reviewing translation PRs or debugging unexpected output.

### Translated

-   Prose paragraphs
-   Headings (`## Heading text`)
-   List items (`- item text`)
-   Blockquotes (`> text`)
-   The `title:` value in the YAML front matter
-   Text inside `::: callout`, `::: challenge`, and `::: solution` blocks (the fence lines themselves are preserved, but the content inside is translated)

### Never translated

| Content | Example |
|------------------------------------|------------------------------------|
| R code chunks | ```` ```{r chunk-name} ... ``` ```` |
| Verbatim blocks | ````` ````{verbatim} ... ```` ````` |
| Inline code | `` `kable()` `` |
| Markdown links (URL only) | `[link text](https://example.com)` — text is translated, URL is not |
| HTML tags | `<kbd>Ctrl</kbd>`, `<b>bold</b>` |
| YAML fields (except title) | `teaching: 45`, `source: Rmd` |
| Image lines | `![](fig/image.png)` |
| Markdown table rows | Lines starting with `\|` |
| Callout fence lines | `::: callout`, `:::: challenge`, `:::` |
| Chunk options | Lines starting with `#\|` |
| Empty lines | Preserved exactly |

### Notes on inline content

Within a translated line, the script protects certain content before sending it to Google Translate and restores it afterwards:

-   **Inline code** — any backtick-delimited span (`` `code` ``, ``` ``r`` ```, ```` ``` ``r "..."`` ``` ````) is replaced with a `{N}` placeholder and restored after translation
-   **URLs** — the URL part of `[text](url)` is protected; only the link text is translated

This means a line like:

```         
Press **`Ctrl+Shift+M`** to insert a pipe operator `%>%`
```

will have the `` `Ctrl+Shift+M` `` and `` `%>%` `` protected, so only the surrounding prose is translated. Tip- having many placeholders close together significantly slows down the translation script, so do use `Ctrl+Shift+M` instead of `Ctrl`+`Shift`+`M`.

------------------------------------------------------------------------

## Testing Translations Locally

Before running a full translation, you can test a single file using `test_en_mn_translation.R`:

``` r
# In RStudio, from the repo root
# Test default (first episode found)
source("test_en_mn_translation.R")

# Or test a specific file
TEST_FILE <- "episodes/introduction-r-rstudio.Rmd"
source("test_en_mn_translation.R")

# Or test a learners file
TEST_FILE <- "learners/setup.md"
source("test_en_mn_translation.R")
```

Output is saved to `test-translation-output/` — open the file to check the translation quality before pushing.

------------------------------------------------------------------------

## Running a Full Translation Locally

If you need to re-translate all files (e.g. after major content changes), check out the `mn` branch locally and run:

``` r
# In RStudio, with mn branch checked out
source("translate_en_mn.R")
```

Then commit and push to `mn`:

``` bash
git add episodes/ learners/ index.md
git commit -m "Re-translate all content to Mongolian"
git push origin mn
```

To skip files that have already been translated, set `SKIP_FILES` near the top of `translate_en_mn.R` before running.

------------------------------------------------------------------------

## Troubleshooting

**Translation PR not opening after a push** Check the Actions tab — look at the "Translate to Mongolian" run and expand the "Detect changed English source files" step. If it shows no changed files, the push may not have touched any watched file paths.

**Mongolian site not updating after merging a translation PR** Check the Actions tab for a "Build and Deploy Mongolian Site" run triggered after the merge. If it failed, check the logs for the error.

**English site build failing with container version mismatch** The workflow uses the `latest` Docker tag by default. If you see a mismatch error, go to Settings → Secrets and variables → Actions → Variables and check whether a `WORKBENCH_TAG` variable exists. If it does, either delete it (to use `latest` automatically) or update its value to match the current release at [github.com/carpentries/workbench-docker/releases](https://github.com/carpentries/workbench-docker/releases). If no variable exists, the error may be coming from a stale `.github/workbench-docker-version.txt` file in the repo — delete that file and push.

**Translation quality issues** The automated translation uses Google Translate.
