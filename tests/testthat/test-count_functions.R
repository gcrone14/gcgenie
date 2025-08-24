df <- data.frame(x = c(1:5, 2, 1, 4))
df_char <- tibble::tibble(var = c("Jane,Joe", "Joe", "Joe,Kai", "Kai"))
df_num <- tibble::tibble(var = c("1,3", "2", "2,3", "1"))
df_log <- tibble::tibble(var = c("TRUE", "TRUE", "FALSE,TRUE", "FALSE,FALSE"))

# freq_count ----
test_that("freq_count counts values with perc row", {
    expect_equal(
        freq_count(df, x),
        data.frame(
            x = c(1, 2, 4, 3, 5),
            n = c(2, 2, 2, 1, 1),
            perc_n = 100*c(1/4, 1/4, 1/4, 1/8, 1/8)
        )
    )
})

test_that("freq_count outputs proper error message", {
    expect_error(freq_count(c(1:5)))
})

# unique_count ----
test_that("unique_count separates values properly", {
    # Works with character data sets
    expect_equal(unique_count(df_char, var),
               tibble::tibble(
                   var = c("Joe", "Kai", "Jane"),
                   n = 3:1,
                   perc_n = 100*c(3/sum(3:1), 2/sum(3:1), 1/sum(3:1))
               ))

    # Works with numeric data sets
    expect_equal(unique_count(df_num, var),
                 tibble::tibble(
                     var = c("1", "2", "3"),
                     n = c(2, 2, 2),
                     perc_n = 100*c(2/sum(2,2,2), 2/sum(2,2,2), 2/sum(2,2,2))
                 ))

    # Works with logical data sets
    expect_equal(unique_count(df_log, var),
                 tibble::tibble(
                     var = c("FALSE", "TRUE"),
                     n = c(3, 3),
                     perc_n = 100*c(1/2, 1/2)
                 ))
})

test_that("unique_count outputs proper error message", {
    expect_error(unique_count(c(1:5)))
})

# count_plot ----
test_that("Produces proper error messages", {
    # Improper type of data
    expect_error(1:4 |> count_plot(x))
    expect_error(c("one, two", "two", "one") |> count_plot(x))

    # Not specifying var
    expect_error(freq_count(df, x) |> count_plot())

    # Missing proper count_var column (and not specifying it)
    expect_error(freq_count(df, x) |> select(-n) |> count_plot(x))
})

test_that("Outputs plot under proper specifications", {
    # Regular plot
    expect_s3_class(freq_count(df, x) |> count_plot(x), "ggplot")
    # Specifying column
    expect_s3_class(freq_count(df, x) |> count_plot(x, perc_n), "ggplot")
    # Specifying number of rows to display
    expect_s3_class(freq_count(df, x) |> count_plot(x, head_n = 4), "ggplot")
})
