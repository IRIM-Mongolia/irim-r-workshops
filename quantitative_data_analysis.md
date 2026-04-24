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
-   Identify the correct statistical test for a given variable type and
    research question
-   Run chi-square tests, t-tests, and one-way ANOVAs in R Notebooks
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

[See Workshop 5 Slides here](https://irimmn.sharepoint.com/:p:/s/IRIMRWorkshops/IQAu_EPJ2JxWSKEWpe68tf12Ac_tkOYCOrSG-ls8oE8Qcro?e=0kUTeI)

[See Workshop 5 recording here - 1](https://irimmn.sharepoint.com/:v:/s/IRIMRWorkshops/IQDDs6ewnFXFSZFVox-GZ6UrAc-0RSCVDCZGcEEp3_aZJbs?e=zdebp3)

## Dataset Overview

This workshop uses a generated (made-up) dataset containing 1005
responses to a survey on flexible working and work-life balance, with a
number of different data types.

The schema is included in the following table.

**Flexible working and work-life balance survey data schema**

+--------------+--------------+--------------+---------------------+
| Section      | Variable     | Type         | Description         |
+==============+==============+==============+=====================+
| A            | A1 - Gender  | Factor       | What is your        |
| (D           |              | (male,       | gender?             |
| emographics) |              | female)      |                     |
+--------------+--------------+--------------+---------------------+
|              | A2 - Age     | Ordered      | What is your age?   |
|              | Group        | Factor       |                     |
|              |              | (18-34,      |                     |
|              |              | 35-54, 55+)  |                     |
+--------------+--------------+--------------+---------------------+
|              | A3 -         | Ordered      | What is your        |
|              | Education    | Factor       | highest level of    |
|              |              | (primary,    | education?          |
|              |              | secondary,   |                     |
|              |              | tertiary or  |                     |
|              |              | higher)      |                     |
+--------------+--------------+--------------+---------------------+
|              | A4 - Income  | Ordered      | What is your annual |
|              |              | Factor       | income?             |
|              |              |              |                     |
|              |              | (low,        |                     |
|              |              | middle,      |                     |
|              |              | high)        |                     |
+--------------+--------------+--------------+---------------------+
|              | A5 - Region  | Factor       | What is your region |
|              |              | (region 1,   | of residence?       |
|              |              | 2, 3)        |                     |
+--------------+--------------+--------------+---------------------+
|              | A6 - Area    | Factor       | Is your region of   |
|              | Type         | (rural,      | residence urban or  |
|              |              | urban)       | rural?              |
+--------------+--------------+--------------+---------------------+
| B (Policy    | B1           | Character    | What should be the  |
| Views)       |              |              | main goal of        |
|              |              |              | flexible working    |
|              |              |              | policies? (Select   |
|              |              |              | up to 3)            |
+--------------+--------------+--------------+---------------------+
|              | B1_1         | Logical      | Improve employee    |
|              |              |              | wellbeing &         |
|              |              |              | work-life balance   |
+--------------+--------------+--------------+---------------------+
|              | B1_2         | Logical      | Boost productivity  |
|              |              |              | & business          |
|              |              |              | performance         |
+--------------+--------------+--------------+---------------------+
|              | B1_3         | Logical      | Attract & retain    |
|              |              |              | top talent          |
+--------------+--------------+--------------+---------------------+
|              | B1_4         | Logical      | Reduce costs &      |
|              |              |              | office overhead     |
+--------------+--------------+--------------+---------------------+
|              | B1_5         | Logical      | Support diversity,  |
|              |              |              | equity & inclusion  |
+--------------+--------------+--------------+---------------------+
| B (Policy    | B2           | Character    | Who should benefit  |
| Views)       |              |              | most from flexible  |
|              |              |              | working             |
|              |              |              | arrangements        |
|              |              |              | (Select up to 3)    |
+--------------+--------------+--------------+---------------------+
|              | B2_1         | Logical      | All employees       |
|              |              |              | equally, regardless |
|              |              |              | of role or          |
|              |              |              | seniority           |
+--------------+--------------+--------------+---------------------+
|              | B2_2         | Logical      | Parents and         |
|              |              |              | caregivers with     |
|              |              |              | dependants          |
+--------------+--------------+--------------+---------------------+
|              | B2_3         | Logical      | Employees with      |
|              |              |              | disabilities or     |
|              |              |              | chronic health      |
|              |              |              | conditions          |
+--------------+--------------+--------------+---------------------+
|              | B2_4         | Logical      | Junior/entry-level  |
|              |              |              | employees building  |
|              |              |              | their careers       |
+--------------+--------------+--------------+---------------------+
|              | B2_5         | Logical      | Senior/experienced  |
|              |              |              | employees with      |
|              |              |              | proven track        |
|              |              |              | records             |
+--------------+--------------+--------------+---------------------+
|              | B2_6         | Logical      | Employees with long |
|              |              |              | commutes or remote  |
|              |              |              | locations           |
+--------------+--------------+--------------+---------------------+
|              | B2_7         | Logical      | Employees from      |
|              |              |              | underrepresented or |
|              |              |              | marginalised groups |
+--------------+--------------+--------------+---------------------+
|              | B2_8         | Logical      | High performers and |
|              |              |              | those meeting       |
|              |              |              | targets             |
|              |              |              | consistently        |
+--------------+--------------+--------------+---------------------+
| C (Likert    | C1           | Integer      | How satisfied are   |
| Scales)      |              | (1-5)        | you with your       |
|              |              |              | current flexible    |
|              |              |              | working             |
|              |              |              | arrangements (1     |
|              |              |              | least satisfied, 5  |
|              |              |              | most satisifed)     |
+--------------+--------------+--------------+---------------------+
|              | C2           | Integer      | To what extent do   |
|              |              | (1-5)        | flexible working    |
|              |              |              | options improve     |
|              |              |              | your work-life      |
|              |              |              | balance? (1 very    |
|              |              |              | little, 5 very      |
|              |              |              | much)               |
+--------------+--------------+--------------+---------------------+
|              | C3           | Integer      | How strongly do you |
|              |              | (1-5)        | agree that your     |
|              |              |              | employer supports   |
|              |              |              | flexible working in |
|              |              |              | practice (1 very    |
|              |              |              | little, 5 very      |
|              |              |              | much)               |
+--------------+--------------+--------------+---------------------+
| D (Con       | D1           | Numeric      | What is your        |
| tinuous)     |              |              | commute time to     |
|              |              |              | work in minutes?    |
+--------------+--------------+--------------+---------------------+
| D (Con       | D2           | Numeric      | What is your        |
| tinuous)     |              |              | commute distance in |
|              |              |              | km?                 |
+--------------+--------------+--------------+---------------------+
| E (O         | E1           | Ordered      | How satisfied are   |
| utcomes)     |              | Factor       | you with your       |
|              |              |              | current work life   |
|              |              |              | balance? (strongly  |
|              |              |              | dissatisfied,       |
|              |              |              | dissatisfied,       |
|              |              |              | neutral, satisfied, |
|              |              |              | strongly satisfied) |
+--------------+--------------+--------------+---------------------+
| E            | E2           | Free text    | What makes you most |
|              |              |              | satisfied in your   |
|              |              |              | personal life?      |
|              |              |              | (free text)         |
+--------------+--------------+--------------+---------------------+

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
for (pkg in c("tidyverse", "here", "gtsummary")) {
  if (!requireNamespace(pkg)) install.packages(pkg)
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
[32m✔[0m bitops 1.0-9                             [11 kB in 0.25s]
[32m✔[0m cardx 0.3.2                              [200 kB in 0.31s]
[32m✔[0m juicyjuice 0.1.0                         [1.1 MB in 0.31s]
[32m✔[0m reactR 0.6.1                             [712 kB in 0.32s]
[32m✔[0m cards 0.7.1                              [321 kB in 0.33s]
[32m✔[0m gtsummary 2.5.0                          [935 kB in 0.33s]
[32m✔[0m reactable 0.4.5                          [981 kB in 0.34s]
[32m✔[0m bigD 0.3.1                               [1.3 MB in 0.36s]
[32m✔[0m gt 1.3.0                                 [3.4 MB in 0.37s]
Successfully downloaded 9 packages in 0.64 seconds.

# Installing packages --------------------------------------------------------
[32m✔[0m juicyjuice 0.1.0                         [built from source in 5.5s]
[32m✔[0m bitops 1.0-9                             [built from source in 7.0s]
[32m✔[0m reactR 0.6.1                             [built from source in 5.7s]
[32m✔[0m reactable 0.4.5                          [built from source in 6.5s]
[32m✔[0m cards 0.7.1                              [built from source in 20s]
[32m✔[0m bigD 0.3.1                               [built from source in 25s]
[32m✔[0m cardx 0.3.2                              [built from source in 9.2s]
[32m✔[0m gt 1.3.0                                 [built from source in 19s]
[32m✔[0m gtsummary 2.5.0                          [built from source in 8.9s]
Successfully installed 9 packages in 53 seconds.
```

``` r
library(tidyverse)
library(here)
library(gtsummary)
```

Then, download the the generated survey dataset using the following
code:

`download.file("https://raw.githubusercontent.com/IRIM-Mongolia/irim-r-workshops/main/episodes/data/raw/generated_survey_data.csv", here("data/raw/generated_survey_data.csv"), mode = "wb")`

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
                levels = c("female", "male")),
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
 $ A1  : Factor w/ 2 levels "female","male": 2 2 1 2 2 1 2 1 2 2 ...
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
groups, which is important, as some tests (like chi-square) require
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
    statistic = list(all_categorical() ~ "{n} ({p}%)"),  # count and proportion
    missing   = "ifany"                                   # show missing if present
  )
```

<!--html_preserve--><div id="cyqufpunty" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#cyqufpunty table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#cyqufpunty thead, #cyqufpunty tbody, #cyqufpunty tfoot, #cyqufpunty tr, #cyqufpunty td, #cyqufpunty th {
  border-style: none;
}

#cyqufpunty p {
  margin: 0;
  padding: 0;
}

#cyqufpunty .gt_table {
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

#cyqufpunty .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#cyqufpunty .gt_title {
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

#cyqufpunty .gt_subtitle {
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

#cyqufpunty .gt_heading {
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

#cyqufpunty .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cyqufpunty .gt_col_headings {
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

#cyqufpunty .gt_col_heading {
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

#cyqufpunty .gt_column_spanner_outer {
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

#cyqufpunty .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#cyqufpunty .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#cyqufpunty .gt_column_spanner {
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

#cyqufpunty .gt_spanner_row {
  border-bottom-style: hidden;
}

#cyqufpunty .gt_group_heading {
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

#cyqufpunty .gt_empty_group_heading {
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

#cyqufpunty .gt_from_md > :first-child {
  margin-top: 0;
}

#cyqufpunty .gt_from_md > :last-child {
  margin-bottom: 0;
}

#cyqufpunty .gt_row {
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

#cyqufpunty .gt_stub {
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

#cyqufpunty .gt_stub_row_group {
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

#cyqufpunty .gt_row_group_first td {
  border-top-width: 2px;
}

#cyqufpunty .gt_row_group_first th {
  border-top-width: 2px;
}

#cyqufpunty .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cyqufpunty .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#cyqufpunty .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#cyqufpunty .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cyqufpunty .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cyqufpunty .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#cyqufpunty .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#cyqufpunty .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#cyqufpunty .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cyqufpunty .gt_footnotes {
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

#cyqufpunty .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cyqufpunty .gt_sourcenotes {
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

#cyqufpunty .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cyqufpunty .gt_left {
  text-align: left;
}

#cyqufpunty .gt_center {
  text-align: center;
}

#cyqufpunty .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#cyqufpunty .gt_font_normal {
  font-weight: normal;
}

#cyqufpunty .gt_font_bold {
  font-weight: bold;
}

#cyqufpunty .gt_font_italic {
  font-style: italic;
}

#cyqufpunty .gt_super {
  font-size: 65%;
}

#cyqufpunty .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#cyqufpunty .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#cyqufpunty .gt_indent_1 {
  text-indent: 5px;
}

#cyqufpunty .gt_indent_2 {
  text-indent: 10px;
}

#cyqufpunty .gt_indent_3 {
  text-indent: 15px;
}

#cyqufpunty .gt_indent_4 {
  text-indent: 20px;
}

#cyqufpunty .gt_indent_5 {
  text-indent: 25px;
}

#cyqufpunty .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#cyqufpunty div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
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
    <tr><td headers="label" class="gt_row gt_left">    female</td>
<td headers="stat_0" class="gt_row gt_center">583 (58%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    male</td>
<td headers="stat_0" class="gt_row gt_center">422 (42%)</td></tr>
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

### Breakdown by demographics

We can also use the `tbl_summary()` function to automatically detects
variable types and calculate appropriate statistics; in this case,
counts and column percentages for categorical and logical variables.

Adding `add_p()` runs a chi-square test (or Fisher's exact test where
cell counts are small) for each variable automatically, allowing us to
quickly identify which variables show statistically significant
differences by gender before conducting more detailed analysis.


``` r
# Breakdown by demographic
survey %>% 
  select(starts_with("A"), matches("_\\d+$")) %>% 
  tbl_summary(
    by        = A1,
    statistic = list(all_categorical() ~ "{n} ({p}%)"),
    missing   = "ifany"
  ) %>% 
  add_p() %>%                         # adds chi-square/Fisher's automatically
  add_overall() %>%                   # adds total column
  bold_labels()
```

<!--html_preserve--><div id="wvnltdgyzj" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#wvnltdgyzj table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#wvnltdgyzj thead, #wvnltdgyzj tbody, #wvnltdgyzj tfoot, #wvnltdgyzj tr, #wvnltdgyzj td, #wvnltdgyzj th {
  border-style: none;
}

#wvnltdgyzj p {
  margin: 0;
  padding: 0;
}

#wvnltdgyzj .gt_table {
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

#wvnltdgyzj .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#wvnltdgyzj .gt_title {
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

#wvnltdgyzj .gt_subtitle {
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

#wvnltdgyzj .gt_heading {
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

#wvnltdgyzj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wvnltdgyzj .gt_col_headings {
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

#wvnltdgyzj .gt_col_heading {
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

#wvnltdgyzj .gt_column_spanner_outer {
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

#wvnltdgyzj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wvnltdgyzj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wvnltdgyzj .gt_column_spanner {
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

#wvnltdgyzj .gt_spanner_row {
  border-bottom-style: hidden;
}

#wvnltdgyzj .gt_group_heading {
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

#wvnltdgyzj .gt_empty_group_heading {
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

#wvnltdgyzj .gt_from_md > :first-child {
  margin-top: 0;
}

#wvnltdgyzj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wvnltdgyzj .gt_row {
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

#wvnltdgyzj .gt_stub {
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

#wvnltdgyzj .gt_stub_row_group {
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

#wvnltdgyzj .gt_row_group_first td {
  border-top-width: 2px;
}

#wvnltdgyzj .gt_row_group_first th {
  border-top-width: 2px;
}

#wvnltdgyzj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wvnltdgyzj .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#wvnltdgyzj .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#wvnltdgyzj .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wvnltdgyzj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wvnltdgyzj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wvnltdgyzj .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#wvnltdgyzj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wvnltdgyzj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wvnltdgyzj .gt_footnotes {
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

#wvnltdgyzj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wvnltdgyzj .gt_sourcenotes {
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

#wvnltdgyzj .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wvnltdgyzj .gt_left {
  text-align: left;
}

#wvnltdgyzj .gt_center {
  text-align: center;
}

#wvnltdgyzj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wvnltdgyzj .gt_font_normal {
  font-weight: normal;
}

#wvnltdgyzj .gt_font_bold {
  font-weight: bold;
}

#wvnltdgyzj .gt_font_italic {
  font-style: italic;
}

#wvnltdgyzj .gt_super {
  font-size: 65%;
}

#wvnltdgyzj .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#wvnltdgyzj .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#wvnltdgyzj .gt_indent_1 {
  text-indent: 5px;
}

#wvnltdgyzj .gt_indent_2 {
  text-indent: 10px;
}

#wvnltdgyzj .gt_indent_3 {
  text-indent: 15px;
}

#wvnltdgyzj .gt_indent_4 {
  text-indent: 20px;
}

#wvnltdgyzj .gt_indent_5 {
  text-indent: 25px;
}

#wvnltdgyzj .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#wvnltdgyzj div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_0"><span class='gt_from_md'><strong>Overall</strong><br />
N = 1,005</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>female</strong><br />
N = 583</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>male</strong><br />
N = 422</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
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
<td headers="stat_1" class="gt_row gt_center">294 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">203 (48%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    35-54</td>
<td headers="stat_0" class="gt_row gt_center">416 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">246 (42%)</td>
<td headers="stat_2" class="gt_row gt_center">170 (40%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    55+</td>
<td headers="stat_0" class="gt_row gt_center">92 (9.2%)</td>
<td headers="stat_1" class="gt_row gt_center">43 (7.4%)</td>
<td headers="stat_2" class="gt_row gt_center">49 (12%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A3</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.7</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    primary</td>
<td headers="stat_0" class="gt_row gt_center">101 (10%)</td>
<td headers="stat_1" class="gt_row gt_center">62 (11%)</td>
<td headers="stat_2" class="gt_row gt_center">39 (9.2%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    secondary</td>
<td headers="stat_0" class="gt_row gt_center">545 (54%)</td>
<td headers="stat_1" class="gt_row gt_center">311 (53%)</td>
<td headers="stat_2" class="gt_row gt_center">234 (55%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    tertiary or higher</td>
<td headers="stat_0" class="gt_row gt_center">359 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">210 (36%)</td>
<td headers="stat_2" class="gt_row gt_center">149 (35%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A4</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    low</td>
<td headers="stat_0" class="gt_row gt_center">394 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">240 (41%)</td>
<td headers="stat_2" class="gt_row gt_center">154 (36%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    middle</td>
<td headers="stat_0" class="gt_row gt_center">326 (32%)</td>
<td headers="stat_1" class="gt_row gt_center">189 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">137 (32%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    high</td>
<td headers="stat_0" class="gt_row gt_center">285 (28%)</td>
<td headers="stat_1" class="gt_row gt_center">154 (26%)</td>
<td headers="stat_2" class="gt_row gt_center">131 (31%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A5</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region1</td>
<td headers="stat_0" class="gt_row gt_center">327 (33%)</td>
<td headers="stat_1" class="gt_row gt_center">186 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">141 (33%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region2</td>
<td headers="stat_0" class="gt_row gt_center">201 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">128 (22%)</td>
<td headers="stat_2" class="gt_row gt_center">73 (17%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    region3</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">269 (46%)</td>
<td headers="stat_2" class="gt_row gt_center">208 (49%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">A6</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">0.3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Rural</td>
<td headers="stat_0" class="gt_row gt_center">528 (53%)</td>
<td headers="stat_1" class="gt_row gt_center">314 (54%)</td>
<td headers="stat_2" class="gt_row gt_center">214 (51%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Urban</td>
<td headers="stat_0" class="gt_row gt_center">477 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">269 (46%)</td>
<td headers="stat_2" class="gt_row gt_center">208 (49%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_1</td>
<td headers="stat_0" class="gt_row gt_center">552 (55%)</td>
<td headers="stat_1" class="gt_row gt_center">472 (81%)</td>
<td headers="stat_2" class="gt_row gt_center">80 (19%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_2</td>
<td headers="stat_0" class="gt_row gt_center">276 (27%)</td>
<td headers="stat_1" class="gt_row gt_center">156 (27%)</td>
<td headers="stat_2" class="gt_row gt_center">120 (28%)</td>
<td headers="p.value" class="gt_row gt_center">0.6</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_3</td>
<td headers="stat_0" class="gt_row gt_center">470 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">440 (75%)</td>
<td headers="stat_2" class="gt_row gt_center">30 (7.1%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_4</td>
<td headers="stat_0" class="gt_row gt_center">495 (49%)</td>
<td headers="stat_1" class="gt_row gt_center">315 (54%)</td>
<td headers="stat_2" class="gt_row gt_center">180 (43%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B1_5</td>
<td headers="stat_0" class="gt_row gt_center">507 (50%)</td>
<td headers="stat_1" class="gt_row gt_center">160 (27%)</td>
<td headers="stat_2" class="gt_row gt_center">347 (82%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_1</td>
<td headers="stat_0" class="gt_row gt_center">298 (30%)</td>
<td headers="stat_1" class="gt_row gt_center">83 (14%)</td>
<td headers="stat_2" class="gt_row gt_center">215 (51%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_2</td>
<td headers="stat_0" class="gt_row gt_center">206 (20%)</td>
<td headers="stat_1" class="gt_row gt_center">125 (21%)</td>
<td headers="stat_2" class="gt_row gt_center">81 (19%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_3</td>
<td headers="stat_0" class="gt_row gt_center">417 (41%)</td>
<td headers="stat_1" class="gt_row gt_center">388 (67%)</td>
<td headers="stat_2" class="gt_row gt_center">29 (6.9%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_4</td>
<td headers="stat_0" class="gt_row gt_center">362 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">168 (29%)</td>
<td headers="stat_2" class="gt_row gt_center">194 (46%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_5</td>
<td headers="stat_0" class="gt_row gt_center">358 (36%)</td>
<td headers="stat_1" class="gt_row gt_center">99 (17%)</td>
<td headers="stat_2" class="gt_row gt_center">259 (61%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_6</td>
<td headers="stat_0" class="gt_row gt_center">469 (47%)</td>
<td headers="stat_1" class="gt_row gt_center">403 (69%)</td>
<td headers="stat_2" class="gt_row gt_center">66 (16%)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_7</td>
<td headers="stat_0" class="gt_row gt_center">389 (39%)</td>
<td headers="stat_1" class="gt_row gt_center">219 (38%)</td>
<td headers="stat_2" class="gt_row gt_center">170 (40%)</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">B2_8</td>
<td headers="stat_0" class="gt_row gt_center">377 (38%)</td>
<td headers="stat_1" class="gt_row gt_center">187 (32%)</td>
<td headers="stat_2" class="gt_row gt_center">190 (45%)</td>
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

We can also look at the mean and standard deviation of our continuous
variables, stratified by demographics. We'll look at variables `D1` and
`D2` by age group, `A2`.


``` r
survey %>% 
  select(A2, D1, D2) %>% 
  tbl_summary(
    by        = A2,
    statistic = list(
      all_categorical() ~ "{n} ({p}%)",
      all_continuous()  ~ "{mean} ({sd})"        # mean and standard deviation
    ),
    digits  = all_continuous() ~ 1,
    missing = "ifany",
    label   = list(
      D1 ~ "Commute time (minutes)",
      D2 ~ "Commute distance (km)"
    )
  ) %>% 
  add_p() %>%     
  add_overall() %>% 
  bold_labels()
```

<!--html_preserve--><div id="kfkgmsaeay" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#kfkgmsaeay table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#kfkgmsaeay thead, #kfkgmsaeay tbody, #kfkgmsaeay tfoot, #kfkgmsaeay tr, #kfkgmsaeay td, #kfkgmsaeay th {
  border-style: none;
}

#kfkgmsaeay p {
  margin: 0;
  padding: 0;
}

#kfkgmsaeay .gt_table {
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

#kfkgmsaeay .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kfkgmsaeay .gt_title {
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

#kfkgmsaeay .gt_subtitle {
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

#kfkgmsaeay .gt_heading {
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

#kfkgmsaeay .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kfkgmsaeay .gt_col_headings {
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

#kfkgmsaeay .gt_col_heading {
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

#kfkgmsaeay .gt_column_spanner_outer {
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

#kfkgmsaeay .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kfkgmsaeay .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kfkgmsaeay .gt_column_spanner {
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

#kfkgmsaeay .gt_spanner_row {
  border-bottom-style: hidden;
}

#kfkgmsaeay .gt_group_heading {
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

#kfkgmsaeay .gt_empty_group_heading {
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

#kfkgmsaeay .gt_from_md > :first-child {
  margin-top: 0;
}

#kfkgmsaeay .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kfkgmsaeay .gt_row {
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

#kfkgmsaeay .gt_stub {
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

#kfkgmsaeay .gt_stub_row_group {
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

#kfkgmsaeay .gt_row_group_first td {
  border-top-width: 2px;
}

#kfkgmsaeay .gt_row_group_first th {
  border-top-width: 2px;
}

#kfkgmsaeay .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kfkgmsaeay .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kfkgmsaeay .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kfkgmsaeay .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kfkgmsaeay .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kfkgmsaeay .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kfkgmsaeay .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#kfkgmsaeay .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kfkgmsaeay .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kfkgmsaeay .gt_footnotes {
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

#kfkgmsaeay .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kfkgmsaeay .gt_sourcenotes {
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

#kfkgmsaeay .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kfkgmsaeay .gt_left {
  text-align: left;
}

#kfkgmsaeay .gt_center {
  text-align: center;
}

#kfkgmsaeay .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kfkgmsaeay .gt_font_normal {
  font-weight: normal;
}

#kfkgmsaeay .gt_font_bold {
  font-weight: bold;
}

#kfkgmsaeay .gt_font_italic {
  font-style: italic;
}

#kfkgmsaeay .gt_super {
  font-size: 65%;
}

#kfkgmsaeay .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#kfkgmsaeay .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kfkgmsaeay .gt_indent_1 {
  text-indent: 5px;
}

#kfkgmsaeay .gt_indent_2 {
  text-indent: 10px;
}

#kfkgmsaeay .gt_indent_3 {
  text-indent: 15px;
}

#kfkgmsaeay .gt_indent_4 {
  text-indent: 20px;
}

#kfkgmsaeay .gt_indent_5 {
  text-indent: 25px;
}

#kfkgmsaeay .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#kfkgmsaeay div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
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
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">Commute time (minutes)</td>
<td headers="stat_0" class="gt_row gt_center">71.3 (27.4)</td>
<td headers="stat_1" class="gt_row gt_center">89.8 (17.2)</td>
<td headers="stat_2" class="gt_row gt_center">58.9 (20.0)</td>
<td headers="stat_3" class="gt_row gt_center">27.2 (16.4)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left" style="font-weight: bold;">Commute distance (km)</td>
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

::: callout
## Statistical tests used by `gtsummary`

When`add_p()` is called, `gtsummary` automatically selects a statistical
test based on the variable type and the number of groups being compared.
It defaults to conservative non-parametric tests for continuous
variables. Specifically, for continuous variables with two groups it
applies a Wilcoxon rank-sum test, and with three or more groups it
applies a Kruskal-Wallis test.

For categorical and logical variables, it uses a chi-square test,
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
