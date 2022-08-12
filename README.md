
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rnote

<!-- badges: start -->
<!-- badges: end -->

rnote is a simple package that allows you to make notes and recall them
from any project by saving them to the package directory.

## Installation

You can install the development version of rnote from
[GitHub](https://github.com/filmicaesthetic/rnote) with:

``` r
# install.packages("devtools")
devtools::install_github("filmicaesthetic/rnote")
```

## Example

### Make a note:

``` r
rnote::jotdown(note = "this is a note", topics = c("test_topic1", "test_topic2"))
```

### Recall notes to console:

``` r
rnote::checknotes(topic = "test_topic1", current_project = TRUE, n = 10)
#> rnote | 2022-08-13
#> this is a note
```

### Back up notes to new location:

``` r
rnote::backup.notes(file = "notes.csv", current_project = FALSE)
```
