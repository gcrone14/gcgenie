
# gcgenie

<!-- badges: start -->
<!-- badges: end -->

*gcgenie* provides practical, easy-to-use R functions to streamline data analysis, 
including rater cell comparison, custom ggplot2 themes, and data cleaning 
utilities. Think of it as your personal code genie—no limits on wishes!

Want to learn more about all of the available functions?
Check out the [Reference tab](https://gcrone14.github.io/gcgenie/reference/index.html) for detailed documentation.

## Installation

You can install the development version of *gcgenie* from [GitHub](https://github.com/gcrone14/gcgenie) with:

``` r
# install.packages("pak")
pak::pak("gcrone14/gcgenie")
```

## Examples
### Rater Comparison

*gcgenie* lets you compare the coding decisions of 
two raters with `compare_raters()`. If you want to compare two vectors, you
can do so with `compare_vectors()`.

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

# ---- Compare two vectors ----
vec1 <- c("yes", "yes", "no", "yes", "no")
vec2 <- c("no",  "yes", "no", "no",  "yes")

compare_vectors(vec1, vec2)
# [1] "yes/no" "yes" "no" "yes/no" "no/yes"
```

### Scoring
*gcgenie* also makes it easy to score test or survey responses against an answer key.
Use `score` to score participants on a particular item, and
`score_embed` to insert scores as a new column into an existing data set.


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

### Counting
*gcgenie* contains several useful count functions that make
tasks involving frequency data simpler. Use `freq_count` as a
shortcut to `dplyr::count()` with useful defaults, `unique_count`
to count all unique elements in a column with a delimeter-separated list,
and `count_plot` to create a useful plot of count data.

```r
library(gcgenie)

# ---- Sample dataset ----
dat <- data.frame(
  name = c("John", "Jane", "Jim", "Jill", "Joe", "Anna"),
  occupation = c("Academic", "Academic", "Librarian", "Firefighter", "Doctor", "Doctor"),
  native_language = c("En", "En", "Fr", "Fr", "En", "Fr")
)

# ---- freq_count() ----
# Basic frequency counts
dat |> freq_count(occupation)
#   occupation n perc_n
# 1   Academic 2   33.3
# 2     Doctor 2   33.3
# 3  Librarian 1   16.7
# 4 Firefighter 1   16.7

# Multiple variables
dat |> freq_count(occupation, native_language)
#   occupation native_language n perc_n
# 1   Academic              En 2   33.3
# 2     Doctor              En 1   16.7
# 3     Doctor              Fr 1   16.7
# 4  Librarian              Fr 1   16.7
# 5 Firefighter             Fr 1   16.7


# ---- unique_count() ----
# For delimited entries, e.g. multiple people in a single cell
df <- tibble::tibble(person = c("Jane,Joe", "Joe", "Joe,Kai", "Kai"))

# Count unique individuals
df |> unique_count(person)
#   person n perc_n
# 1    Joe 3   50.0
# 2    Kai 2   33.3
# 3   Jane 1   16.7


# ---- count_plot() ----
# Make a bar plot of frequencies
df |> unique_count(person) |> count_plot(person)

# With labels and adjusted horizontal offset
df |> unique_count(person) |> count_plot(person, label = TRUE, hjust = 2)

```

### ggplot2 Customizations
Lastly, *gcgenie* contains custom themes for visually pleasing ggplot2 graphs.
`custom_theme` is a light custom theme, and 
`custom_theme_dark()` is a dark custom theme.

```r
library(gcgenie)
library(ggplot2)

# ---- Example dataset ----
sample_dat <- data.frame(
  x   = c(rnorm(5000, mean = 10, sd = 1),
          rnorm(5000, mean = 6, sd = 1)),
  y   = rnorm(10000, mean = 7, sd = 1),
  grp = c(rep("Experimental", 5000),
          rep("Control", 5000))
)

# ---- theme_custom() ----
# Histogram
sample_dat |>
  ggplot(aes(x)) +
  geom_histogram(binwidth = 1, fill = "royalblue", color = "black", boundary = 1) +
  labs(title = "Histogram of x") +
  theme_custom()

# Boxplot
sample_dat |>
  ggplot(aes(x)) +
  geom_boxplot() +
  labs(title = "Box Plot of x") +
  scale_y_discrete(name = NULL) +
  xlim(0, 15) +
  coord_flip() +
  theme_custom()

# Scatterplot
sample_dat |>
  ggplot(aes(x, y)) +
  geom_point() +
  labs(title = "Scatterplot of x and y") +
  theme_custom()

# Faceted with legend
sample_dat |>
  ggplot(aes(x, fill = grp)) +
  geom_boxplot() +
  labs(title = "Box Plot of x") +
  scale_y_discrete(name = NULL) +
  xlim(0, 15) +
  coord_flip() +
  facet_wrap(~grp) +
  theme_custom()


# ---- theme_custom_dark() ----
# Histogram
sample_dat |>
  ggplot(aes(x)) +
  geom_histogram(binwidth = 1, fill = "royalblue", color = "white", boundary = 1) +
  labs(title = "Histogram of x") +
  theme_custom_dark()

# Boxplot
sample_dat |>
  ggplot(aes(x)) +
  geom_boxplot(outlier.color = "white") +
  labs(title = "Box Plot of x") +
  scale_y_discrete(name = NULL) +
  xlim(0, 15) +
  coord_flip() +
  theme_custom_dark()

# Scatterplot
sample_dat |>
  ggplot(aes(x, y)) +
  geom_point(color = "white") +
  labs(title = "Scatterplot of x and y") +
  theme_custom_dark()

# Faceted with legend
sample_dat |>
  ggplot(aes(x, fill = grp)) +
  geom_boxplot(outlier.color = "white", color = "white") +
  labs(title = "Box Plot of x") +
  scale_y_discrete(name = NULL) +
  xlim(0, 15) +
  coord_flip() +
  facet_wrap(~grp) +
  theme_custom_dark()
```

