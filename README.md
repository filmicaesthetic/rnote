
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

## Changelog

See the [NEWS.md](NEWS.md) file for details on what's new in each release.


## Example

### Make a note:

``` r
rnote::jotdown(note = "this is a note", topics = c("test_topic1", "test_topic2"))
```

### Recall notes to console:

``` r
rnote::checknotes(current_project = TRUE, n = 10, topic = "test_topic1")
#> rnote | 2025-01-29
#> this is a note
```

### Save a copy of your notes to your project directory:

``` r
rnote::init_project_notes()
```

### Recall project notes to console:

``` r
rnote::check_project_notes(n = 10, topic = "test_topic1")
#> rnote | 2025-01-29
#> this is a note
```
