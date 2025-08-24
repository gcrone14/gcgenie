responses <- data.frame(
q1 = c(NA, "b", "b", "b"),
q2 = c("d", NA, "d", "a"),
q3 = c("c", "d", "c", "a")
)

responses_long <- data.frame(
    response = c(TRUE, TRUE, FALSE, TRUE),
    q1 = c(NA, "b", "b", "b"),
    q2 = c("d", NA, "d", "a"),
    q3 = c("c", "d", "c", "a")
)

answers <- c("b", "d", "c")

# score ----
test_that("score() returns proper error messages", {
    # responses is not a data frame
    expect_error(score(responses$q1, answers))
    # Length of answers < # of columns
    expect_error(score(responses, answers = c("b", "c")))
    # Length of answers > # of columns
    expect_error(score(responses |> dplyr::select(-q3), answers))
})

test_that("score() returns proper outputs", {
    # display = "sum" (default)
    expect_equal(score(responses, answers),
                 c(2, 1, 3, 1))

    # display = "perc"
    expect_equal(score(responses, answers, display = "perc"),
                 round(100/length(answers)*c(2, 1, 3, 1), 2))

    # display = "prop"
    expect_equal(score(responses, answers, display = "prop"),
                 round(c(2, 1, 3, 1)/length(answers), 2))
})


test_that("score(show_questions = TRUE) returns proper outputs", {
    # display = "sum" (default)
    expect_equal(score(responses, answers, show_questions = TRUE),
                 c(3, 2, 2))

    # display = "perc
    expect_equal(score(responses, answers, display = "perc", show_questions = TRUE),
                 round(100/nrow(responses)*c(3, 2, 2), 2))
    # display = "prop"
    expect_equal(score(responses, answers, display = "prop", show_questions = TRUE),
                 round(c(3, 2, 2), 2)/nrow(responses))
})

# score_embed ----
test_that("score_embed() returns proper error messages", {
    # responses is not a data frame
    expect_error(score_embed(responses$q1, answers))
    # Length of answers < # of columns
    expect_error(score_embed(responses, answers = c("b", "c")))
    # Length of answers > # of columns
    expect_error(score_embed(responses |> dplyr::select(-q3), answers))
    # Too many columns (did not select proper columns)
    expect_error(score_embed(responses_long, answers))
})

test_that("score_embed() returns proper output", {
    # display = "sum" (default)
    expect_equal(score_embed(responses, answers),
                 responses |> dplyr::mutate(score = score(responses, answers)))
    # display = "perc"
    expect_equal(score_embed(responses, answers, display = "perc"),
                 responses |> dplyr::mutate(score = score(responses, answers, display = "perc")))
    # display = "prop"
    expect_equal(score_embed(responses, answers, display = "prop"),
                 responses |> dplyr::mutate(score = score(responses, answers, display = "prop")))
    # selecting proper columns with cols
    expect_equal(score_embed(responses_long, answers, cols = q1:q3),
                 responses_long |> dplyr::mutate(score = score(responses, answers)))
})
