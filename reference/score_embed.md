# Embed Scored Data into a Data Set

Scoring utility function that takes a data frame of responses and a
vector of correct answers, embedding the overall test scores as a new
column within the inputted data set.

## Usage

``` r
score_embed(
  responses,
  answers,
  cols = dplyr::everything(),
  display = "sum",
  name = "score"
)
```

## Arguments

- responses:

  Data set (tibble, data.frame, or matrix) with responses: columns are
  items, rows are respondents.

- answers:

  Vector of correct answers, with the ith element matching the ith
  column of the response data.

- cols:

  A specification (e.g., q1:q10, starts_with("q")) indicating which
  columns contain responses to be scored. By default, all columns are
  assumed to contain responses to be scored.

- display:

  (Optional) Character string specifying score display per participant:
  "sum" (total correct), "prop" (proportion correct), or "perc"
  (percentage correct).

- name:

  (Optional) Character string specifying what to call the new score
  column.

## Value

Returns an object of the same class as 'responses': a tibble, data
frame, or matrix.

## Note

If a participant does not answer a question (i.e., has `NA` in a given
cell), the function assumes the question was answered incorrectly.

## Examples

``` r
responses <- data.frame(
    q1 = c(NA, "b", "b", "b"),
    q2 = c("d", NA, "d", "a"),
    q3 = c("c", "d", "c", "a")
)

responses_full <- data.frame(
    var1 = c(TRUE, FALSE, TRUE, TRUE),
    var2 = c(1, 4, 2.2, 6),
    q1 = c(NA, "b", "b", "b"),
    q2 = c("d", NA, "d", "a"),
    q3 = c("c", "d", "c", "a")
)

answers <- c("b", "d", "c")

# Regular score embedding
responses |> score_embed(answers)
#>     q1   q2 q3 score
#> 1 <NA>    d  c     2
#> 2    b <NA>  d     1
#> 3    b    d  c     3
#> 4    b    a  a     1
responses |> score_embed(answers, display = "prop")
#>     q1   q2 q3 score
#> 1 <NA>    d  c  0.67
#> 2    b <NA>  d  0.33
#> 3    b    d  c  1.00
#> 4    b    a  a  0.33
responses |> score_embed(answers, display = "perc")
#>     q1   q2 q3  score
#> 1 <NA>    d  c  66.67
#> 2    b <NA>  d  33.33
#> 3    b    d  c 100.00
#> 4    b    a  a  33.33

# Score embedding specifying columns to be scored
responses_full |> score_embed(answers, cols = q1:q3)
#>    var1 var2   q1   q2 q3 score
#> 1  TRUE  1.0 <NA>    d  c     2
#> 2 FALSE  4.0    b <NA>  d     1
#> 3  TRUE  2.2    b    d  c     3
#> 4  TRUE  6.0    b    a  a     1
responses_full |> score_embed(answers, cols = dplyr::matches("^q"))
#>    var1 var2   q1   q2 q3 score
#> 1  TRUE  1.0 <NA>    d  c     2
#> 2 FALSE  4.0    b <NA>  d     1
#> 3  TRUE  2.2    b    d  c     3
#> 4  TRUE  6.0    b    a  a     1
responses_full |> score_embed(answers, "q1":"q3")
#>    var1 var2   q1   q2 q3 score
#> 1  TRUE  1.0 <NA>    d  c     2
#> 2 FALSE  4.0    b <NA>  d     1
#> 3  TRUE  2.2    b    d  c     3
#> 4  TRUE  6.0    b    a  a     1
```
