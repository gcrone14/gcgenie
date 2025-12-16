# Convenience wrapper to `dplyr::count()`

Like dplyr::count(), but always sorts descending and adds a perc_n
column with percentage of total counts.

## Usage

``` r
freq_count(dat, ..., sort = TRUE)
```

## Arguments

- dat:

  Data set as a matrix, data frame, or tibble.

- ...:

  Additional arguments to add to dplyr::count, such as the variables to
  count.

- sort:

  (optional) when set to TRUE, sorts the output so that higher-frequency
  items appear above less frequent ones. Defaults to TRUE.

## Value

Returns an object of the same class as dat: a tibble, data frame, or
matrix.

## Examples

``` r
dat <- data.frame(
    name = c("John", "Jane", "Jim", "Jill", "Joe", "Anna"),
    occupation = c("Academic", "Academic", "Librarian", "Firefighter", "Doctor", "Doctor"),
    native_language = c("En", "En", "Fr", "Fr", "En", "Fr"))

dat |> freq_count(occupation)
#>    occupation n   perc_n
#> 1    Academic 2 33.33333
#> 2      Doctor 2 33.33333
#> 3 Firefighter 1 16.66667
#> 4   Librarian 1 16.66667
dat |> freq_count(native_language)
#>   native_language n perc_n
#> 1              En 3     50
#> 2              Fr 3     50
dat |> freq_count(occupation, native_language)
#>    occupation native_language n   perc_n
#> 1    Academic              En 2 33.33333
#> 2      Doctor              En 1 16.66667
#> 3      Doctor              Fr 1 16.66667
#> 4 Firefighter              Fr 1 16.66667
#> 5   Librarian              Fr 1 16.66667
```
