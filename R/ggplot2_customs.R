#' Custom ggplot2 histogram
#'
#' @description
#' ggplot2::goem_histogram() with useful defaults (e.g., black color,
#' royal blue fill, and useful boundary conditions.)
#'
#' @param color (Optional) Color of the outline of each bar.
#' @param fill (Optional) Color of the bars themselves.
#' @param ... Arguments passed to ggplot2::geom_histogram().
#'
#' @returns A histogram plot.
#' @export
#'
#' @examples
#' sample_dat <- data.frame(x = rnorm(10000, mean = 10, 1))
#' # Regular plot
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     geom_histogram_custom(binwidth = 0.5)
#'
#' # Alter color and fill
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     geom_histogram_custom(binwidth = 0.5, color = "grey", fill = "gold")
#'
geom_histogram_custom <- function(..., color = "black", fill = "royalblue") {
  ggplot2::geom_histogram(
    color = color,
    fill = fill,
    boundary = 1,
    ...
  )
}

theme_hist <- function() {

}

# theme_hist <- function() {
#     ggplot2::labs(y = "Frequency", title = paste("Histogram of x")) +
#     ggplot2::theme_bw() +
#     ggplot2::theme(axis.text = ggplot2::element_text(family = "serif", face = "bold", size = 12),
#                    plot.title = ggplot2::element_text(hjust = 0.5, size = 16),
#                    panel.grid = ggplot2::element_blank())
# }
