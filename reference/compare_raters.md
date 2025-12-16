# Compare Two Raters' Codes Cell-by-Cell

Compares two matrices, data frames, or tibbles of rater codes, returning
the same structure with cell-level differences marked using `beg_symbol`
and `sep_symbol`.

## Usage

``` r
compare_raters(
  rater_1,
  rater_2,
  beg_symbol = "",
  sep_symbol = "/",
  output_class = NULL
)
```

## Arguments

- rater_1:

  Rater 1's data. Can be a `matrix`, `data.frame`, or `tibble`.

- rater_2:

  Rater 2's data. Can be a `matrix`, `data.frame`, or `tibble`.

- beg_symbol:

  (Optional) text string appearing before coder 1's code for
  inconsistent cells.

- sep_symbol:

  Text string separating both coders' codes for inconsistent cells.

- output_class:

  (Optional) text string specifying what to output data as. Can be one
  of: "matrix", "data.frame", or "tibble". By default, the outputted
  data will be the same format as `rater_1`.

## Value

A data frame (if input is a `data.frame`), a tibble (if input is a
`tibble`), or a matrix (if input is a `matrix`).

## Examples

``` r
X_dat <- data.frame(var_1 = c(1, 3, 2),
                   var_2 = c(2, 2, 2),
                   var_3 = c(NA, 1, 1))
Y_dat <- data.frame(var_1 = c(1, 3, 2),
                   var_2 = c(2, 2, 1),
                   var_3 = c(3, 1, 0))
compare_raters(X_dat, Y_dat)
#>   var_1 var_2 var_3
#> 1     1     2  NA/3
#> 2     3     2     1
#> 3     2   2/1   1/0

# Can use different symbols than \ to separate two raters' codes.
# Separate different scores with "or":
compare_raters(X_dat, Y_dat,
               sep_symbol = " or ")
#>   var_1  var_2   var_3
#> 1     1      2 NA or 3
#> 2     3      2       1
#> 3     2 2 or 1  1 or 0

# Separate different scores with "Rater 1:" and "Rater 2:"
compare_raters(X_dat, Y_dat,
               beg_symbol = "Rater 1: ",
               sep_symbol = "; Rater 2: ")
#>   var_1                  var_2                   var_3
#> 1     1                      2 Rater 1: NA; Rater 2: 3
#> 2     3                      2                       1
#> 3     2 Rater 1: 2; Rater 2: 1  Rater 1: 1; Rater 2: 0
```
