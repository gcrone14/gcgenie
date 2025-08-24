# Testing compare_raters ----
test_that("compare_raters returns proper error messages", {
  expect_error(compare_raters(1:5, 1:5))
  expect_error(compare_raters(matrix(1:5, 1, 5), 1:5))
  expect_error(compare_raters(1:5, matrix(1:5, 1, 5)))
  expect_no_error(compare_raters(matrix(1:5, 1, 5), matrix(1:5, 1, 5)))
})

test_that("compare_raters works for matrices", {
    # Matrices with a single column or row
    expect_equal(
        compare_raters(matrix(c(1, 2), 2, 1), matrix(c(2, 2), 2, 1)),
        matrix(c("1/2", "2"), 2, 1)
    )

    expect_equal(
        compare_raters(matrix(c(1, 2), 1, 2), matrix(c(2, 2), 1, 2)),
        matrix(c("1/2", "2"), 1, 2)
    )

    # Regular Matrices of n x m (n ≥ 2; m ≥ 2)
    expect_equal(
        compare_raters(matrix(c(1, 2, 3, 5, 5, 6), 2, 3), matrix(1:6, 2, 3)),
        matrix(c("1", "2", "3", "5/4", "5", "6"), 2, 3)
    )

    expect_equal(
        compare_raters(matrix(1:6, 2, 3), matrix(c(1, 2, 3, 5, 5, 6), 2, 3)),
        matrix(c("1", "2", "3", "4/5", "5", "6"), 2, 3)
    )
})

test_that("compare_raters works for data frames", {
    expect_equal(
        compare_raters(data.frame(x = 1:3, y = 4:6), data.frame(x = 1:3, y = c(3, 5, 6))),
        data.frame(x = as.character(1:3), y = c("4/3", "5", "6"))
    )
})

test_that("compare_raters works for tibbles", {
    expect_equal(
        compare_raters(tibble::tibble(x = 1:3, y = 4:6), tibble::tibble(x = 1:3, y = c(3, 5, 6))),
        tibble::tibble(x = as.character(1:3), y = c("4/3", "5", "6"))
    )

    expect_equal(
        compare_raters(tibble::tibble(x = 1:3, y = c(3, 5, 6)), tibble::tibble(x = 1:3, 4:6)),
        tibble::tibble(x = as.character(1:3), y = c("3/4", "5", "6"))
    )
})

test_that("compare_raters beg_symbol and sep_symbol arguments work", {
    expect_equal(compare_raters(data.frame(x = 1:3, y = 4:6),
                                data.frame(x = 1:3, y = c(4:5, 5)),
                                sep_symbol = ";"),
                 data.frame(x = as.character(1:3), y = as.character(c(4, 5, "6;5"))))
    expect_equal(compare_raters(data.frame(x = 1:3, y = 4:6),
                                data.frame(x = 1:3, y = c(4:5, 5)),
                                beg_symbol = "Rater 1:", sep_symbol = "; Rater 2:"),
                 data.frame(x = as.character(1:3), y = as.character(c(4, 5, "Rater 1:6; Rater 2:5"))))
})

# Testing compare_vectors ----
test_that("compare_vectors returns proper error messages", {
    # Inappropriate type of data
    expect_no_error(compare_vectors(1:5, 1:5))
    expect_error(compare_vectors(matrix(1:5, 1, 5), 1:5))
    expect_error(compare_vectors(1:5, data.frame(x = 1:5, y = 1:5)))
    expect_error(xcompare_raters(matrix(1:5, 1, 5), tibble::tibble(x = 1:5, y = 1:5)))

    # Length of vectors is not equal
    expect_error(compare_vectors(1:5, 1:4))
})

test_that("compare_vectors works properly on vectors", {
    # Numeric vectors
    expect_equal(compare_vectors(1:5, 1:5), 1:5)
    expect_equal(compare_vectors(1:5, c(1:4, 4)), c(as.character(1:4), "5/4"))
    expect_equal(compare_vectors(c(1:4, 4), 1:5), c(as.character(1:4), "4/5"))

    # Logical vectors
    expect_equal(compare_vectors(rep(TRUE, 5), rep(TRUE, 5)), rep(TRUE, 5))
    expect_equal(compare_vectors(c(rep(TRUE, 4), FALSE), rep(TRUE, 5)), as.character(c(rep(TRUE, 4), "FALSE/TRUE")))
    expect_equal(compare_vectors(rep(TRUE, 5), c(rep(TRUE, 4), FALSE)), as.character(c(rep(TRUE, 4), "TRUE/FALSE")))

    # Character vectors
    expect_equal(compare_vectors(rep("Yes", 5), rep("Yes", 5)), rep("Yes", 5))
    expect_equal(compare_vectors(rep("Yes", 5), c(rep("Yes", 4), "No")), c(rep("Yes", 4), "Yes/No"))
    expect_equal(compare_vectors(c(rep("Yes", 4), "No"), rep("Yes", 5)), c(rep("Yes", 4), "No/Yes"))
})

test_that("compare_vectors sep_symbol and beg_symbol arguments work", {
    expect_equal(compare_vectors(1:3, c(1:2, 2), sep_symbol = ";"),
                 c(1:2, "3;2"))

    expect_equal(compare_vectors(1:3, c(1:2, 2), beg_symbol = "Rater 1:", sep_symbol = "; Rater 2:"),
                 c(1:2, "Rater 1:3; Rater 2:2"))
})
