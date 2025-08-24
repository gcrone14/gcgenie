
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

## Example 1: Comparing Raters

The core functions of **gcgenie** let you compare the coding decisions of 
two raters, either across entire datasets (with `compare_raters()`) 
or element-by-element (with `compare_vectors()`).

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

## Example 2: Scoring
gcgenie also makes it easy to score test or survey responses against an answer key.

```r
library(gcgenie)

# Example responses from 4 participants on 3 questions
responses <- data.frame(
  q1 = c(NA, "b", "b", "b"),
  q2 = c("d", NA, "d", "a"),
  q3 = c("c", "d", "c", "a")
)

# Correct answers
answers <- c("b", "d", "c")

# ---- Overall scores per participant ----
# Default: number correct (sum)
score(responses, answers)
# [1] 0 1 3 1

# Proportion correct
score(responses, answers, display = "prop")
# [1] 0.00 0.33 1.00 0.33

# Percentage correct
score(responses, answers, display = "perc")
# [1]  0 33 100 33

# ---- Scores per question ----
# Useful for checking item difficulty
score(responses, answers, show_questions = TRUE)
# [1] 2 2 2

score(responses, answers, display = "prop", show_questions = TRUE)
# [1] 0.50 0.50 0.50

# ---- Embed scores back into dataset ----
# Adds a new column with participants' scores
score_embed(responses, answers)
#   q1   q2 q3 score
# 1 <NA> d   c     0
# 2 b   <NA> d     1
# 3 b    d   c     3
# 4 b    a   a     1

# Store proportion correct instead of raw counts
score_embed(responses, answers, display = "prop", name = "prop_score")
#   q1   q2 q3 prop_score
# 1 <NA> d   c       0.00
# 2 b   <NA> d       0.33
# 3 b    d   c       1.00
# 4 b    a   a       0.33
```
