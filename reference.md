---
title: Learners' Reference
---

Cheat sheet of functions used in the workshops. This will be populated as we work through the workshops.

## Workshop -- Introduction to `R`

-   `install.packages()` \# install `R` packages to your computer

## Workshop -- Introduction to `R Packages`,`Markdown` and `Notebooks`

-   `library()` \# load `R` packages in each `R` session

## Workshop -- Starting with Data

-   `<-` \# assignment arrow assigns inputs to a named object
-   `read_csv()` \# import data in .`csv` files into `R` (`readr`, part of `tidyverse`)
-   `class()` \# check the class of an object
-   `dim()` \# returns a vector with the dimensions of the object
-   `nrow()` \# returns the number of rows
-   `ncol()` \# returns the number of columns
-   `head()` \# shows the first 6 rows
-   `tail()` \# shows the last 6 rows
-   `names()` \# returns the column names
-   `str()` \# structure of the object and information about the class, length and content of each column
-   `summary()` \# summary statistics for each column
-   `glimpse()` \# returns the number of columns and rows of a tibble, the names and class of each column, and previews as many values will fit on the screen (`dplyr`, part of `tidyverse`)
-   `c()` \# combine values into a vector or list
-   `factor()` \# encode a vector as a factor
-   `levels(0` \# provides access to the levels attribute of a variable
-   `nlevels()` \# provides number of levels of a factor
-   `as.character()` \# create or coerce objects of type character
-   `as.numeric()` \# create or coerce objects of type numeric
-   `as.factor()` \# encode a vector as a factor
-   `plot()` \# create a generic X-Y plot
-   `day()` \# extract day value from a date (`lubridate`, part of `tidyverse`)
-   `month()` \# extract month value from a date (`lubridate`, part of `tidyverse`)
-   `year()` \# extract year value from a date (`lubridate`, part of `tidyverse`)
-   `day()` \# extract day value from a date (`lubridate`, part of `tidyverse`)
-   `as_date()` \# convert an object to a date or date-time (`lubridate`, part of `tidyverse`)
-   `mdy()`, `ymd()`, `dmy()` \# parse dates (`lubridate`, part of `tidyverse`)

## Workshop -- Manipulating Data with `dplyr` and `tidyr`

-   `select()` \# subset columns (`dplyr`, part of `tidyverse`)
-   `filter()` \# subset rows on conditions (`dplyr`, part of `tidyverse`)
-   `mutate()` \# create new columns by using information from other columns (`dplyr`, part of `tidyverse`)
-   `group_by()` and `summarize()` \# create summary statistics on grouped data (`dplyr`, part of `tidyverse`)
-   `arrange()` \# sort results (`dplyr`, part of `tidyverse`)
-   `count()` \# count discrete values (`dplyr`, part of `tidyverse`)
-   `%>%` \# a pipe, take the output of one function and send it directly to the next (`tidyverse`)
-   `filter()` \# filter rows (`dplyr`, part of `tidyverse`)
-   `select()` \# seclect columns (`dplyr`, part of `tidyverse`)
-   `mutate()` \# create, modify, and delete columns (`dplyr`, part of `tidyverse`)
-   `distinct()` \# keep distinct/unique rows (`dplyr`, part of `tidyverse`)
-   `sample_n()` \# sample n rows from a table (`dplyr`, part of `tidyverse`)
-   `pivot_wider()` \# pivot data from long to wide (`tidyr`, part of `tidyverse`)
-   `pivot_longer()` \# pivot data from wide to long (`tidyr`, part of `tidyverse`)
-   `separate_longer_delim()` \# split a string into rows (`tidyr`, part of `tidyverse`)
-   `replace_na()` \# replace NAs with specified values (`tidyr`, part of `tidyverse`)
-   `write_csv()` \# export data in .`csv` format (`readr`, part of `tidyverse`)
