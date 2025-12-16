# Efficiently Score Test Data

Scoring utility function that takes a data frame of responses and a
vector of correct answers, returning overall test scores per participant
or per question.

## Usage

``` r
score(responses, answers, display = "sum", show_questions = FALSE)
```

## Arguments

- responses:

  Data set (tibble, data.frame, or matrix) with responses: columns are
  items, rows are respondents.

- answers:

  Vector of correct answers, with the ith element matching the ith
  column of the response data.

- display:

  (Optional) Character string specifying score display per participant:
  "sum" (total correct), "prop" (proportion correct), or "perc"
  (percentage correct).

- show_questions:

  (Optional) Logical. If TRUE, displays scores per question instead of
  per participant. Helps check if questions are being scored correctly.

## Value

A numeric vector.

## Note

If a participant does not answer a question (i.e., has `NA` in a given
cell), the function assumes the question was answered incorrectly. This
function is stricter than
[score_embed](https://gcrone14.github.io/gcgenie/reference/score_embed.md)

## Examples

``` r
responses <- data.frame(
q1 = c(NA, "b", "b", "b"),
q2 = c("d", NA, "d", "a"),
q3 = c("c", "d", "c", "a")
)

answers <- c("b", "d", "c")

# Display scores per participant
responses |> score(answers)
#> [1] 2 1 3 1
responses |> score(answers, display = "prop")
#> [1] 0.67 0.33 1.00 0.33
responses |> score(answers, display = "perc")
#> [1]  66.67  33.33 100.00  33.33

# Display scores per question
responses |> score(answers, show_questions = TRUE)
#> [1] 3 2 2
responses |> score(answers, display = "prop", show_questions = TRUE)
#> [1] 0.75 0.50 0.50
responses |> score(answers, display = "perc", show_questions = TRUE)
#> [1] 75 50 50
```
