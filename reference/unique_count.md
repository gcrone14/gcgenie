# Count Unique Values Across Delimited Entries

Generates a frequency table for a categorical variable containing
delimiter-separated values by counting each unique element.

## Usage

``` r
unique_count(dat, var, delim = ",", ...)
```

## Arguments

- dat:

  Data set (tibble, data.frame, or matrix).

- var:

  The name of the variable (column) to analyze, unquoted

- delim:

  A string indicating the delimiter used to separate values within a
  cell.

- ...:

  Additional arguments passed to
  [`freq_count()`](https://gcrone14.github.io/gcgenie/reference/freq_count.md).

## Value

Returns an object of the same class as dat: a tibble, data frame, or
matrix.

## Examples

``` r
df <- tibble::tibble(person = c("Jane,Joe", "Joe", "Joe,Kai", "Kai"))

df |> unique_count(person)
#> # A tibble: 3 × 3
#>   person     n perc_n
#>   <chr>  <int>  <dbl>
#> 1 Joe        3   50  
#> 2 Kai        2   33.3
#> 3 Jane       1   16.7
```
