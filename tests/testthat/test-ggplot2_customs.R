# theme_custom ----
test_that("theme_custom() returns a theme object", {
    expect_s3_class(theme_custom(), "theme")
})

test_that("theme_custom() contains expected modifications", {
    th <- theme_custom()
    expect_equal(th$legend.position, "bottom")
    expect_equal(th$panel.grid, ggplot2::element_blank())
    expect_equal(th$strip.background$fill, "grey90")
})

test_that("theme_custom() can be added to a ggplot without error", {
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt)) +
        ggplot2::geom_point() +
        theme_custom()
    expect_s3_class(p, "ggplot")
})

# theme_custom_dark ----
test_that("theme_custom_dark() returns a theme object", {
    th <- theme_custom_dark()
    expect_s3_class(th, "theme")
})

test_that("theme_custom_dark() contains expected modifications", {
    th <- theme_custom_dark()
    expect_equal(th$legend.position, "bottom")
    expect_equal(th$panel.background$fill, "#222222")
    expect_equal(th$plot.background$fill, "#222222")
    expect_equal(th$strip.background$fill, "#444444")
})

test_that("theme_custom_dark() can be added to a ggplot without error", {
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt)) +
        ggplot2::geom_point() +
        theme_custom_dark()
    expect_s3_class(p, "ggplot")
})
