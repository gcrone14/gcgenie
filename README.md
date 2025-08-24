
# gcgenie

<!-- badges: start -->
<!-- badges: end -->

The goal of gcgenie is to provide a set of convenience functions that make 
routine data tasks faster and easier. It helps users clean messy datasets, 
generate counts and summaries, and quickly visualize results. This package is 
designed for analysts and researchers who want to streamline common workflows
without writing repetitive code.

## Installation

You can install the development version of gcgenie from [GitHub](https://github.com/gcrone14/gcgenie) with:

``` r
# install.packages("pak")
pak::pak("gcrone14/gcgenie")
```

## Example

The core functions of **gcgenie** let you compare the coding decisions of 
two raters, either across entire datasets (with compare_raters()) 
or element-by-element (with compare_vectors()).

```r
library(gcgenie)

# Example data from two raters
rater1 <- data.frame(
  var_1 = c(1, 3, 2),
  var_2 = c(2, 2, 2),
  var_3 = c(NA, 1, 1)
)

rater2 <- data.frame(
  var_1 = c(1, 3, 2),
  var_2 = c(2, 2, 1),
  var_3 = c(3, 1, 0)
)

# ---- Compare two raters cell-by-cell ----
compare_raters(rater1, rater2)
#   var_1 var_2 var_3
# 1     1     2  NA/3
# 2     3     2     1
# 3     2  2/1  1/0

# Use custom symbols for clearer marking
compare_raters(rater1, rater2,
               beg_symbol = "R1: ",
               sep_symbol = " | R2: ")
#   var_1   var_2        var_3
# 1     1       2   R1: NA | R2: 3
# 2     3       2           1
# 3     2 R1: 2 | R2: 1 R1: 1 | R2: 0

# ---- Compare two vectors element-by-element ----
vec1 <- c("yes", "yes", "no", "yes", "no")
vec2 <- c("no",  "yes", "no", "no",  "yes")

compare_vectors(vec1, vec2)
# [1] "yes/no" "yes" "no" "yes/no" "no/yes"
```

