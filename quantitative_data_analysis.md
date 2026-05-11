---
title: Quantitative Data Analysis in R
teaching: 60
exercises: 30
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---

::: objectives
-   Read in data and ensure variables have the correct data type
-   Perform exploratory data analysis
-   Identify the correct statistical test for a given variable type and research question
-   Run Chi-square tests, t-tests, and one-way ANOVAs in R Notebooks
-   Interpret p-values, test statistics, and effect sizes in context
-   Write clear explanatory text in R Notebooks to document analytical
    decisions
-   Recognise the assumptions underlying each test and check them in R
:::

::: questions
-   What statistical tests should I use?
-   How can I run multiple tests at once?
:::

## Other materials

[See Workshop 5 Slides
here](https://irimmn.sharepoint.com/:p:/s/IRIMRWorkshops/IQAu_EPJ2JxWSKEWpe68tf12Ac_tkOYCOrSG-ls8oE8Qcro?e=0kUTeI)

[See Workshop 5 recording here -
1](https://irimmn.sharepoint.com/:v:/s/IRIMRWorkshops/IQDDs6ewnFXFSZFVox-GZ6UrAc-0RSCVDCZGcEEp3_aZJbs?e=zdebp3)

## Dataset Overview

This workshop uses a generated (made-up) dataset containing 1005
responses to a survey on flexible working and work-life balance, with a
number of different data types.

The schema is included in the following table.

**Flexible working and work-life balance survey data schema** 

| Section | Variable | Type | Description |
|---|---|---|---|
| **A (Demographics)** | A1 – Gender | Factor (male, female) | What is your gender? |
| | A2 – Age Group | Ordered Factor (18–34, 35–54, 55+) | What is your age? |
| | A3 – Education | Ordered Factor (primary, secondary, tertiary+) | What is your highest level of education? |
| | A4 – Income | Ordered Factor (low, middle, high) | What is your annual income? |
| | A5 – Region | Factor (region 1, 2, 3) | What is your region of residence? |
| | A6 – Area Type | Factor (rural, urban) | Is your region of residence urban or rural? |
| **B (Policy Views)** | B1 | Character | What should be the main goal of flexible working policies? (Select up to 3) |
| | B1_1 | Logical | Improve employee wellbeing & work-life balance |
| | B1_2 | Logical | Boost productivity & business performance |
| | B1_3 | Logical | Attract & retain top talent |
| | B1_4 | Logical | Reduce costs & office overhead |
| | B1_5 | Logical | Support diversity, equity & inclusion |
| | B2 | Character | Who should benefit most from flexible working arrangements? (Select up to 3) |
| | B2_1 | Logical | All employees equally, regardless of role or seniority |
| | B2_2 | Logical | Parents and caregivers with dependants |
| | B2_3 | Logical | Employees with disabilities or chronic health conditions |
| | B2_4 | Logical | Junior/entry-level employees building their careers |
| | B2_5 | Logical | Senior/experienced employees with proven track records |
| | B2_6 | Logical | Employees with long commutes or remote locations |
| | B2_7 | Logical | Employees from underrepresented or marginalised groups |
| | B2_8 | Logical | High performers and those meeting targets consistently |
| **C (Satisfaction)** | C1 | Integer (1–5) | How satisfied are you with your current flexible working arrangements? (1 = least satisfied, 5 = most satisfied) |
| | C2 | Integer (1–5) | To what extent do flexible working options improve your work-life balance? (1 = very little, 5 = very much) |
| | C3 | Integer (1–5) | How strongly do you agree that your employer supports flexible working in practice? (1 = very little, 5 = very much) |
| **D (Commute)** | D1 | Numeric | What is your commute time to work in minutes? |
| | D2 | Numeric | What is your commute distance in km? |
| **E (Outcomes)** | E1 | Ordered Factor (strongly dissatisfied → strongly satisfied) | How satisfied are you with your current work-life balance? |
| | E2 | Free text | What makes you most satisfied in your personal life? |



## Set up

Start by opening up your `RStudio` project that you created in a
[previous
workshop](https://irim-mongolia.github.io/irim-r-workshops/introduction-r-rstudio.html#getting-set-up-in-rstudio),
called `intro_r`, in a new session. Ensure your `global environment` is
empty! You can also 'sweep' your `global environment` by clicking the
`broom` icon.

![](fig/empty_env.png){alt="Screenshot of RStudio showing the empty global environment."}

Open a new `R Notebook`: `Click File -> New File -> R Notebook`. Save
your `R Notebook` with a filename that makes sense, such as
`quantitative_analysis.Rmd`, in the `scripts` folder.

When you open a new `R Notebook`, some explanatory text is provided.
This can be deleted so you can enter your own text and code.

### Load packages and download data

Download packages (if needed) and load libraries. We'll be using the
`gtsummary` package for the first time, so this will need to be
installed.


``` r
for (pkg in c("tidyverse", "here", "gtsummary", "scales", "corrplot", "epitools", "rcompanion")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}
```

``` output
- Querying repositories for available source packages ... Done!
The following package(s) will be installed:
- bigD       [0.3.1]
- bitops     [1.0-9]
- cards      [0.7.1]
- cardx      [0.3.2]
- gt         [1.3.0]
- gtsummary  [2.5.0]
- juicyjuice [0.1.0]
- reactable  [0.4.5]
- reactR     [0.6.1]
These packages will be installed into "/__w/irim-r-workshops/irim-r-workshops/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-noble/R-4.5/x86_64-pc-linux-gnu".

# Downloading packages -------------------------------------------------------
[32m✔[0m bitops 1.0-9                             [11 kB in 0.23s]
[32m✔[0m reactR 0.6.1                             [712 kB in 0.24s]
[32m✔[0m reactable 0.4.5                          [981 kB in 0.24s]
[32m✔[0m juicyjuice 0.1.0                         [1.1 MB in 0.26s]
[32m✔[0m cardx 0.3.2                              [200 kB in 0.27s]
[32m✔[0m cards 0.7.1                              [321 kB in 0.27s]
[32m✔[0m gtsummary 2.5.0                          [935 kB in 0.27s]
[32m✔[0m bigD 0.3.1                               [1.3 MB in 0.28s]
[32m✔[0m gt 1.3.0                                 [3.4 MB in 0.29s]
Successfully downloaded 9 packages in 0.61 seconds.

# Installing packages --------------------------------------------------------
[32m✔[0m juicyjuice 0.1.0                         [built from source in 5.8s]
[32m✔[0m bitops 1.0-9                             [built from source in 7.9s]
[32m✔[0m reactR 0.6.1                             [built from source in 7.6s]
[32m✔[0m cards 0.7.1                              [built from source in 22s]
[32m✔[0m reactable 0.4.5                          [built from source in 10s]
[32m✔[0m bigD 0.3.1                               [built from source in 28s]
[32m✔[0m cardx 0.3.2                              [built from source in 12s]
[32m✔[0m gt 1.3.0                                 [built from source in 22s]
[32m✔[0m gtsummary 2.5.0                          [built from source in 10s]
Successfully installed 9 packages in 61 seconds.
The following package(s) will be installed:
- corrplot [0.95]
These packages will be installed into "/__w/irim-r-workshops/irim-r-workshops/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-noble/R-4.5/x86_64-pc-linux-gnu".

# Downloading packages -------------------------------------------------------
[32m✔[0m corrplot 0.95                            [3.7 MB in 0.83s]
Successfully downloaded 1 package in 1.1 seconds.

# Installing packages --------------------------------------------------------
[32m✔[0m corrplot 0.95                            [built from source in 2.5s]
Successfully installed 1 package in 2.6 seconds.
The following package(s) will be installed:
- epitools [0.5-10.1]
These packages will be installed into "/__w/irim-r-workshops/irim-r-workshops/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-noble/R-4.5/x86_64-pc-linux-gnu".

# Downloading packages -------------------------------------------------------
[32m✔[0m epitools 0.5-10.1                        [91 kB in 56s]
Successfully downloaded 1 package in 0.34 seconds.

# Installing packages --------------------------------------------------------
[32m✔[0m epitools 0.5-10.1                        [built from source in 4.1s]
Successfully installed 1 package in 4.2 seconds.
The following package(s) will be installed:
- coin         [1.4-3]
- DescTools    [0.99.60]
- e1071        [1.7-17]
- Exact        [3.3]
- expm         [1.0-0]
- gld          [2.6.8]
- libcoin      [1.0-12]
- lmom         [3.3]
- lmtest       [0.9-40]
- matrixStats  [1.5.0]
- modeltools   [0.2-24]
- multcomp     [1.4-30]
- multcompView [0.1-11]
- mvtnorm      [1.3-7]
- nortest      [1.0-4]
- plyr         [1.8.9]
- proxy        [0.4-29]
- rcompanion   [2.5.2]
- rootSolve    [1.8.2.4]
- sandwich     [3.1-1]
- TH.data      [1.1-5]
- zoo          [1.8-15]
These packages will be installed into "/__w/irim-r-workshops/irim-r-workshops/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-noble/R-4.5/x86_64-pc-linux-gnu".

# Downloading packages -------------------------------------------------------
[32m✔[0m nortest 1.0-4                            [6 kB in 0.41s]
[32m✔[0m modeltools 0.2-24                        [15 kB in 0.41s]
[32m✔[0m gld 2.6.8                                [55 kB in 0.42s]
[32m✔[0m e1071 1.7-17                             [318 kB in 0.42s]
[32m✔[0m expm 1.0-0                               [141 kB in 0.42s]
[32m✔[0m plyr 1.8.9                               [401 kB in 0.43s]
[32m✔[0m rcompanion 2.5.2                         [162 kB in 0.43s]
[32m✔[0m lmom 3.3                                 [347 kB in 0.43s]
[32m✔[0m rootSolve 1.8.2.4                        [504 kB in 0.43s]
[32m✔[0m multcomp 1.4-30                          [689 kB in 0.43s]
[32m✔[0m multcompView 0.1-11                      [157 kB in 0.43s]
[32m✔[0m sandwich 3.1-1                           [1.4 MB in 0.44s]
[32m✔[0m matrixStats 1.5.0                        [212 kB in 29s]
[32m✔[0m mvtnorm 1.3-7                            [976 kB in 0.44s]
[32m✔[0m coin 1.4-3                               [1.0 MB in 0.45s]
[32m✔[0m DescTools 0.99.60                        [2.7 MB in 0.45s]
[32m✔[0m Exact 3.3                                [45 kB in 41s]
[32m✔[0m zoo 1.8-15                               [806 kB in 33s]
[32m✔[0m lmtest 0.9-40                            [230 kB in 28s]
[32m✔[0m TH.data 1.1-5                            [8.6 MB in 0.47s]
[32m✔[0m proxy 0.4-29                             [71 kB in 45s]
[32m✔[0m libcoin 1.0-12                           [866 kB in 46s]
Successfully downloaded 22 packages in 0.76 seconds.

# Installing packages --------------------------------------------------------
[32m✔[0m modeltools 0.2-24                        [built from source in 14s]
[32m✔[0m lmom 3.3                                 [built from source in 24s]
[32m✔[0m multcompView 0.1-11                      [built from source in 10s]
[32m✔[0m expm 1.0-0                               [built from source in 32s]
[32m✔[0m nortest 1.0-4                            [built from source in 6.8s]
[32m✔[0m proxy 0.4-29                             [built from source in 16s]
[32m✔[0m mvtnorm 1.3-7                            [built from source in 34s]
[32m✔[0m matrixStats 1.5.0                        [built from source in 1.2m]
[32m✔[0m TH.data 1.1-5                            [built from source in 16s]
[32m✔[0m plyr 1.8.9                               [built from source in 43s]
[32m✔[0m rootSolve 1.8.2.4                        [built from source in 42s]
[32m✔[0m libcoin 1.0-12                           [built from source in 21s]
[32m✔[0m zoo 1.8-15                               [built from source in 29s]
[32m✔[0m e1071 1.7-17                             [built from source in 32s]
[32m✔[0m Exact 3.3                                [built from source in 18s]
[32m✔[0m lmtest 0.9-40                            [built from source in 15s]
[32m✔[0m sandwich 3.1-1                           [built from source in 16s]
[32m✔[0m gld 2.6.8                                [built from source in 11s]
[32m✔[0m multcomp 1.4-30                          [built from source in 11s]
[32m✔[0m coin 1.4-3                               [built from source in 17s]
[32m✔[0m DescTools 0.99.60                        [built from source in 58s]
[32m✔[0m rcompanion 2.5.2                         [built from source in 10s]
Successfully installed 22 packages in 190 seconds.
```

``` r
library(tidyverse)
library(here)
library(gtsummary) # summary tables
library(scales) # percent formatting for axes
library(corrplot) # correlation plots
library(rcompanion) # Cramér's V effect size
library(epitools) # odds ratios for 2×2 tables
```

Then, download the the generated survey dataset using the following
code:


``` r
download.file("https://raw.githubusercontent.com/IRIM-Mongolia/irim-r-workshops/main/episodes/data/raw/generated_survey_data.csv", here("data/raw/generated_survey_data.csv"), mode = "wb")
```


Then, read in the survey csv file and preview the data.


``` r
survey <- read_csv(here("data", "raw", "generated_survey_data.csv"))
```

``` output
Rows: 1005 Columns: 28
── Column specification ────────────────────────────────────────────────────────
Delimiter: ","
chr (10): A1, A2, A3, A4, A5, A6, B1, B2, E1, E2
dbl  (5): C1, C2, C3, D1, D2
lgl (13): B1_1, B1_2, B1_3, B1_4, B1_5, B2_1, B2_2, B2_3, B2_4, B2_5, B2_6, ...

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

``` r
survey # preview the data
```

``` output
# A tibble: 1,005 × 28
   A1    A2    A3    A4    A5    A6    B1    B1_1  B1_2  B1_3  B1_4  B1_5  B2   
   <chr> <chr> <chr> <chr> <chr> <chr> <chr> <lgl> <lgl> <lgl> <lgl> <lgl> <chr>
 1 male  18-34 seco… low   regi… Urban <NA>  FALSE FALSE FALSE FALSE FALSE 1 4 7
 2 male  35-54 seco… midd… regi… Rural 2 4 5 FALSE TRUE  FALSE TRUE  TRUE  1 4 6
 3 fema… 35-54 tert… low   regi… Rural 2 3 4 FALSE TRUE  TRUE  TRUE  FALSE 3 6 7
 4 male  18-34 tert… low   regi… Urban 5     FALSE FALSE FALSE FALSE TRUE  3 5 8
 5 male  35-54 seco… high  regi… Rural 5     FALSE FALSE FALSE FALSE TRUE  2 5 6
 6 fema… 18-34 tert… high  regi… Urban 1 3 5 TRUE  FALSE TRUE  FALSE TRUE  3 6  
 7 male  35-54 seco… high  regi… Urban 2 4 5 FALSE TRUE  FALSE TRUE  TRUE  2 6 7
 8 fema… 18-34 tert… midd… regi… Rural 3 4 5 FALSE FALSE TRUE  TRUE  TRUE  6 7 8
 9 male  18-34 tert… low   regi… Urban 2 4   FALSE TRUE  FALSE TRUE  FALSE 2 5 8
10 male  18-34 prim… midd… regi… Urban 5     FALSE FALSE FALSE FALSE TRUE  5 8  
# ℹ 995 more rows
# ℹ 15 more variables: B2_1 <lgl>, B2_2 <lgl>, B2_3 <lgl>, B2_4 <lgl>,
#   B2_5 <lgl>, B2_6 <lgl>, B2_7 <lgl>, B2_8 <lgl>, C1 <dbl>, C2 <dbl>,
#   C3 <dbl>, D1 <dbl>, D2 <dbl>, E1 <chr>, E2 <chr>
```

## Process data

Let's inspect the dataframe and see how R classified the data types.


``` r
str(survey)
```

``` output
spc_tbl_ [1,005 × 28] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
 $ A1  : chr [1:1005] "male" "male" "female" "male" ...
 $ A2  : chr [1:1005] "18-34" "35-54" "35-54" "18-34" ...
 $ A3  : chr [1:1005] "secondary" "secondary" "tertiary or higher" "tertiary or higher" ...
 $ A4  : chr [1:1005] "low" "middle" "low" "low" ...
 $ A5  : chr [1:1005] "region3" "region1" "region1" "region3" ...
 $ A6  : chr [1:1005] "Urban" "Rural" "Rural" "Urban" ...
 $ B1  : chr [1:1005] NA "2 4 5" "2 3 4" "5" ...
 $ B1_1: logi [1:1005] FALSE FALSE FALSE FALSE FALSE TRUE ...
 $ B1_2: logi [1:1005] FALSE TRUE TRUE FALSE FALSE FALSE ...
 $ B1_3: logi [1:1005] FALSE FALSE TRUE FALSE FALSE TRUE ...
 $ B1_4: logi [1:1005] FALSE TRUE TRUE FALSE FALSE FALSE ...
 $ B1_5: logi [1:1005] FALSE TRUE FALSE TRUE TRUE TRUE ...
 $ B2  : chr [1:1005] "1 4 7" "1 4 6" "3 6 7" "3 5 8" ...
 $ B2_1: logi [1:1005] TRUE TRUE FALSE FALSE FALSE FALSE ...
 $ B2_2: logi [1:1005] FALSE FALSE FALSE FALSE TRUE FALSE ...
 $ B2_3: logi [1:1005] FALSE FALSE TRUE TRUE FALSE TRUE ...
 $ B2_4: logi [1:1005] TRUE TRUE FALSE FALSE FALSE FALSE ...
 $ B2_5: logi [1:1005] FALSE FALSE FALSE TRUE TRUE FALSE ...
 $ B2_6: logi [1:1005] FALSE TRUE TRUE FALSE TRUE TRUE ...
 $ B2_7: logi [1:1005] TRUE FALSE TRUE FALSE FALSE FALSE ...
 $ B2_8: logi [1:1005] FALSE FALSE FALSE TRUE FALSE FALSE ...
 $ C1  : num [1:1005] 5 1 4 1 1 5 3 4 4 3 ...
 $ C2  : num [1:1005] 3 5 3 3 2 2 3 5 3 2 ...
 $ C3  : num [1:1005] 3 1 2 3 4 4 1 1 1 5 ...
 $ D1  : num [1:1005] 99 44 52 77 80 99 56 102 79 86 ...
 $ D2  : num [1:1005] 40 34 12 43 13 25 36 37 48 28 ...
 $ E1  : chr [1:1005] "Neutral" "Strongly satisfied" "Dissatisfied" "Neutral" ...
 $ E2  : chr [1:1005] "I really enjoy meeting up with friends and would recommend it" "I really enjoy meeting up with friends and find it rewarding" "I would say reading in my spare time as much as I can" "I often find myself cooking at home and would recommend it" ...
 - attr(*, "spec")=
  .. cols(
  ..   A1 = col_character(),
  ..   A2 = col_character(),
  ..   A3 = col_character(),
  ..   A4 = col_character(),
  ..   A5 = col_character(),
  ..   A6 = col_character(),
  ..   B1 = col_character(),
  ..   B1_1 = col_logical(),
  ..   B1_2 = col_logical(),
  ..   B1_3 = col_logical(),
  ..   B1_4 = col_logical(),
  ..   B1_5 = col_logical(),
  ..   B2 = col_character(),
  ..   B2_1 = col_logical(),
  ..   B2_2 = col_logical(),
  ..   B2_3 = col_logical(),
  ..   B2_4 = col_logical(),
  ..   B2_5 = col_logical(),
  ..   B2_6 = col_logical(),
  ..   B2_7 = col_logical(),
  ..   B2_8 = col_logical(),
  ..   C1 = col_double(),
  ..   C2 = col_double(),
  ..   C3 = col_double(),
  ..   D1 = col_double(),
  ..   D2 = col_double(),
  ..   E1 = col_character(),
  ..   E2 = col_character()
  .. )
 - attr(*, "problems")=<externalptr> 
```

From the information available in our data schema, we know that we have
several columns that will need to be converted to factors before we can
proceed with our analysis. We'll use `mutate` and `factor` to convert
the columns as needed.

We'll start with the Demographic data in section A.


``` r
survey <- survey %>% 
  mutate(
    A1 = factor(A1,
                levels = c("male", "female")),
    A2 = factor(A2,
                levels = c("18-34", "35-54", "55+"),
                ordered = TRUE),
    A3 = factor(A3,
                levels = c("primary", "secondary", "tertiary or higher"),
                ordered = TRUE),
    A4 = factor(A4,
                levels = c("low", "middle", "high"),
                ordered = TRUE),
    A5 = factor(A5,
                levels = c("region1", "region2", "region3")),
    A6 = factor(A6,
                levels = c("Rural", "Urban"))
  )
```

Let's take a quick look at the dataframe.


``` r
str(survey)
```

``` output
tibble [1,005 × 28] (S3: tbl_df/tbl/data.frame)
 $ A1  : Factor w/ 2 levels "male","female": 1 1 2 1 1 2 1 2 1 1 ...
 $ A2  : Ord.factor w/ 3 levels "18-34"<"35-54"<..: 1 2 2 1 2 1 2 1 1 1 ...
 $ A3  : Ord.factor w/ 3 levels "primary"<"secondary"<..: 2 2 3 3 2 3 2 3 3 1 ...
 $ A4  : Ord.factor w/ 3 levels "low"<"middle"<..: 1 2 1 1 3 3 3 2 1 2 ...
 $ A5  : Factor w/ 3 levels "region1","region2",..: 3 1 1 3 1 3 3 1 3 3 ...
 $ A6  : Factor w/ 2 levels "Rural","Urban": 2 1 1 2 1 2 2 1 2 2 ...
 $ B1  : chr [1:1005] NA "2 4 5" "2 3 4" "5" ...
 $ B1_1: logi [1:1005] FALSE FALSE FALSE FALSE FALSE TRUE ...
 $ B1_2: logi [1:1005] FALSE TRUE TRUE FALSE FALSE FALSE ...
 $ B1_3: logi [1:1005] FALSE FALSE TRUE FALSE FALSE TRUE ...
 $ B1_4: logi [1:1005] FALSE TRUE TRUE FALSE FALSE FALSE ...
 $ B1_5: logi [1:1005] FALSE TRUE FALSE TRUE TRUE TRUE ...
 $ B2  : chr [1:1005] "1 4 7" "1 4 6" "3 6 7" "3 5 8" ...
 $ B2_1: logi [1:1005] TRUE TRUE FALSE FALSE FALSE FALSE ...
 $ B2_2: logi [1:1005] FALSE FALSE FALSE FALSE TRUE FALSE ...
 $ B2_3: logi [1:1005] FALSE FALSE TRUE TRUE FALSE TRUE ...
 $ B2_4: logi [1:1005] TRUE TRUE FALSE FALSE FALSE FALSE ...
 $ B2_5: logi [1:1005] FALSE FALSE FALSE TRUE TRUE FALSE ...
 $ B2_6: logi [1:1005] FALSE TRUE TRUE FALSE TRUE TRUE ...
 $ B2_7: logi [1:1005] TRUE FALSE TRUE FALSE FALSE FALSE ...
 $ B2_8: logi [1:1005] FALSE FALSE FALSE TRUE FALSE FALSE ...
 $ C1  : num [1:1005] 5 1 4 1 1 5 3 4 4 3 ...
 $ C2  : num [1:1005] 3 5 3 3 2 2 3 5 3 2 ...
 $ C3  : num [1:1005] 3 1 2 3 4 4 1 1 1 5 ...
 $ D1  : num [1:1005] 99 44 52 77 80 99 56 102 79 86 ...
 $ D2  : num [1:1005] 40 34 12 43 13 25 36 37 48 28 ...
 $ E1  : chr [1:1005] "Neutral" "Strongly satisfied" "Dissatisfied" "Neutral" ...
 $ E2  : chr [1:1005] "I really enjoy meeting up with friends and would recommend it" "I really enjoy meeting up with friends and find it rewarding" "I would say reading in my spare time as much as I can" "I often find myself cooking at home and would recommend it" ...
```

We have one more column `E1` to convert to a factor. If we're not sure
of the levels we need to set, we can use `unique` to extract the unique
responses from the column. You can use the `$` operator to subset the
column, or double brackets `[["colname"]]`.


``` r
unique(survey$E1)
```

``` output
[1] "Neutral"               "Strongly satisfied"    "Dissatisfied"         
[4] "Strongly dissatisfied" "Satisfied"             NA                     
```

``` r
unique(survey[["E1"]])
```

``` output
[1] "Neutral"               "Strongly satisfied"    "Dissatisfied"         
[4] "Strongly dissatisfied" "Satisfied"             NA                     
```

Now let's convert `E1` to an ordered factor.


``` r
survey <- survey %>% 
  mutate(E1 = factor(E1,
                     levels = c("Strongly dissatisfied", "Dissatisfied", "Neutral", "Satisfied", "Strongly satisfied"),
                     ordered = TRUE))
```

And check column `E1`.


``` r
class(survey[["E1"]])
```

``` output
[1] "ordered" "factor" 
```


``` r
levels(survey[["E1"]])
```

``` output
[1] "Strongly dissatisfied" "Dissatisfied"          "Neutral"              
[4] "Satisfied"             "Strongly satisfied"   
```

## Exploratory data analysis

Before running any statistical tests, it is important to carry out some
exploratory data analysis (EDA) to understand the structure and quality
of your data.

EDA helps you check that variables have been read in with the correct
types, identify missing values, spot unexpected categories or data entry
errors, and understand the distribution of responses across key
variables.

For categorical variables like those in the survey data, frequency
tables and proportion summaries reveal how respondents are spread across
groups, which is important, as some tests (like Chi-square) require
minimum cell counts to be valid.

Let's investigate the proportion of missing data `NA` in our columns.


``` r
survey %>% 
  summarise(across(everything(), ~ sum(is.na(.)))) %>% 
  pivot_longer(everything(),
               names_to  = "variable",
               values_to = "n_missing") %>% 
  mutate(pct_missing = round(n_missing / nrow(survey) * 100, 1))  %>% 
  filter(n_missing > 0) %>% 
  arrange(desc(n_missing))
```

``` output
# A tibble: 3 × 3
  variable n_missing pct_missing
  <chr>        <int>       <dbl>
1 B1              23         2.3
2 E1               4         0.4
3 B2               1         0.1
```

### Frequency tables and proportions for categorical responses

Before stratifying by any grouping variable, it is useful to first
examine the overall distribution of responses across all categorical
variables in the dataset.

We'll use the function `tbl_summary()` from the `gtsummary` package to
produce a single frequency table covering every factor column,
displaying counts and column percentages for each response category.

This gives us a quick snapshot of sample composition and response
patterns, such as how respondents are distributed across age groups,
income levels, and regions.


``` r
# Overall frequency table for all factor columns
survey %>% 
  select(where(is.factor)) %>% 
  tbl_summary(
    statistic = list(all_categorical() ~ "{n} ({p}%)"), # count and proportion
    missing = "ifany" # show missing if present
  )
```

<!--html_preserve--><div id="qhectridsy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#qhectridsy table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#qhectridsy thead, #qhectridsy tbody, #qhectridsy tfoot, #qhectridsy tr, #qhectridsy td, #qhectridsy th {
  border-style: none;
}

#qhectridsy p {
  margin: 0;
  padding: 0;
}

#qhectridsy .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qhectridsy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#qhectridsy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qhectridsy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qhectridsy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qhectridsy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qhectridsy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qhectridsy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qhectridsy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qhectridsy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qhectridsy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qhectridsy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qhectridsy .gt_spanner_row {
  border-bottom-style: hidden;
}

#qhectridsy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#qhectridsy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qhectridsy .gt_from_md > :first-child {
  margin-top: 0;
}

#qhectridsy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qhectridsy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qhectridsy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#qhectridsy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#qhectridsy .gt_row_group_first td {
  border-top-width: 2px;
}

#qhectridsy .gt_row_group_first th {
  border-top-width: 2px;
}

#qhectridsy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qhectridsy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qhectridsy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qhectridsy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qhectridsy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qhectridsy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qhectridsy .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#qhectridsy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qhectridsy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qhectridsy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qhectridsy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qhectridsy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qhectridsy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qhectridsy .gt_left {
  text-align: left;
}

#qhectridsy .gt_center {
  text-align: center;
}

#qhectridsy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qhectridsy .gt_font_normal {
  font-weight: normal;
}

#qhectridsy .gt_font_bold {
  font-weight: bold;
}

#qhectridsy .gt_font_italic {
  font-style: italic;
}

#qhectridsy .gt_super {
  font-size: 65%;
}

#qhectridsy .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#qhectridsy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qhectridsy .gt_indent_1 {
  text-indent: 5px;
}

#qhectridsy .gt_indent_2 {
  text-indent: 10px;
}

#qhectridsy .gt_indent_3 {
  text-indent: 15px;
}

#qhectridsy .gt_indent_4 {
  text-indent: 20px;
}

#qhectridsy .gt_indent_5 {
  text-indent: 25px;
}

#qhectridsy .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#qhectridsy div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>N = 1,005</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">E1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Strongly dissatisfied</td>
<td headers="stat_0" class="gt_row gt_center">220 (22%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Dissatisfied</td>
<td headers="stat_0" class="gt_row gt_center">217 (22%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Neutral</td>
<td headers="stat_0" class="gt_row gt_center">205 (20%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Satisfied</td>
<td headers="stat_0" class="gt_row gt_center">216 (22%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Strongly satisfied</td>
<td headers="stat_0" class="gt_row gt_center">143 (14%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">4</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->


The survey data has a slightly female-majority, with a younger age distribution. We should keep this in mind when interpreting any later results that break down by gender and age.

#### Breakdown by demographics

We can also use the `tbl_summary()` function to add statistical tests by using `add_p()`.

Adding `add_p()` runs a Chi-square test (or Fisher's exact test where
cell counts are small) for each categorical variable automatically, allowing us to quickly identify which variables show statistically significant
differences by gender before conducting more detailed analysis.

We'll select all of the demographics columns that start with "A", and the multi-select columns for questions "B1" and "B2".


``` r
# Breakdown by demographics (section A)
survey %>% 
  select(starts_with("A"), matches("_\\d+$")) %>% 
  tbl_summary(
    by = A1,
    statistic = list(all_categorical() ~ "{n} ({p}%)"),
    missing = "ifany"
  ) %>% 
  add_p() %>% # adds Chi-square/Fisher's automatically
  add_overall() %>% # adds total column
  bold_labels()
```

<!--html_preserve--><div id="rgyiefrzij" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#rgyiefrzij table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#rgyiefrzij thead, #rgyiefrzij tbody, #rgyiefrzij tfoot, #rgyiefrzij tr, #rgyiefrzij td, #rgyiefrzij th {
  border-style: none;
}

#rgyiefrzij p {
  margin: 0;
  padding: 0;
}

#rgyiefrzij .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rgyiefrzij .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#rgyiefrzij .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rgyiefrzij .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rgyiefrzij .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rgyiefrzij .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rgyiefrzij .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rgyiefrzij .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rgyiefrzij .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rgyiefrzij .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rgyiefrzij .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rgyiefrzij .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rgyiefrzij .gt_spanner_row {
  border-bottom-style: hidden;
}

#rgyiefrzij .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#rgyiefrzij .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rgyiefrzij .gt_from_md > :first-child {
  margin-top: 0;
}

#rgyiefrzij .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rgyiefrzij .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rgyiefrzij .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#rgyiefrzij .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#rgyiefrzij .gt_row_group_first td {
  border-top-width: 2px;
}

#rgyiefrzij .gt_row_group_first th {
  border-top-width: 2px;
}

#rgyiefrzij .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgyiefrzij .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#rgyiefrzij .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#rgyiefrzij .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rgyiefrzij .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgyiefrzij .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rgyiefrzij .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#rgyiefrzij .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rgyiefrzij .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rgyiefrzij .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rgyiefrzij .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgyiefrzij .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rgyiefrzij .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgyiefrzij .gt_left {
  text-align: left;
}

#rgyiefrzij .gt_center {
  text-align: center;
}

#rgyiefrzij .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rgyiefrzij .gt_font_normal {
  font-weight: normal;
}

#rgyiefrzij .gt_font_bold {
  font-weight: bold;
}

#rgyiefrzij .gt_font_italic {
  font-style: italic;
}

#rgyiefrzij .gt_super {
  font-size: 65%;
}

#rgyiefrzij .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#rgyiefrzij .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#rgyiefrzij .gt_indent_1 {
  text-indent: 5px;
}

#rgyiefrzij .gt_indent_2 {
  text-indent: 10px;
}

#rgyiefrzij .gt_indent_3 {
  text-indent: 15px;
}

#rgyiefrzij .gt_indent_4 {
  text-indent: 20px;
}

#rgyiefrzij .gt_indent_5 {
  text-indent: 25px;
}

#rgyiefrzij .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#rgyiefrzij div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>male</strong><br />
N = 422</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>female</strong><br />
N = 583</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.071</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">203 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">294 (50%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">170 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">246 (42%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">49 (12%)</td>
<td headers="stat_2" class="gt_row gt_center">43 (7.4%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">39 (9.2%)</td>
<td headers="stat_2" class="gt_row gt_center">62 (11%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">234 (55%)</td>
<td headers="stat_2" class="gt_row gt_center">311 (53%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">149 (35%)</td>
<td headers="stat_2" class="gt_row gt_center">210 (36%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">154 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">240 (41%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">137 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">189 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">131 (31%)</td>
<td headers="stat_2" class="gt_row gt_center">154 (26%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">141 (33%)</td>
<td headers="stat_2" class="gt_row gt_center">186 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">73 (17%)</td>
<td headers="stat_2" class="gt_row gt_center">128 (22%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">208 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">269 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">214 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">314 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">208 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">269 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">80 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">472 (81%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">120 (28%)</td>
<td headers="stat_2" class="gt_row gt_center">156 (27%)</td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">30 (7.1%)</td>
<td headers="stat_2" class="gt_row gt_center">440 (75%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">180 (43%)</td>
<td headers="stat_2" class="gt_row gt_center">315 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">347 (82%)</td>
<td headers="stat_2" class="gt_row gt_center">160 (27%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">215 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">83 (14%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">81 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">125 (21%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">29 (6.9%)</td>
<td headers="stat_2" class="gt_row gt_center">388 (67%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">194 (46%)</td>
<td headers="stat_2" class="gt_row gt_center">168 (29%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">259 (61%)</td>
<td headers="stat_2" class="gt_row gt_center">99 (17%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">66 (16%)</td>
<td headers="stat_2" class="gt_row gt_center">403 (69%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">170 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">219 (38%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">190 (45%)</td>
<td headers="stat_2" class="gt_row gt_center">187 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

We can expand this code further to use a `for loop` to generate summary tables stratified by each demographic column.  We'll select all of the demographics columns that start with "A", the multi-select columns for questions `B1` and `B2`, and column `E1`. When running locally in RStudio, 6 tables will print out in the output.


``` r
demo_vars <- survey %>%
  select(starts_with("A")) %>% # names of all demographic columns
  names()

tables_list <- list() # initialise empty list first

for (by_var in demo_vars) {
  row_vars <- survey %>%
    select(starts_with("A"), matches("_\\d+$"), "E1") %>%
    select(-all_of(by_var)) %>%
    names()

  tables_list[[by_var]] <- survey %>%
    tbl_summary(
      by = all_of(by_var),
      include = all_of(row_vars),
      statistic = list(all_categorical() ~ "{n} ({p}%)"),
      missing = "ifany"
    ) %>%
    add_p() %>%
    add_overall() %>%
    bold_labels() %>%
    modify_caption(glue::glue("**Stratified by {by_var}**"))
}

walk(tables_list, print) # prints each table in the list
```


<!--html_preserve--><div id="luhzpxldvf" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#luhzpxldvf table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#luhzpxldvf thead, #luhzpxldvf tbody, #luhzpxldvf tfoot, #luhzpxldvf tr, #luhzpxldvf td, #luhzpxldvf th {
  border-style: none;
}

#luhzpxldvf p {
  margin: 0;
  padding: 0;
}

#luhzpxldvf .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#luhzpxldvf .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#luhzpxldvf .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#luhzpxldvf .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#luhzpxldvf .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#luhzpxldvf .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#luhzpxldvf .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#luhzpxldvf .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#luhzpxldvf .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#luhzpxldvf .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#luhzpxldvf .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#luhzpxldvf .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#luhzpxldvf .gt_spanner_row {
  border-bottom-style: hidden;
}

#luhzpxldvf .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#luhzpxldvf .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#luhzpxldvf .gt_from_md > :first-child {
  margin-top: 0;
}

#luhzpxldvf .gt_from_md > :last-child {
  margin-bottom: 0;
}

#luhzpxldvf .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#luhzpxldvf .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#luhzpxldvf .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#luhzpxldvf .gt_row_group_first td {
  border-top-width: 2px;
}

#luhzpxldvf .gt_row_group_first th {
  border-top-width: 2px;
}

#luhzpxldvf .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#luhzpxldvf .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#luhzpxldvf .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#luhzpxldvf .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#luhzpxldvf .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#luhzpxldvf .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#luhzpxldvf .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#luhzpxldvf .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#luhzpxldvf .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#luhzpxldvf .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#luhzpxldvf .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#luhzpxldvf .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#luhzpxldvf .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#luhzpxldvf .gt_left {
  text-align: left;
}

#luhzpxldvf .gt_center {
  text-align: center;
}

#luhzpxldvf .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#luhzpxldvf .gt_font_normal {
  font-weight: normal;
}

#luhzpxldvf .gt_font_bold {
  font-weight: bold;
}

#luhzpxldvf .gt_font_italic {
  font-style: italic;
}

#luhzpxldvf .gt_super {
  font-size: 65%;
}

#luhzpxldvf .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#luhzpxldvf .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#luhzpxldvf .gt_indent_1 {
  text-indent: 5px;
}

#luhzpxldvf .gt_indent_2 {
  text-indent: 10px;
}

#luhzpxldvf .gt_indent_3 {
  text-indent: 15px;
}

#luhzpxldvf .gt_indent_4 {
  text-indent: 20px;
}

#luhzpxldvf .gt_indent_5 {
  text-indent: 25px;
}

#luhzpxldvf .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#luhzpxldvf div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A1</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>male</strong><br />
N = 422</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>female</strong><br />
N = 583</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.071</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">203 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">294 (50%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">170 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">246 (42%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">49 (12%)</td>
<td headers="stat_2" class="gt_row gt_center">43 (7.4%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">39 (9.2%)</td>
<td headers="stat_2" class="gt_row gt_center">62 (11%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">234 (55%)</td>
<td headers="stat_2" class="gt_row gt_center">311 (53%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">149 (35%)</td>
<td headers="stat_2" class="gt_row gt_center">210 (36%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">154 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">240 (41%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">137 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">189 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">131 (31%)</td>
<td headers="stat_2" class="gt_row gt_center">154 (26%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">141 (33%)</td>
<td headers="stat_2" class="gt_row gt_center">186 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">73 (17%)</td>
<td headers="stat_2" class="gt_row gt_center">128 (22%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">208 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">269 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">214 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">314 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">208 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">269 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">80 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">472 (81%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">120 (28%)</td>
<td headers="stat_2" class="gt_row gt_center">156 (27%)</td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">30 (7.1%)</td>
<td headers="stat_2" class="gt_row gt_center">440 (75%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">180 (43%)</td>
<td headers="stat_2" class="gt_row gt_center">315 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">347 (82%)</td>
<td headers="stat_2" class="gt_row gt_center">160 (27%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">215 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">83 (14%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">81 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">125 (21%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">29 (6.9%)</td>
<td headers="stat_2" class="gt_row gt_center">388 (67%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">194 (46%)</td>
<td headers="stat_2" class="gt_row gt_center">168 (29%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">259 (61%)</td>
<td headers="stat_2" class="gt_row gt_center">99 (17%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">66 (16%)</td>
<td headers="stat_2" class="gt_row gt_center">403 (69%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">170 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">219 (38%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">190 (45%)</td>
<td headers="stat_2" class="gt_row gt_center">187 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="dwbgjjbitv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dwbgjjbitv table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dwbgjjbitv thead, #dwbgjjbitv tbody, #dwbgjjbitv tfoot, #dwbgjjbitv tr, #dwbgjjbitv td, #dwbgjjbitv th {
  border-style: none;
}

#dwbgjjbitv p {
  margin: 0;
  padding: 0;
}

#dwbgjjbitv .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dwbgjjbitv .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dwbgjjbitv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dwbgjjbitv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dwbgjjbitv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dwbgjjbitv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dwbgjjbitv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dwbgjjbitv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dwbgjjbitv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dwbgjjbitv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dwbgjjbitv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dwbgjjbitv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dwbgjjbitv .gt_spanner_row {
  border-bottom-style: hidden;
}

#dwbgjjbitv .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#dwbgjjbitv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dwbgjjbitv .gt_from_md > :first-child {
  margin-top: 0;
}

#dwbgjjbitv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dwbgjjbitv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dwbgjjbitv .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#dwbgjjbitv .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#dwbgjjbitv .gt_row_group_first td {
  border-top-width: 2px;
}

#dwbgjjbitv .gt_row_group_first th {
  border-top-width: 2px;
}

#dwbgjjbitv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dwbgjjbitv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#dwbgjjbitv .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dwbgjjbitv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dwbgjjbitv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dwbgjjbitv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dwbgjjbitv .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#dwbgjjbitv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dwbgjjbitv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dwbgjjbitv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dwbgjjbitv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dwbgjjbitv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dwbgjjbitv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dwbgjjbitv .gt_left {
  text-align: left;
}

#dwbgjjbitv .gt_center {
  text-align: center;
}

#dwbgjjbitv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dwbgjjbitv .gt_font_normal {
  font-weight: normal;
}

#dwbgjjbitv .gt_font_bold {
  font-weight: bold;
}

#dwbgjjbitv .gt_font_italic {
  font-style: italic;
}

#dwbgjjbitv .gt_super {
  font-size: 65%;
}

#dwbgjjbitv .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dwbgjjbitv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dwbgjjbitv .gt_indent_1 {
  text-indent: 5px;
}

#dwbgjjbitv .gt_indent_2 {
  text-indent: 10px;
}

#dwbgjjbitv .gt_indent_3 {
  text-indent: 15px;
}

#dwbgjjbitv .gt_indent_4 {
  text-indent: 20px;
}

#dwbgjjbitv .gt_indent_5 {
  text-indent: 25px;
}

#dwbgjjbitv .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#dwbgjjbitv div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A2</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>18-34</strong><br />
N = 497</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>35-54</strong><br />
N = 416</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>55+</strong><br />
N = 92</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.071</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td>
<td headers="stat_1" class="gt_row gt_center">203 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">170 (41%)</td>
<td headers="stat_3" class="gt_row gt_center">49 (53%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td>
<td headers="stat_1" class="gt_row gt_center">294 (59%)</td>
<td headers="stat_2" class="gt_row gt_center">246 (59%)</td>
<td headers="stat_3" class="gt_row gt_center">43 (47%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">53 (11%)</td>
<td headers="stat_2" class="gt_row gt_center">39 (9.4%)</td>
<td headers="stat_3" class="gt_row gt_center">9 (9.8%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">256 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">241 (58%)</td>
<td headers="stat_3" class="gt_row gt_center">48 (52%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">188 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">136 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">35 (38%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">195 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">164 (39%)</td>
<td headers="stat_3" class="gt_row gt_center">35 (38%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">159 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">136 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">31 (34%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">143 (29%)</td>
<td headers="stat_2" class="gt_row gt_center">116 (28%)</td>
<td headers="stat_3" class="gt_row gt_center">26 (28%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">168 (34%)</td>
<td headers="stat_2" class="gt_row gt_center">132 (32%)</td>
<td headers="stat_3" class="gt_row gt_center">27 (29%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">108 (22%)</td>
<td headers="stat_2" class="gt_row gt_center">78 (19%)</td>
<td headers="stat_3" class="gt_row gt_center">15 (16%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">221 (44%)</td>
<td headers="stat_2" class="gt_row gt_center">206 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">50 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.12</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">276 (56%)</td>
<td headers="stat_2" class="gt_row gt_center">210 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">42 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">221 (44%)</td>
<td headers="stat_2" class="gt_row gt_center">206 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">50 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">264 (53%)</td>
<td headers="stat_2" class="gt_row gt_center">241 (58%)</td>
<td headers="stat_3" class="gt_row gt_center">47 (51%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">139 (28%)</td>
<td headers="stat_2" class="gt_row gt_center">108 (26%)</td>
<td headers="stat_3" class="gt_row gt_center">29 (32%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">233 (47%)</td>
<td headers="stat_2" class="gt_row gt_center">201 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">36 (39%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">243 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">207 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">45 (49%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">237 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">215 (52%)</td>
<td headers="stat_3" class="gt_row gt_center">55 (60%)</td>
<td headers="p.value" class="gt_row gt_center">0.083</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">149 (30%)</td>
<td headers="stat_2" class="gt_row gt_center">124 (30%)</td>
<td headers="stat_3" class="gt_row gt_center">25 (27%)</td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">99 (20%)</td>
<td headers="stat_2" class="gt_row gt_center">87 (21%)</td>
<td headers="stat_3" class="gt_row gt_center">20 (22%)</td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">205 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">183 (44%)</td>
<td headers="stat_3" class="gt_row gt_center">29 (32%)</td>
<td headers="p.value" class="gt_row gt_center">0.089</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">186 (37%)</td>
<td headers="stat_2" class="gt_row gt_center">142 (34%)</td>
<td headers="stat_3" class="gt_row gt_center">34 (37%)</td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">182 (37%)</td>
<td headers="stat_2" class="gt_row gt_center">136 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">40 (43%)</td>
<td headers="p.value" class="gt_row gt_center">0.12</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">228 (46%)</td>
<td headers="stat_2" class="gt_row gt_center">204 (49%)</td>
<td headers="stat_3" class="gt_row gt_center">37 (40%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">193 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">153 (37%)</td>
<td headers="stat_3" class="gt_row gt_center">43 (47%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">172 (35%)</td>
<td headers="stat_2" class="gt_row gt_center">166 (40%)</td>
<td headers="stat_3" class="gt_row gt_center">39 (42%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="hsyqrpoyyp" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hsyqrpoyyp table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#hsyqrpoyyp thead, #hsyqrpoyyp tbody, #hsyqrpoyyp tfoot, #hsyqrpoyyp tr, #hsyqrpoyyp td, #hsyqrpoyyp th {
  border-style: none;
}

#hsyqrpoyyp p {
  margin: 0;
  padding: 0;
}

#hsyqrpoyyp .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hsyqrpoyyp .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hsyqrpoyyp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hsyqrpoyyp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hsyqrpoyyp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hsyqrpoyyp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsyqrpoyyp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hsyqrpoyyp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hsyqrpoyyp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hsyqrpoyyp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hsyqrpoyyp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hsyqrpoyyp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hsyqrpoyyp .gt_spanner_row {
  border-bottom-style: hidden;
}

#hsyqrpoyyp .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hsyqrpoyyp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hsyqrpoyyp .gt_from_md > :first-child {
  margin-top: 0;
}

#hsyqrpoyyp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hsyqrpoyyp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hsyqrpoyyp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#hsyqrpoyyp .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hsyqrpoyyp .gt_row_group_first td {
  border-top-width: 2px;
}

#hsyqrpoyyp .gt_row_group_first th {
  border-top-width: 2px;
}

#hsyqrpoyyp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsyqrpoyyp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#hsyqrpoyyp .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hsyqrpoyyp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsyqrpoyyp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsyqrpoyyp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hsyqrpoyyp .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#hsyqrpoyyp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hsyqrpoyyp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hsyqrpoyyp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hsyqrpoyyp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsyqrpoyyp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hsyqrpoyyp .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hsyqrpoyyp .gt_left {
  text-align: left;
}

#hsyqrpoyyp .gt_center {
  text-align: center;
}

#hsyqrpoyyp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hsyqrpoyyp .gt_font_normal {
  font-weight: normal;
}

#hsyqrpoyyp .gt_font_bold {
  font-weight: bold;
}

#hsyqrpoyyp .gt_font_italic {
  font-style: italic;
}

#hsyqrpoyyp .gt_super {
  font-size: 65%;
}

#hsyqrpoyyp .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#hsyqrpoyyp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hsyqrpoyyp .gt_indent_1 {
  text-indent: 5px;
}

#hsyqrpoyyp .gt_indent_2 {
  text-indent: 10px;
}

#hsyqrpoyyp .gt_indent_3 {
  text-indent: 15px;
}

#hsyqrpoyyp .gt_indent_4 {
  text-indent: 20px;
}

#hsyqrpoyyp .gt_indent_5 {
  text-indent: 25px;
}

#hsyqrpoyyp .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#hsyqrpoyyp div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A3</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>primary</strong><br />
N = 101</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>secondary</strong><br />
N = 545</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>tertiary or higher</strong><br />
N = 359</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td>
<td headers="stat_1" class="gt_row gt_center">39 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">234 (43%)</td>
<td headers="stat_3" class="gt_row gt_center">149 (42%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td>
<td headers="stat_1" class="gt_row gt_center">62 (61%)</td>
<td headers="stat_2" class="gt_row gt_center">311 (57%)</td>
<td headers="stat_3" class="gt_row gt_center">210 (58%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">53 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">256 (47%)</td>
<td headers="stat_3" class="gt_row gt_center">188 (52%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">39 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">241 (44%)</td>
<td headers="stat_3" class="gt_row gt_center">136 (38%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">9 (8.9%)</td>
<td headers="stat_2" class="gt_row gt_center">48 (8.8%)</td>
<td headers="stat_3" class="gt_row gt_center">35 (9.7%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">31 (31%)</td>
<td headers="stat_2" class="gt_row gt_center">220 (40%)</td>
<td headers="stat_3" class="gt_row gt_center">143 (40%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">42 (42%)</td>
<td headers="stat_2" class="gt_row gt_center">173 (32%)</td>
<td headers="stat_3" class="gt_row gt_center">111 (31%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">28 (28%)</td>
<td headers="stat_2" class="gt_row gt_center">152 (28%)</td>
<td headers="stat_3" class="gt_row gt_center">105 (29%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">30 (30%)</td>
<td headers="stat_2" class="gt_row gt_center">178 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">119 (33%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">23 (23%)</td>
<td headers="stat_2" class="gt_row gt_center">104 (19%)</td>
<td headers="stat_3" class="gt_row gt_center">74 (21%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">48 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">263 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">166 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">53 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">282 (52%)</td>
<td headers="stat_3" class="gt_row gt_center">193 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">48 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">263 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">166 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">56 (55%)</td>
<td headers="stat_2" class="gt_row gt_center">305 (56%)</td>
<td headers="stat_3" class="gt_row gt_center">191 (53%)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">29 (29%)</td>
<td headers="stat_2" class="gt_row gt_center">142 (26%)</td>
<td headers="stat_3" class="gt_row gt_center">105 (29%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">51 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">250 (46%)</td>
<td headers="stat_3" class="gt_row gt_center">169 (47%)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">52 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">271 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">172 (48%)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">44 (44%)</td>
<td headers="stat_2" class="gt_row gt_center">274 (50%)</td>
<td headers="stat_3" class="gt_row gt_center">189 (53%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">26 (26%)</td>
<td headers="stat_2" class="gt_row gt_center">171 (31%)</td>
<td headers="stat_3" class="gt_row gt_center">101 (28%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">21 (21%)</td>
<td headers="stat_2" class="gt_row gt_center">110 (20%)</td>
<td headers="stat_3" class="gt_row gt_center">75 (21%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">42 (42%)</td>
<td headers="stat_2" class="gt_row gt_center">227 (42%)</td>
<td headers="stat_3" class="gt_row gt_center">148 (41%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">32 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">193 (35%)</td>
<td headers="stat_3" class="gt_row gt_center">137 (38%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">41 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">188 (34%)</td>
<td headers="stat_3" class="gt_row gt_center">129 (36%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">50 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">253 (46%)</td>
<td headers="stat_3" class="gt_row gt_center">166 (46%)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">43 (43%)</td>
<td headers="stat_2" class="gt_row gt_center">221 (41%)</td>
<td headers="stat_3" class="gt_row gt_center">125 (35%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">39 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">192 (35%)</td>
<td headers="stat_3" class="gt_row gt_center">146 (41%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="dqejmzwmww" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dqejmzwmww table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dqejmzwmww thead, #dqejmzwmww tbody, #dqejmzwmww tfoot, #dqejmzwmww tr, #dqejmzwmww td, #dqejmzwmww th {
  border-style: none;
}

#dqejmzwmww p {
  margin: 0;
  padding: 0;
}

#dqejmzwmww .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dqejmzwmww .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dqejmzwmww .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dqejmzwmww .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dqejmzwmww .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dqejmzwmww .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqejmzwmww .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dqejmzwmww .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dqejmzwmww .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dqejmzwmww .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dqejmzwmww .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dqejmzwmww .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dqejmzwmww .gt_spanner_row {
  border-bottom-style: hidden;
}

#dqejmzwmww .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#dqejmzwmww .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dqejmzwmww .gt_from_md > :first-child {
  margin-top: 0;
}

#dqejmzwmww .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dqejmzwmww .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dqejmzwmww .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#dqejmzwmww .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#dqejmzwmww .gt_row_group_first td {
  border-top-width: 2px;
}

#dqejmzwmww .gt_row_group_first th {
  border-top-width: 2px;
}

#dqejmzwmww .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqejmzwmww .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#dqejmzwmww .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dqejmzwmww .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqejmzwmww .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqejmzwmww .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dqejmzwmww .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#dqejmzwmww .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dqejmzwmww .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqejmzwmww .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dqejmzwmww .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqejmzwmww .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dqejmzwmww .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqejmzwmww .gt_left {
  text-align: left;
}

#dqejmzwmww .gt_center {
  text-align: center;
}

#dqejmzwmww .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dqejmzwmww .gt_font_normal {
  font-weight: normal;
}

#dqejmzwmww .gt_font_bold {
  font-weight: bold;
}

#dqejmzwmww .gt_font_italic {
  font-style: italic;
}

#dqejmzwmww .gt_super {
  font-size: 65%;
}

#dqejmzwmww .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dqejmzwmww .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dqejmzwmww .gt_indent_1 {
  text-indent: 5px;
}

#dqejmzwmww .gt_indent_2 {
  text-indent: 10px;
}

#dqejmzwmww .gt_indent_3 {
  text-indent: 15px;
}

#dqejmzwmww .gt_indent_4 {
  text-indent: 20px;
}

#dqejmzwmww .gt_indent_5 {
  text-indent: 25px;
}

#dqejmzwmww .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#dqejmzwmww div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A4</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>low</strong><br />
N = 394</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>middle</strong><br />
N = 326</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>high</strong><br />
N = 285</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td>
<td headers="stat_1" class="gt_row gt_center">154 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">137 (42%)</td>
<td headers="stat_3" class="gt_row gt_center">131 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td>
<td headers="stat_1" class="gt_row gt_center">240 (61%)</td>
<td headers="stat_2" class="gt_row gt_center">189 (58%)</td>
<td headers="stat_3" class="gt_row gt_center">154 (54%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">195 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">159 (49%)</td>
<td headers="stat_3" class="gt_row gt_center">143 (50%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">164 (42%)</td>
<td headers="stat_2" class="gt_row gt_center">136 (42%)</td>
<td headers="stat_3" class="gt_row gt_center">116 (41%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">35 (8.9%)</td>
<td headers="stat_2" class="gt_row gt_center">31 (9.5%)</td>
<td headers="stat_3" class="gt_row gt_center">26 (9.1%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">31 (7.9%)</td>
<td headers="stat_2" class="gt_row gt_center">42 (13%)</td>
<td headers="stat_3" class="gt_row gt_center">28 (9.8%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">220 (56%)</td>
<td headers="stat_2" class="gt_row gt_center">173 (53%)</td>
<td headers="stat_3" class="gt_row gt_center">152 (53%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">143 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">111 (34%)</td>
<td headers="stat_3" class="gt_row gt_center">105 (37%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">127 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">99 (30%)</td>
<td headers="stat_3" class="gt_row gt_center">101 (35%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">76 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">69 (21%)</td>
<td headers="stat_3" class="gt_row gt_center">56 (20%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">191 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">158 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">128 (45%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">203 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">168 (52%)</td>
<td headers="stat_3" class="gt_row gt_center">157 (55%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">191 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">158 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">128 (45%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">231 (59%)</td>
<td headers="stat_2" class="gt_row gt_center">172 (53%)</td>
<td headers="stat_3" class="gt_row gt_center">149 (52%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">99 (25%)</td>
<td headers="stat_2" class="gt_row gt_center">89 (27%)</td>
<td headers="stat_3" class="gt_row gt_center">88 (31%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">191 (48%)</td>
<td headers="stat_2" class="gt_row gt_center">156 (48%)</td>
<td headers="stat_3" class="gt_row gt_center">123 (43%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">193 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">169 (52%)</td>
<td headers="stat_3" class="gt_row gt_center">133 (47%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">185 (47%)</td>
<td headers="stat_2" class="gt_row gt_center">167 (51%)</td>
<td headers="stat_3" class="gt_row gt_center">155 (54%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">115 (29%)</td>
<td headers="stat_2" class="gt_row gt_center">91 (28%)</td>
<td headers="stat_3" class="gt_row gt_center">92 (32%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">78 (20%)</td>
<td headers="stat_2" class="gt_row gt_center">70 (21%)</td>
<td headers="stat_3" class="gt_row gt_center">58 (20%)</td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">175 (44%)</td>
<td headers="stat_2" class="gt_row gt_center">130 (40%)</td>
<td headers="stat_3" class="gt_row gt_center">112 (39%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">129 (33%)</td>
<td headers="stat_2" class="gt_row gt_center">123 (38%)</td>
<td headers="stat_3" class="gt_row gt_center">110 (39%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">131 (33%)</td>
<td headers="stat_2" class="gt_row gt_center">119 (37%)</td>
<td headers="stat_3" class="gt_row gt_center">108 (38%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">193 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">153 (47%)</td>
<td headers="stat_3" class="gt_row gt_center">123 (43%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">159 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">128 (39%)</td>
<td headers="stat_3" class="gt_row gt_center">102 (36%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">140 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">127 (39%)</td>
<td headers="stat_3" class="gt_row gt_center">110 (39%)</td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="rlhukkzsty" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#rlhukkzsty table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#rlhukkzsty thead, #rlhukkzsty tbody, #rlhukkzsty tfoot, #rlhukkzsty tr, #rlhukkzsty td, #rlhukkzsty th {
  border-style: none;
}

#rlhukkzsty p {
  margin: 0;
  padding: 0;
}

#rlhukkzsty .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rlhukkzsty .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#rlhukkzsty .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rlhukkzsty .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rlhukkzsty .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rlhukkzsty .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlhukkzsty .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rlhukkzsty .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rlhukkzsty .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rlhukkzsty .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rlhukkzsty .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rlhukkzsty .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rlhukkzsty .gt_spanner_row {
  border-bottom-style: hidden;
}

#rlhukkzsty .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#rlhukkzsty .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rlhukkzsty .gt_from_md > :first-child {
  margin-top: 0;
}

#rlhukkzsty .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rlhukkzsty .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rlhukkzsty .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#rlhukkzsty .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#rlhukkzsty .gt_row_group_first td {
  border-top-width: 2px;
}

#rlhukkzsty .gt_row_group_first th {
  border-top-width: 2px;
}

#rlhukkzsty .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlhukkzsty .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#rlhukkzsty .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#rlhukkzsty .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlhukkzsty .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlhukkzsty .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rlhukkzsty .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#rlhukkzsty .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rlhukkzsty .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlhukkzsty .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rlhukkzsty .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlhukkzsty .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rlhukkzsty .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlhukkzsty .gt_left {
  text-align: left;
}

#rlhukkzsty .gt_center {
  text-align: center;
}

#rlhukkzsty .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rlhukkzsty .gt_font_normal {
  font-weight: normal;
}

#rlhukkzsty .gt_font_bold {
  font-weight: bold;
}

#rlhukkzsty .gt_font_italic {
  font-style: italic;
}

#rlhukkzsty .gt_super {
  font-size: 65%;
}

#rlhukkzsty .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#rlhukkzsty .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#rlhukkzsty .gt_indent_1 {
  text-indent: 5px;
}

#rlhukkzsty .gt_indent_2 {
  text-indent: 10px;
}

#rlhukkzsty .gt_indent_3 {
  text-indent: 15px;
}

#rlhukkzsty .gt_indent_4 {
  text-indent: 20px;
}

#rlhukkzsty .gt_indent_5 {
  text-indent: 25px;
}

#rlhukkzsty .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#rlhukkzsty div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A5</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>region1</strong><br />
N = 327</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>region2</strong><br />
N = 201</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>region3</strong><br />
N = 477</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td>
<td headers="stat_1" class="gt_row gt_center">141 (43%)</td>
<td headers="stat_2" class="gt_row gt_center">73 (36%)</td>
<td headers="stat_3" class="gt_row gt_center">208 (44%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td>
<td headers="stat_1" class="gt_row gt_center">186 (57%)</td>
<td headers="stat_2" class="gt_row gt_center">128 (64%)</td>
<td headers="stat_3" class="gt_row gt_center">269 (56%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">168 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">108 (54%)</td>
<td headers="stat_3" class="gt_row gt_center">221 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">132 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">78 (39%)</td>
<td headers="stat_3" class="gt_row gt_center">206 (43%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">27 (8.3%)</td>
<td headers="stat_2" class="gt_row gt_center">15 (7.5%)</td>
<td headers="stat_3" class="gt_row gt_center">50 (10%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">30 (9.2%)</td>
<td headers="stat_2" class="gt_row gt_center">23 (11%)</td>
<td headers="stat_3" class="gt_row gt_center">48 (10%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">178 (54%)</td>
<td headers="stat_2" class="gt_row gt_center">104 (52%)</td>
<td headers="stat_3" class="gt_row gt_center">263 (55%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">119 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">74 (37%)</td>
<td headers="stat_3" class="gt_row gt_center">166 (35%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">127 (39%)</td>
<td headers="stat_2" class="gt_row gt_center">76 (38%)</td>
<td headers="stat_3" class="gt_row gt_center">191 (40%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">99 (30%)</td>
<td headers="stat_2" class="gt_row gt_center">69 (34%)</td>
<td headers="stat_3" class="gt_row gt_center">158 (33%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">101 (31%)</td>
<td headers="stat_2" class="gt_row gt_center">56 (28%)</td>
<td headers="stat_3" class="gt_row gt_center">128 (27%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="stat_3" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">327 (100%)</td>
<td headers="stat_2" class="gt_row gt_center">201 (100%)</td>
<td headers="stat_3" class="gt_row gt_center">0 (0%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
<td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
<td headers="stat_3" class="gt_row gt_center">477 (100%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">169 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">110 (55%)</td>
<td headers="stat_3" class="gt_row gt_center">273 (57%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">85 (26%)</td>
<td headers="stat_2" class="gt_row gt_center">54 (27%)</td>
<td headers="stat_3" class="gt_row gt_center">137 (29%)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">140 (43%)</td>
<td headers="stat_2" class="gt_row gt_center">108 (54%)</td>
<td headers="stat_3" class="gt_row gt_center">222 (47%)</td>
<td headers="p.value" class="gt_row gt_center">0.050</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">168 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">106 (53%)</td>
<td headers="stat_3" class="gt_row gt_center">221 (46%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">169 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">98 (49%)</td>
<td headers="stat_3" class="gt_row gt_center">240 (50%)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">88 (27%)</td>
<td headers="stat_2" class="gt_row gt_center">60 (30%)</td>
<td headers="stat_3" class="gt_row gt_center">150 (31%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">66 (20%)</td>
<td headers="stat_2" class="gt_row gt_center">35 (17%)</td>
<td headers="stat_3" class="gt_row gt_center">105 (22%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">132 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">88 (44%)</td>
<td headers="stat_3" class="gt_row gt_center">197 (41%)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">121 (37%)</td>
<td headers="stat_2" class="gt_row gt_center">67 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">174 (36%)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">123 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">65 (32%)</td>
<td headers="stat_3" class="gt_row gt_center">170 (36%)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">153 (47%)</td>
<td headers="stat_2" class="gt_row gt_center">106 (53%)</td>
<td headers="stat_3" class="gt_row gt_center">210 (44%)</td>
<td headers="p.value" class="gt_row gt_center">0.12</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">114 (35%)</td>
<td headers="stat_2" class="gt_row gt_center">84 (42%)</td>
<td headers="stat_3" class="gt_row gt_center">191 (40%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">133 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">67 (33%)</td>
<td headers="stat_3" class="gt_row gt_center">177 (37%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->


<!--html_preserve--><div id="dqstdhskjq" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dqstdhskjq table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dqstdhskjq thead, #dqstdhskjq tbody, #dqstdhskjq tfoot, #dqstdhskjq tr, #dqstdhskjq td, #dqstdhskjq th {
  border-style: none;
}

#dqstdhskjq p {
  margin: 0;
  padding: 0;
}

#dqstdhskjq .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dqstdhskjq .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dqstdhskjq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dqstdhskjq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dqstdhskjq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dqstdhskjq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqstdhskjq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dqstdhskjq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dqstdhskjq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dqstdhskjq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dqstdhskjq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dqstdhskjq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dqstdhskjq .gt_spanner_row {
  border-bottom-style: hidden;
}

#dqstdhskjq .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#dqstdhskjq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dqstdhskjq .gt_from_md > :first-child {
  margin-top: 0;
}

#dqstdhskjq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dqstdhskjq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dqstdhskjq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#dqstdhskjq .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#dqstdhskjq .gt_row_group_first td {
  border-top-width: 2px;
}

#dqstdhskjq .gt_row_group_first th {
  border-top-width: 2px;
}

#dqstdhskjq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqstdhskjq .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#dqstdhskjq .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dqstdhskjq .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqstdhskjq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqstdhskjq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dqstdhskjq .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#dqstdhskjq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dqstdhskjq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dqstdhskjq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dqstdhskjq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqstdhskjq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dqstdhskjq .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dqstdhskjq .gt_left {
  text-align: left;
}

#dqstdhskjq .gt_center {
  text-align: center;
}

#dqstdhskjq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dqstdhskjq .gt_font_normal {
  font-weight: normal;
}

#dqstdhskjq .gt_font_bold {
  font-weight: bold;
}

#dqstdhskjq .gt_font_italic {
  font-style: italic;
}

#dqstdhskjq .gt_super {
  font-size: 65%;
}

#dqstdhskjq .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dqstdhskjq .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dqstdhskjq .gt_indent_1 {
  text-indent: 5px;
}

#dqstdhskjq .gt_indent_2 {
  text-indent: 10px;
}

#dqstdhskjq .gt_indent_3 {
  text-indent: 15px;
}

#dqstdhskjq .gt_indent_4 {
  text-indent: 20px;
}

#dqstdhskjq .gt_indent_5 {
  text-indent: 25px;
}

#dqstdhskjq .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#dqstdhskjq div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A6</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>Rural</strong><br />
N = 528</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>Urban</strong><br />
N = 477</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A1</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td>
<td headers="stat_1" class="gt_row gt_center">214 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">208 (44%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td>
<td headers="stat_1" class="gt_row gt_center">314 (59%)</td>
<td headers="stat_2" class="gt_row gt_center">269 (56%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A2</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.12</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    18-34</td>
<td headers="stat_0" class="gt_row gt_center">497 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">276 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">221 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">210 (40%)</td>
<td headers="stat_2" class="gt_row gt_center">206 (43%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">42 (8.0%)</td>
<td headers="stat_2" class="gt_row gt_center">50 (10%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">53 (10%)</td>
<td headers="stat_2" class="gt_row gt_center">48 (10%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">282 (53%)</td>
<td headers="stat_2" class="gt_row gt_center">263 (55%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">193 (37%)</td>
<td headers="stat_2" class="gt_row gt_center">166 (35%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">203 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">191 (40%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">168 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">158 (33%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">157 (30%)</td>
<td headers="stat_2" class="gt_row gt_center">128 (27%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">327 (62%)</td>
<td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">201 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
<td headers="stat_2" class="gt_row gt_center">477 (100%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">279 (53%)</td>
<td headers="stat_2" class="gt_row gt_center">273 (57%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">139 (26%)</td>
<td headers="stat_2" class="gt_row gt_center">137 (29%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">248 (47%)</td>
<td headers="stat_2" class="gt_row gt_center">222 (47%)</td>
<td headers="p.value" class="gt_row gt_center">0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">274 (52%)</td>
<td headers="stat_2" class="gt_row gt_center">221 (46%)</td>
<td headers="p.value" class="gt_row gt_center">0.078</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">267 (51%)</td>
<td headers="stat_2" class="gt_row gt_center">240 (50%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">148 (28%)</td>
<td headers="stat_2" class="gt_row gt_center">150 (31%)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">101 (19%)</td>
<td headers="stat_2" class="gt_row gt_center">105 (22%)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">220 (42%)</td>
<td headers="stat_2" class="gt_row gt_center">197 (41%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">188 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">174 (36%)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">188 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">170 (36%)</td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">259 (49%)</td>
<td headers="stat_2" class="gt_row gt_center">210 (44%)</td>
<td headers="p.value" class="gt_row gt_center">0.11</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">198 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">191 (40%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">200 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">177 (37%)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Pearson’s Chi-squared test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->


We can see that there are some statistical differences when stratifying by column `A1`, gender. We'll explore these in more detail shortly.

We can also look at the mean and standard deviation of our continuous
variables, stratified by demographics. Let's loop through all demographic variables for continuous variables `D1` and`D2`. We'll make a few changes with this code- we'll only display results for the variables `D1` and`D2`, and we'll use the statistic `all_continuous`. When running locally in RStudio, 6 tables will print out in the output.


``` r
tables_cont_list <- list() # initialise empty list first

for (by_var in demo_vars) {

  tables_cont_list[[by_var]] <- survey %>%
    tbl_summary(
      by = all_of(by_var),
      include = c(D1, D2), # only these two rows
      statistic = list(
        all_continuous() ~ "{mean} ({sd})"
      ),
      digits = all_continuous() ~ 1,
      missing = "ifany",
      label = list(
        D1 ~ "D1 Commute time (minutes)",
        D2 ~ "D2 Commute distance (km)"
      )
    ) %>%
    add_p() %>%
    add_overall() %>%
    bold_labels() %>%
    modify_caption(glue::glue("**Stratified by {by_var}**"))
}
walk(tables_cont_list, print) # prints each table in the list
```

<!--html_preserve--><div id="nfknlfhmwr" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nfknlfhmwr table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#nfknlfhmwr thead, #nfknlfhmwr tbody, #nfknlfhmwr tfoot, #nfknlfhmwr tr, #nfknlfhmwr td, #nfknlfhmwr th {
  border-style: none;
}

#nfknlfhmwr p {
  margin: 0;
  padding: 0;
}

#nfknlfhmwr .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nfknlfhmwr .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nfknlfhmwr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nfknlfhmwr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nfknlfhmwr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nfknlfhmwr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nfknlfhmwr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nfknlfhmwr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nfknlfhmwr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nfknlfhmwr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nfknlfhmwr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nfknlfhmwr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nfknlfhmwr .gt_spanner_row {
  border-bottom-style: hidden;
}

#nfknlfhmwr .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nfknlfhmwr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nfknlfhmwr .gt_from_md > :first-child {
  margin-top: 0;
}

#nfknlfhmwr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nfknlfhmwr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nfknlfhmwr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nfknlfhmwr .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nfknlfhmwr .gt_row_group_first td {
  border-top-width: 2px;
}

#nfknlfhmwr .gt_row_group_first th {
  border-top-width: 2px;
}

#nfknlfhmwr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nfknlfhmwr .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nfknlfhmwr .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nfknlfhmwr .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nfknlfhmwr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nfknlfhmwr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nfknlfhmwr .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#nfknlfhmwr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nfknlfhmwr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nfknlfhmwr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nfknlfhmwr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nfknlfhmwr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nfknlfhmwr .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nfknlfhmwr .gt_left {
  text-align: left;
}

#nfknlfhmwr .gt_center {
  text-align: center;
}

#nfknlfhmwr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nfknlfhmwr .gt_font_normal {
  font-weight: normal;
}

#nfknlfhmwr .gt_font_bold {
  font-weight: bold;
}

#nfknlfhmwr .gt_font_italic {
  font-style: italic;
}

#nfknlfhmwr .gt_super {
  font-size: 65%;
}

#nfknlfhmwr .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#nfknlfhmwr .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nfknlfhmwr .gt_indent_1 {
  text-indent: 5px;
}

#nfknlfhmwr .gt_indent_2 {
  text-indent: 10px;
}

#nfknlfhmwr .gt_indent_3 {
  text-indent: 15px;
}

#nfknlfhmwr .gt_indent_4 {
  text-indent: 20px;
}

#nfknlfhmwr .gt_indent_5 {
  text-indent: 25px;
}

#nfknlfhmwr .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#nfknlfhmwr div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A1</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>male</strong><br />
N = 422</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>female</strong><br />
N = 583</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">69.2 (28.5)</td>
<td headers="stat_2" class="gt_row gt_center">72.8 (26.5)</td>
<td headers="p.value" class="gt_row gt_center">0.074</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">29.4 (11.5)</td>
<td headers="stat_2" class="gt_row gt_center">30.4 (11.3)</td>
<td headers="p.value" class="gt_row gt_center">0.13</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Wilcoxon rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="rpeaqiymum" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#rpeaqiymum table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#rpeaqiymum thead, #rpeaqiymum tbody, #rpeaqiymum tfoot, #rpeaqiymum tr, #rpeaqiymum td, #rpeaqiymum th {
  border-style: none;
}

#rpeaqiymum p {
  margin: 0;
  padding: 0;
}

#rpeaqiymum .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rpeaqiymum .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#rpeaqiymum .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rpeaqiymum .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rpeaqiymum .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rpeaqiymum .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rpeaqiymum .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rpeaqiymum .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rpeaqiymum .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rpeaqiymum .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rpeaqiymum .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rpeaqiymum .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rpeaqiymum .gt_spanner_row {
  border-bottom-style: hidden;
}

#rpeaqiymum .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#rpeaqiymum .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rpeaqiymum .gt_from_md > :first-child {
  margin-top: 0;
}

#rpeaqiymum .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rpeaqiymum .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rpeaqiymum .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#rpeaqiymum .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#rpeaqiymum .gt_row_group_first td {
  border-top-width: 2px;
}

#rpeaqiymum .gt_row_group_first th {
  border-top-width: 2px;
}

#rpeaqiymum .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rpeaqiymum .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#rpeaqiymum .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#rpeaqiymum .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rpeaqiymum .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rpeaqiymum .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rpeaqiymum .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#rpeaqiymum .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rpeaqiymum .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rpeaqiymum .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rpeaqiymum .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rpeaqiymum .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rpeaqiymum .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rpeaqiymum .gt_left {
  text-align: left;
}

#rpeaqiymum .gt_center {
  text-align: center;
}

#rpeaqiymum .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rpeaqiymum .gt_font_normal {
  font-weight: normal;
}

#rpeaqiymum .gt_font_bold {
  font-weight: bold;
}

#rpeaqiymum .gt_font_italic {
  font-style: italic;
}

#rpeaqiymum .gt_super {
  font-size: 65%;
}

#rpeaqiymum .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#rpeaqiymum .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#rpeaqiymum .gt_indent_1 {
  text-indent: 5px;
}

#rpeaqiymum .gt_indent_2 {
  text-indent: 10px;
}

#rpeaqiymum .gt_indent_3 {
  text-indent: 15px;
}

#rpeaqiymum .gt_indent_4 {
  text-indent: 20px;
}

#rpeaqiymum .gt_indent_5 {
  text-indent: 25px;
}

#rpeaqiymum .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#rpeaqiymum div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A2</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>18-34</strong><br />
N = 497</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>35-54</strong><br />
N = 416</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>55+</strong><br />
N = 92</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">89.8 (17.2)</td>
<td headers="stat_2" class="gt_row gt_center">58.9 (20.0)</td>
<td headers="stat_3" class="gt_row gt_center">27.2 (16.4)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">37.5 (7.2)</td>
<td headers="stat_2" class="gt_row gt_center">24.9 (9.0)</td>
<td headers="stat_3" class="gt_row gt_center">12.3 (6.6)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Kruskal-Wallis rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="ebylbgdeko" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#ebylbgdeko table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#ebylbgdeko thead, #ebylbgdeko tbody, #ebylbgdeko tfoot, #ebylbgdeko tr, #ebylbgdeko td, #ebylbgdeko th {
  border-style: none;
}

#ebylbgdeko p {
  margin: 0;
  padding: 0;
}

#ebylbgdeko .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ebylbgdeko .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ebylbgdeko .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ebylbgdeko .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ebylbgdeko .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ebylbgdeko .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ebylbgdeko .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ebylbgdeko .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ebylbgdeko .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ebylbgdeko .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ebylbgdeko .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ebylbgdeko .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ebylbgdeko .gt_spanner_row {
  border-bottom-style: hidden;
}

#ebylbgdeko .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ebylbgdeko .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ebylbgdeko .gt_from_md > :first-child {
  margin-top: 0;
}

#ebylbgdeko .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ebylbgdeko .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ebylbgdeko .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ebylbgdeko .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ebylbgdeko .gt_row_group_first td {
  border-top-width: 2px;
}

#ebylbgdeko .gt_row_group_first th {
  border-top-width: 2px;
}

#ebylbgdeko .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ebylbgdeko .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ebylbgdeko .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ebylbgdeko .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ebylbgdeko .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ebylbgdeko .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ebylbgdeko .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#ebylbgdeko .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ebylbgdeko .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ebylbgdeko .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ebylbgdeko .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ebylbgdeko .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ebylbgdeko .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ebylbgdeko .gt_left {
  text-align: left;
}

#ebylbgdeko .gt_center {
  text-align: center;
}

#ebylbgdeko .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ebylbgdeko .gt_font_normal {
  font-weight: normal;
}

#ebylbgdeko .gt_font_bold {
  font-weight: bold;
}

#ebylbgdeko .gt_font_italic {
  font-style: italic;
}

#ebylbgdeko .gt_super {
  font-size: 65%;
}

#ebylbgdeko .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#ebylbgdeko .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ebylbgdeko .gt_indent_1 {
  text-indent: 5px;
}

#ebylbgdeko .gt_indent_2 {
  text-indent: 10px;
}

#ebylbgdeko .gt_indent_3 {
  text-indent: 15px;
}

#ebylbgdeko .gt_indent_4 {
  text-indent: 20px;
}

#ebylbgdeko .gt_indent_5 {
  text-indent: 25px;
}

#ebylbgdeko .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#ebylbgdeko div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A3</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>primary</strong><br />
N = 101</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>secondary</strong><br />
N = 545</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>tertiary or higher</strong><br />
N = 359</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">76.3 (27.5)</td>
<td headers="stat_2" class="gt_row gt_center">70.3 (27.6)</td>
<td headers="stat_3" class="gt_row gt_center">71.3 (27.0)</td>
<td headers="p.value" class="gt_row gt_center">0.086</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">30.8 (12.5)</td>
<td headers="stat_2" class="gt_row gt_center">29.5 (11.2)</td>
<td headers="stat_3" class="gt_row gt_center">30.5 (11.4)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Kruskal-Wallis rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="wxkdddmsph" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#wxkdddmsph table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#wxkdddmsph thead, #wxkdddmsph tbody, #wxkdddmsph tfoot, #wxkdddmsph tr, #wxkdddmsph td, #wxkdddmsph th {
  border-style: none;
}

#wxkdddmsph p {
  margin: 0;
  padding: 0;
}

#wxkdddmsph .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#wxkdddmsph .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#wxkdddmsph .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#wxkdddmsph .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#wxkdddmsph .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wxkdddmsph .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wxkdddmsph .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wxkdddmsph .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#wxkdddmsph .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#wxkdddmsph .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wxkdddmsph .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wxkdddmsph .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#wxkdddmsph .gt_spanner_row {
  border-bottom-style: hidden;
}

#wxkdddmsph .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#wxkdddmsph .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#wxkdddmsph .gt_from_md > :first-child {
  margin-top: 0;
}

#wxkdddmsph .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wxkdddmsph .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#wxkdddmsph .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#wxkdddmsph .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#wxkdddmsph .gt_row_group_first td {
  border-top-width: 2px;
}

#wxkdddmsph .gt_row_group_first th {
  border-top-width: 2px;
}

#wxkdddmsph .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wxkdddmsph .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#wxkdddmsph .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#wxkdddmsph .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wxkdddmsph .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wxkdddmsph .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wxkdddmsph .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#wxkdddmsph .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wxkdddmsph .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wxkdddmsph .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wxkdddmsph .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wxkdddmsph .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wxkdddmsph .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wxkdddmsph .gt_left {
  text-align: left;
}

#wxkdddmsph .gt_center {
  text-align: center;
}

#wxkdddmsph .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wxkdddmsph .gt_font_normal {
  font-weight: normal;
}

#wxkdddmsph .gt_font_bold {
  font-weight: bold;
}

#wxkdddmsph .gt_font_italic {
  font-style: italic;
}

#wxkdddmsph .gt_super {
  font-size: 65%;
}

#wxkdddmsph .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#wxkdddmsph .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#wxkdddmsph .gt_indent_1 {
  text-indent: 5px;
}

#wxkdddmsph .gt_indent_2 {
  text-indent: 10px;
}

#wxkdddmsph .gt_indent_3 {
  text-indent: 15px;
}

#wxkdddmsph .gt_indent_4 {
  text-indent: 20px;
}

#wxkdddmsph .gt_indent_5 {
  text-indent: 25px;
}

#wxkdddmsph .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#wxkdddmsph div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A4</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>low</strong><br />
N = 394</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>middle</strong><br />
N = 326</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>high</strong><br />
N = 285</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">72.3 (26.7)</td>
<td headers="stat_2" class="gt_row gt_center">70.2 (27.8)</td>
<td headers="stat_3" class="gt_row gt_center">71.2 (27.8)</td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">30.4 (11.9)</td>
<td headers="stat_2" class="gt_row gt_center">29.9 (10.7)</td>
<td headers="stat_3" class="gt_row gt_center">29.5 (11.5)</td>
<td headers="p.value" class="gt_row gt_center">0.5</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Kruskal-Wallis rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="oswunjiows" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#oswunjiows table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#oswunjiows thead, #oswunjiows tbody, #oswunjiows tfoot, #oswunjiows tr, #oswunjiows td, #oswunjiows th {
  border-style: none;
}

#oswunjiows p {
  margin: 0;
  padding: 0;
}

#oswunjiows .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#oswunjiows .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#oswunjiows .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#oswunjiows .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#oswunjiows .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#oswunjiows .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#oswunjiows .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#oswunjiows .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#oswunjiows .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#oswunjiows .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#oswunjiows .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#oswunjiows .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#oswunjiows .gt_spanner_row {
  border-bottom-style: hidden;
}

#oswunjiows .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#oswunjiows .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#oswunjiows .gt_from_md > :first-child {
  margin-top: 0;
}

#oswunjiows .gt_from_md > :last-child {
  margin-bottom: 0;
}

#oswunjiows .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#oswunjiows .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#oswunjiows .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#oswunjiows .gt_row_group_first td {
  border-top-width: 2px;
}

#oswunjiows .gt_row_group_first th {
  border-top-width: 2px;
}

#oswunjiows .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#oswunjiows .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#oswunjiows .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#oswunjiows .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#oswunjiows .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#oswunjiows .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#oswunjiows .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#oswunjiows .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#oswunjiows .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#oswunjiows .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#oswunjiows .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#oswunjiows .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#oswunjiows .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#oswunjiows .gt_left {
  text-align: left;
}

#oswunjiows .gt_center {
  text-align: center;
}

#oswunjiows .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#oswunjiows .gt_font_normal {
  font-weight: normal;
}

#oswunjiows .gt_font_bold {
  font-weight: bold;
}

#oswunjiows .gt_font_italic {
  font-style: italic;
}

#oswunjiows .gt_super {
  font-size: 65%;
}

#oswunjiows .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#oswunjiows .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#oswunjiows .gt_indent_1 {
  text-indent: 5px;
}

#oswunjiows .gt_indent_2 {
  text-indent: 10px;
}

#oswunjiows .gt_indent_3 {
  text-indent: 15px;
}

#oswunjiows .gt_indent_4 {
  text-indent: 20px;
}

#oswunjiows .gt_indent_5 {
  text-indent: 25px;
}

#oswunjiows .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#oswunjiows div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A5</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>region1</strong><br />
N = 327</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>region2</strong><br />
N = 201</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>region3</strong><br />
N = 477</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">71.4 (27.0)</td>
<td headers="stat_2" class="gt_row gt_center">74.7 (28.6)</td>
<td headers="stat_3" class="gt_row gt_center">69.7 (27.0)</td>
<td headers="p.value" class="gt_row gt_center">0.058</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">30.2 (11.3)</td>
<td headers="stat_2" class="gt_row gt_center">30.9 (10.8)</td>
<td headers="stat_3" class="gt_row gt_center">29.4 (11.7)</td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="6"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Kruskal-Wallis rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

<!--html_preserve--><div id="ornqmlddph" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#ornqmlddph table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#ornqmlddph thead, #ornqmlddph tbody, #ornqmlddph tfoot, #ornqmlddph tr, #ornqmlddph td, #ornqmlddph th {
  border-style: none;
}

#ornqmlddph p {
  margin: 0;
  padding: 0;
}

#ornqmlddph .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ornqmlddph .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ornqmlddph .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ornqmlddph .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ornqmlddph .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ornqmlddph .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ornqmlddph .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ornqmlddph .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ornqmlddph .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ornqmlddph .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ornqmlddph .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ornqmlddph .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ornqmlddph .gt_spanner_row {
  border-bottom-style: hidden;
}

#ornqmlddph .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ornqmlddph .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ornqmlddph .gt_from_md > :first-child {
  margin-top: 0;
}

#ornqmlddph .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ornqmlddph .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ornqmlddph .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ornqmlddph .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ornqmlddph .gt_row_group_first td {
  border-top-width: 2px;
}

#ornqmlddph .gt_row_group_first th {
  border-top-width: 2px;
}

#ornqmlddph .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ornqmlddph .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ornqmlddph .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ornqmlddph .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ornqmlddph .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ornqmlddph .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ornqmlddph .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#ornqmlddph .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ornqmlddph .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ornqmlddph .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ornqmlddph .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ornqmlddph .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ornqmlddph .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ornqmlddph .gt_left {
  text-align: left;
}

#ornqmlddph .gt_center {
  text-align: center;
}

#ornqmlddph .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ornqmlddph .gt_font_normal {
  font-weight: normal;
}

#ornqmlddph .gt_font_bold {
  font-weight: bold;
}

#ornqmlddph .gt_font_italic {
  font-style: italic;
}

#ornqmlddph .gt_super {
  font-size: 65%;
}

#ornqmlddph .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#ornqmlddph .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ornqmlddph .gt_indent_1 {
  text-indent: 5px;
}

#ornqmlddph .gt_indent_2 {
  text-indent: 10px;
}

#ornqmlddph .gt_indent_3 {
  text-indent: 15px;
}

#ornqmlddph .gt_indent_4 {
  text-indent: 20px;
}

#ornqmlddph .gt_indent_5 {
  text-indent: 25px;
}

#ornqmlddph .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#ornqmlddph div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'><strong>Stratified by A6</strong></span></caption><!--html_preserve-->
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>Rural</strong><br />
N = 528</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>Urban</strong><br />
N = 477</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="p.value"><span class='gt_from_md'><strong>p-value</strong></span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D1 Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">72.7 (27.6)</td>
<td headers="stat_2" class="gt_row gt_center">69.7 (27.0)</td>
<td headers="p.value" class="gt_row gt_center">0.063</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">D2 Commute distance (km)</td>
<td headers="stat_0" class="gt_row gt_center">30.0 (11.4)</td>
<td headers="stat_1" class="gt_row gt_center">30.5 (11.1)</td>
<td headers="stat_2" class="gt_row gt_center">29.4 (11.7)</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
  </tbody>
  <tfoot>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>Mean (SD)</span></td>
    </tr>
    <tr class="gt_footnotes">
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>2</sup></span> <span class='gt_from_md'>Wilcoxon rank sum test</span></td>
    </tr>
  </tfoot>
</table>
</div><!--/html_preserve-->

We can see that there are some statistical differences when stratifying by column `A2`, age group. We'll explore these in more detail shortly.


::: callout
### Statistical tests used by `gtsummary`

When`add_p()` is called, `gtsummary` automatically selects a statistical
test based on the variable type and the number of groups being compared.
It defaults to conservative non-parametric tests for continuous
variables. Specifically, for continuous variables with two groups it
applies a Wilcoxon rank-sum test, and with three or more groups it
applies a Kruskal-Wallis test.

For categorical and logical variables, it uses a Chi-square test,
switching automatically to Fisher's exact test when expected cell counts
are too small (typically when any cell has an expected count below 5).

These defaults can be overridden using the test argument in add_p(). For
example, specifying `test = list(all_continuous() ~ "aov")` to use ANOVA
instead of Kruskal-Wallis.

The choice of whether to accept the default or override it should be
guided by checking your distributions first. If continuous variables are
approximately normally distributed and sample sizes are adequate,
parametric tests (t-test, ANOVA) are appropriate and will generally be
more statistically powerful than their non-parametric equivalents.

:::

## Export processed data

Now that we've investigated the processed the data, we'll write it out into `.rds`, a file type that preserves everything we've done to process the data (factor levels and order, custom classes, attributes, column types). It's the best option when the data will only ever be used in R. 


``` r
saveRDS(survey, here("data", "cleaned", "generated_survey_data_clean.rds"))

# read back in - retains all factor levels, ordered factors, etc.
survey <- readRDS(here("data", "cleaned", "generated_survey_data_clean.rds"))
```

::: callout
### File formats

Many different file formats can be read into and written (exported) out of R, including `SPSS` files.

Some of the common file types, and their uses, are included in the table below.

| Format | Write | Read | Retains R types? | Readable outside R? | Best used for |
|--------|-------|------|------------------|---------------------|---------------|
| `.rds` | `saveRDS()` | `readRDS()` | Yes | No | Saving single R objects between sessions |
| `.RData` | `save()` | `load()` | Yes | No | Saving multiple R objects at once |
| `.csv` | `write_csv()` | `read_csv()` | No | Yes | Sharing data with non-R users |
| `.parquet` | `arrow::write_parquet()` | `arrow::read_parquet()` | Mostly | Yes | Large datasets shared across languages |
| `.sav` | `haven::write_sav()` | `haven::read_sav()` | Mostly | Yes (SPSS) | Sharing data with SPSS users |

::: 


## Analysing multi-select data

### Proportions

Questions `B1` and `B2` allowed respondents to select more than one answer (up to 3). Each option has been dummy-coded into its own boolean column (`TRUE` = selected, `FALSE` = not selected). The raw `B1` and `B2` columns contain the original response strings and can be ignored for analysis.

Let's start by looking at the **proportion of respondents who selected each option**.


``` r
survey %>%
  select(starts_with("B1_")) %>%
  summarise(across(everything(), mean)) %>%
  pivot_longer(everything(),
               names_to  = "option",
               values_to = "proportion") %>%
  ggplot(aes(x = reorder(option, proportion), y = proportion)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = percent(proportion, accuracy = 1)),
            hjust = -0.15, size = 3.5) +
  coord_flip() +
  scale_y_continuous(labels = percent, limits = c(0, 0.7)) +
  labs(title = "B1: Proportion of respondents selecting each option",
       x = NULL, y = "% selecting") +
  theme_minimal(base_size = 12)
```

<img src="fig/quantitative_data_analysis-rendered-multiselect-B1-1.png" alt="" style="display: block; margin: auto;" />

The `reorder()` call sorts the bars from lowest to highest proportion, making it easy to rank options by popularity. `B1_1` is the most commonly selected option and `B1_2` the least- a difference worth investigating when we run Chi-square tests shortly.

Let's now plot the results for `B2`.


``` r
survey %>%
  select(starts_with("B2_")) %>%
  summarise(across(everything(), mean)) %>%
  pivot_longer(everything(),
               names_to  = "option",
               values_to = "proportion") %>%
  ggplot(aes(x = reorder(option, proportion), y = proportion)) +
  geom_col(fill = "coral") +
  geom_text(aes(label = percent(proportion, accuracy = 1)),
            hjust = -0.15, size = 3.5) +
  coord_flip() +
  scale_y_continuous(labels = percent, limits = c(0, 0.6)) +
  labs(title = "B2: Proportion of respondents selecting each option",
       x = NULL, y = "% selecting") +
  theme_minimal(base_size = 12)
```

<img src="fig/quantitative_data_analysis-rendered-multiselect-B2-1.png" alt="" style="display: block; margin: auto;" />

`B2_6` is the most commonly selected option and `B2_2` the least.
 
### Correlation matrix 

A correlation matrix is a useful diagnostic tool when working with multiple-response (multi-select) questions. Although each boolean column is structurally independent (meaning there is no logical rule preventing a respondent from selecting any combination of options), respondents' choices in practice often cluster together. 

We can use a correlation plot from the `corrplot` package to visualise the pairwise phi coefficients (Pearson correlation applied to 0/1 data) for all `B1` and `B2` option columns simultaneously. 

The colour hue indicates direction: blue cells mean two options tend to be co-selected, while red cells mean selecting one option is associated with not selecting the other. Colour intensity encodes strength; darker shades indicate stronger associations, paler shades near-zero relationships. 

As a practical guide, coefficients with an absolute value above 0.3 are worth flagging, and values above 0.6 suggest two options may be capturing the same underlying preference and could potentially be combined.

This step should always precede any analysis that treats the `B` section columns as independent predictors, since strong co-selection patterns can distort results if not investigated.

Let's code a `corrplot` for `B1_*` columns. As a reminder, the options were:

**Question B1:** What should be the main goal of flexible working policies? (Select up to 3) 

- B1_1: Improve employee wellbeing & work-life balance
- B1_2: Boost productivity & business performance
- B1_3: Attract & retain top talent
- B1_4: Reduce costs & office overhead
- B1_5: Support diversity, equity & inclusion

 

``` r
survey %>%
  select(starts_with("B1_")) %>%
  mutate(across(everything(), as.integer)) %>%   # TRUE/FALSE → 1/0
  cor(method = "pearson") %>%                    # phi coefficient for binary vars
  corrplot(method = "color", type = "upper",
           addCoef.col = "black", tl.col = "black")
```

<img src="fig/quantitative_data_analysis-rendered-corrplot-1.png" alt="" style="display: block; margin: auto;" />

This `corrplot` demonstrates that questions `B1_1` and `B1_3` show a mild positive correlation, with a co-efficient of *0.38*, meaning respondents may be more likely to co-select these two options, while `B1_1` and `B1_5` and `B1_3` and `B1_5` show a mild negative correlation, meaning respondents may be more likely to not co-select these two options. The coefficients are all less than 0.6, but we'll keep these associations in mind.

Now let's code a `corrplot` for `B2_*` columns. As a reminder, the options were:

**Question B2:** Who should benefit most from flexible working?
(Select up to 3) 

- B2_1: All employees equally, regardless of role or seniority
- B2_2: Parents and caregivers with dependants
- B2_3: Employees with disabilities or chronic health conditions
- B2_4: Junior/entry-level employees building their careers
- B2_5: Senior/experienced employees with proven track records
- B2_6: Employees with long commutes or remote locations
- B2_7: Employees from underrepresented or marginalised groups
- B2_8: High performers and those meeting targets consistently

 

``` r
survey %>%
  select(starts_with("B2_")) %>%
  mutate(across(everything(), as.integer)) %>%   # TRUE/FALSE → 1/0
  cor(method = "pearson") %>%                    # phi coefficient for binary vars
  corrplot(method = "color", type = "upper",
           addCoef.col = "black", tl.col = "black")
```

<img src="fig/quantitative_data_analysis-rendered-corrplot2-1.png" alt="" style="display: block; margin: auto;" />

Again, no coefficients are > 0.6, but we'll be mindful of any coefficients > 0.3.

## Chi-square tests of independence

The **Chi-square test of independence** (χ²) tests whether two categorical variables are associated with each other, or whether any observed differences in proportions are plausibly due to chance.

::: callout
### When to use a Chi-Square Test

- Both variables are categorical (nominal or ordinal). 
- You are testing association, not causation. 
- Each cell in your contingency table should have an expected frequency of at least 5. 
- Your sample size is reasonably large (n > 30 as a general guide).
:::

### When is the Chi-square test appropriate?

The Chi-square test of independence applies when:

1. Observations are independent: each respondent contributes exactly one row.
2. Both variables are categorical (nominal or ordinal).
3. The **expected** count in each cell of the contingency table is at least 5 (the test becomes unreliable with smaller expected counts).

We will check assumption 3 explicitly for every test by examining `chisq.test()$expected`.

### Effect size: Cramér's V

A p-value only tells us whether an association exists; it does not tell us how strong it is. **Cramér's V** is the standard effect size for Chi-square tests. It ranges from 0 (no association) to 1 (perfect association) and is comparable across tables of different sizes.

| Cramér's V | Interpretation      |
|------------|---------------------|
| 0          | No association      |
| 0.1        | Small effect        |
| 0.3        | Medium effect       |
| 0.5        | Large effect        |
| 1          | Perfect association |

We compute it with `cramerV()` from the `rcompanion` package.

### Test 1: A boolean B-item × Gender (B1_1 × A1)

Let's use the Chi-square test to answer this **Research question:** Are men and women equally likely to select option 1 of question B1?



``` r
tbl_B1_A1 <- table(survey$B1_1, survey$A1)
tbl_B1_A1
```

``` output
       
        male female
  FALSE  342    111
  TRUE    80    472
```

``` r
chi1 <- chisq.test(tbl_B1_A1)
chi1
```

``` output

	Pearson's Chi-squared test with Yates' continuity correction

data:  tbl_B1_A1
X-squared = 377.63, df = 1, p-value < 2.2e-16
```

``` r
chi1$expected   # for a 2×2 table, four cells
```

``` output
       
            male   female
  FALSE 190.2149 262.7851
  TRUE  231.7851 320.2149
```

``` r
cramerV(tbl_B1_A1)
```

``` output
Cramer V 
   0.615 
```

For a 2×2 contingency table, we can also compute an **odds ratio** to express the association in a more interpretable way: the odds of selecting B1_1 for one gender relative to the other.


``` r
oddsratio(tbl_B1_A1)$measure
```

``` output
       odds ratio with 95% C.I.
        estimate    lower    upper
  FALSE  1.00000       NA       NA
  TRUE  18.08038 13.20277 25.03645
```

An odds ratio of 1 means equal odds for both groups. Values above 1 mean the
first row group has higher odds; values below 1 mean lower odds. The odds ratio is calculated relative to whichever factor level R treats as the reference level, which is determined by the factor level order. To check the factor level, use `levels()`.


``` r
levels(survey[["A1"]])
```

``` output
[1] "male"   "female"
```

The odds ratio of 18.08 is in the TRUE row, meaning TRUE has 18 times greater odds compared to FALSE, with male as the reference group for the column variable (as male is the first level).

So the correct interpretation is:

"With FALSE as the reference category and male as the reference group, the odds ratio of 18.08 means that the odds of selecting TRUE are 18 times greater for females than for males (95% CI [13.20, 25.04])."

In other words the OR is comparing:

Rows: TRUE vs FALSE (FALSE = reference)
Columns: female vs male (male = reference, as confirmed by `levels()`)

::: callout
### Reporting checklist

When writing up Chi-square results for a report, include the following:

1. **The research question**: what association are you testing?
2. **The contingency table**: row percentages to show the pattern
3. **Test statistic and degrees of freedom**: χ²(df) = X.XX.
4. **p-value**: exact value to three decimal places (or < .001)
5. **Assumption check**: confirm expected counts ≥ 5 in all (or at least 80%) of cells
6. **Effect size**: Cramér's V with interpretation (small / medium / large)
7. **Odds ratio** if significant): identify the association
7. **Standardised residuals** (if significant): identify which cells drive the association

An example sentence:

"Gender was significantly associated with the selection of 'Improve employee wellbeing & work-life balance' as a main goal of flexible working policies (χ²(1) = 377.63, p < 0.001), with a large effect size (Cramér's V = 0.615).

Female employees had substantially higher odds of selecting this priority compared to their male counterparts (OR = 18.08, 95% CI [13.20, 25.04]), indicating that female employees were approximately 18 times more likely to select this option than male employees. This strong and statistically robust difference suggests that improving employee wellbeing and work-life balance is a considerably more pressing concern for female employees."

:::


We can expand on this code to run Chi-square, Cramér's, and odd's for all `B1_*` columns, and report the results out in an easy to read table.

### Test 2: A boolean B-item × Gender (All B1_* × A1)


``` r
# Select all B1_ columns
b1_vars <- survey %>%
  select(starts_with("B1_")) %>%
  names()

results_B1_A1 <- tibble(b1_var = b1_vars) %>%
  rowwise() %>%
  mutate(
    tbl         = list(table(survey[[b1_var]], survey[["A1"]])),
    chi_test    = list(chisq.test(tbl)),
    n_cells_low = sum(chi_test$expected < 5),
    chi_stat    = chi_test$statistic,
    chi_df      = chi_test$parameter,
    chi_p       = chi_test$p.value,
    cramers_v   = cramerV(tbl),
    or_result   = list(
      tryCatch(
        {
          or_out <- oddsratio(tbl)$measure
          tibble(
            or       = or_out[2, "estimate"],
            or_lower = or_out[2, "lower"],
            or_upper = or_out[2, "upper"]
          )
        },
        error = function(e) tibble(or = NA_real_, or_lower = NA_real_, or_upper = NA_real_)
      )
    )
  ) %>%
  unnest(or_result) %>%
  ungroup() %>%
  select(-tbl, -chi_test) %>%
  mutate(across(c(chi_stat, chi_p, cramers_v, or, or_lower, or_upper), ~round(., 4)))


results_B1_A1
```

``` output
# A tibble: 5 × 9
  b1_var n_cells_low chi_stat chi_df  chi_p cramers_v      or or_lower or_upper
  <chr>        <int>    <dbl>  <int>  <dbl>     <dbl>   <dbl>    <dbl>    <dbl>
1 B1_1             0  378.         1 0         0.615  18.1      13.2     25.0  
2 B1_2             0    0.267      1 0.605     0.0186  0.919     0.695    1.22 
3 B1_3             0  457.         1 0         0.676  39.8      26.7     61.5  
4 B1_4             0   12.2        1 0.0005    0.112   1.58      1.23     2.03 
5 B1_5             0  292.         1 0         0.541   0.0821    0.06     0.111
```

::: callout
### Multiple comparisons

Running multiple Chi-square tests simultaneously inflates the probability of
at least one false positive. To address this, we apply the **Benjamini-Hochberg
False Discovery Rate (FDR)** correction using p.adjust(method = "fdr"), which
controls the expected proportion of false positives among significant results.

Unlike the Bonferroni correction, which controls the probability of any
false positive and can be overly conservative when running many correlated tests, FDR offers a better balance between sensitivity and specificity, making it well suited to survey data where items tend to be correlated. Adjusted p-values are interpreted against the same α threshold of 0.05.
:::

Let's repeat our above analysis and include the **FDR correction**.


``` r
results_B1_A1_fdr <- tibble(b1_var = b1_vars) %>%
  rowwise() %>%
  mutate(
    tbl         = list(table(survey[[b1_var]], survey[["A1"]])),
    chi_test    = list(chisq.test(tbl)),
    n_cells_low = sum(chi_test$expected < 5),
    chi_stat    = chi_test$statistic,
    chi_df      = chi_test$parameter,
    chi_p       = chi_test$p.value,
    cramers_v   = cramerV(tbl),
    or_result   = list(
      tryCatch(
        {
          or_out <- oddsratio(tbl)$measure
          tibble(
            or       = or_out[2, "estimate"],
            or_lower = or_out[2, "lower"],
            or_upper = or_out[2, "upper"]
          )
        },
        error = function(e) tibble(or = NA_real_, or_lower = NA_real_, or_upper = NA_real_)
      )
    )
  ) %>%
  unnest(or_result) %>%
  ungroup() %>%
  select(-tbl, -chi_test) %>%
  mutate(chi_p_fdr = p.adjust(chi_p, method = "fdr")) %>% # Use FDR correction
  arrange(chi_p_fdr) %>%
  mutate(across(c(chi_stat, chi_p, chi_p_fdr, cramers_v, or, or_lower, or_upper), ~round(., 4)))


results_B1_A1_fdr
```

``` output
# A tibble: 5 × 10
  b1_var n_cells_low chi_stat chi_df  chi_p cramers_v      or or_lower or_upper
  <chr>        <int>    <dbl>  <int>  <dbl>     <dbl>   <dbl>    <dbl>    <dbl>
1 B1_3             0  457.         1 0         0.676  39.8      26.7     61.5  
2 B1_1             0  378.         1 0         0.615  18.1      13.2     25.0  
3 B1_5             0  292.         1 0         0.541   0.0821    0.06     0.111
4 B1_4             0   12.2        1 0.0005    0.112   1.58      1.23     2.03 
5 B1_2             0    0.267      1 0.605     0.0186  0.919     0.695    1.22 
# ℹ 1 more variable: chi_p_fdr <dbl>
```

Our reporting would now include the fact that the p-value was corrected.
"After FDR correction, gender remained significantly associated with the selection of 'Improve employee wellbeing & work-life balance' as a main goal of flexible working policies (χ²(1) = 377.63, p_adj < 0.001), with a large effect size (Cramér's V = 0.615).

Female employees had substantially higher odds of selecting this priority compared to their male counterparts (OR = 18.08, 95% CI [13.20, 25.04]), indicating that female employees were approximately 18 times more likely to select this option than male employees. This strong and statistically robust difference suggests that improving employee wellbeing and work-life balance is a considerably more pressing concern for female employees."


## When Chi-square assumptions fail — Fisher's exact test

If any expected cell count falls below 5, the Chi-square approximation becomes unreliable. This is most likely to happen with small subgroups, such as when we cross region (three levels, potentially unequal) with education (three levels) — some combinations may be rare.


``` r
tbl_A5_A2 <- table(survey$A5, survey$A2)
chisq.test(tbl_A5_A2)$expected   # check first
```

``` output
         
             18-34    35-54      55+
  region1 161.7104 135.3552 29.93433
  region2  99.4000  83.2000 18.40000
  region3 235.8896 197.4448 43.66567
```

If any expected count is below 5, switch to Fisher's exact test (not necessary in our case, but let's write the code anyway as a demonstration). For tables larger than 2×2, base R's exact computation is impractical, so we use a Monte Carlo simulation (`simulate.p.value = TRUE`).


``` r
fisher.test(tbl_A5_A2,
            simulate.p.value = TRUE,
            B = 10000)   # B = number of Monte Carlo replicates
```

``` output

	Fisher's Exact Test for Count Data with simulated p-value (based on
	10000 replicates)

data:  tbl_A5_A2
p-value = 0.3541
alternative hypothesis: two.sided
```

The Monte Carlo p-value is based on 10,000 random permutations of the table and is a reliable substitute for the asymptotic Chi-square approximation when cell counts are small.

For 2X2 tables, just use the Fisher's Exact Test with no simulation. Again, our expected cell counts are > 5, so this is just a demonstration.


``` r
tbl_A1_B1_1 <- table(survey$A1, survey$B1_1)
chisq.test(tbl_A1_B1_1)$expected   # check first
```

``` output
        
            FALSE     TRUE
  male   190.2149 231.7851
  female 262.7851 320.2149
```

``` r
fisher.test(tbl_A1_B1_1)
```

``` output

	Fisher's Exact Test for Count Data

data:  tbl_A1_B1_1
p-value < 2.2e-16
alternative hypothesis: true odds ratio is not equal to 1
95 percent confidence interval:
 13.05339 25.35389
sample estimates:
odds ratio 
  18.09696 
```

::: callout

**Interpreting a 2×3 table**

A significant Chi-square result tells us that the overall pattern of income
differs between urban and rural areas. It does **not** tell us which specific income category drives the difference. To find that, examine the standardised residuals (see Test 3 below).

:::


##  Standardised residuals

### Test 3: Satisfaction × Age group (E1 × A2)

**Research question:** Does overall satisfaction with work life balance (E1) vary across age groups (A2)?

This test introduces a powerful diagnostic tool: **standardised residuals**.
After a significant Chi-square test, standardised residuals tell us which
cells contribute most to the result; that is, where the observed count differs
most from what we would expect under independence.

A standardised residual beyond ±2 (roughly corresponding to a two-tailed
p < 0.05) flags a cell that is "doing more than its share" of the Chi-square
statistic- where the associations are the strongest.


``` r
# Note: 4 respondents have a missing E1 value; drop them with na.omit()
df_E1 <- survey %>%
  filter(!is.na(E1)) %>%
  mutate(E1 = factor(E1, levels = c(
    "Strongly dissatisfied", "Dissatisfied",
    "Neutral", "Satisfied", "Strongly satisfied"
  )))

tbl_E1_A2 <- table(df_E1$E1, df_E1$A2)

chi3 <- chisq.test(tbl_E1_A2)
chi3
```

``` output

	Pearson's Chi-squared test

data:  tbl_E1_A2
X-squared = 58.518, df = 8, p-value = 9.096e-10
```

``` r
chi3$expected   # check assumption
```

``` output
                       
                           18-34    35-54      55+
  Strongly dissatisfied 109.2308 91.42857 19.34066
  Dissatisfied          107.7413 90.18182 19.07692
  Neutral               101.7832 85.19481 18.02198
  Satisfied             107.2448 89.76623 18.98901
  Strongly satisfied     71.0000 59.42857 12.57143
```

``` r
cramerV(tbl_E1_A2)
```

``` output
Cramer V 
   0.171 
```

Now examine the standardised residuals:


``` r
round(chi3$stdres, 2)
```

``` output
                       
                        18-34 35-54   55+
  Strongly dissatisfied  6.07 -4.25 -3.33
  Dissatisfied           1.27 -0.18 -1.92
  Neutral               -2.16  2.19 -0.01
  Satisfied             -3.26  1.75  2.72
  Strongly satisfied    -2.35  0.65  3.01
```

We can also visualise them using `corrplot`, which makes the pattern immediately
apparent:


``` r
corrplot(chi3$stdres,
         is.corr = FALSE,
         method = "color",
         col = colorRampPalette(c("royalblue", "white", "firebrick"))(200),
         tl.col = "black",
         tl.srt = 45,
         tl.cex = 0.85,        # increase/decrease label size (default is 0.8)
         cl.cex = 0.85,        # match colour legend text size
         cl.ratio = 0.4,        # widens the legend bar giving labels more room
         title = "Standardised residuals: E1 satisfaction × A2 age group",
         mar = c(0, 0, 2, 0))
```

<img src="fig/quantitative_data_analysis-rendered-residuals-plot-E1-A2-1.png" alt="" style="display: block; margin: auto;" />

In this plot, red cells indicate that a combination is observed *more* often
than expected under independence; blue cells indicate it is observed *less*
often. Cells with residuals beyond ±2 are where the association is "happening".

Example results sentence:

"Overall satisfaction with work life balance differed significantly across age groups (χ²(8) = 58.52, p < 0.001), though the association was small in magnitude (Cramér's V = 0.171). Satisfaction tended to increase with age: older employees (55+) were more likely than expected to report being satisfied (residual = 2.72) or strongly satisfied (residual = 3.01), while younger employees (18-34) were substantially more likely than expected to report strong dissatisfaction (residual = 6.07) and less likely to report satisfaction (residual = −3.26) or strong satisfaction (residual = −2.35). Employees aged 35–54 showed little deviation from expected counts, with only a modest tendency toward neutrality (residual = 2.19)."
