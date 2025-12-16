# Compare All Elements from Two Vectors and Flag Inconsistencies

Compares elements of two vectors element-wise, flagging any
inconsistency with a symbol denoted with sep_symbol.

## Usage

``` r
compare_vectors(vec1, vec2, beg_symbol = "", sep_symbol = "/")
```

## Arguments

- vec1:

  First vector (same length as vec2).

- vec2:

  Second vector (same length as vec1).

- beg_symbol:

  (Optional) text string appearing before vec1's entry for inconsistent
  elements.

- sep_symbol:

  Text string separating both vectors' values for inconsistent elements.

## Value

A character vector summarizing any inconsistencies between vectors.

## Note

This function compares two vectors and returns a vector of compared
entries. If you have a more full data set with two coders' entries
across several variables, please use gcgenie::compare_raters().

## Examples

``` r
# With character inputs
char_1 <- c("yes", "yes", "no", "yes", "no")
char_2 <- c("no", "yes", "no", "no", "yes")
compare_vectors(char_1, char_2)
#> [1] "yes/no" "yes"    "no"     "yes/no" "no/yes"

# With numeric inputs
num_1 <- 1:5
num_2 <- 5:9
compare_vectors(num_1, num_2, sep_symbol = ";")
#> [1] "1;5" "2;6" "3;7" "4;8" "5;9"

# In tidy context
# Suppose
df <- data.frame(
    rater_1 = char_1,
    rater_2 = char_2
)

df |>
    dplyr::mutate(compare_col = compare_vectors(rater_1, rater_2))
#>   rater_1 rater_2 compare_col
#> 1     yes      no      yes/no
#> 2     yes     yes         yes
#> 3      no      no          no
#> 4     yes      no      yes/no
#> 5      no     yes      no/yes
# With numeric inputs
compare_vectors(1:3, 3:5)
#> [1] "1/3" "2/4" "3/5"
```
