#' Custom Generic ggplot2 Theme
#' @description
#' Customized, clean theme for any ggplot2 graph.
#'
#' @returns A customized ggplot2 graph.
#' @export
#'
#' @examples
#' sample_dat <- data.frame(x = rnorm(10000, mean = 10, 1))
#' # Altered fill, with custom theme and labels
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     ggplot2::geom_histogram(binwidth = 1, fill = "royalblue", color = "black", boundary = 1) +
#'     theme_custom()
theme_custom <- function() {
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text = ggplot2::element_text(size = 10),
                   axis.title = ggplot2::element_text(size = 12),
                   plot.title = ggplot2::element_text(hjust = 0.5, size = 14),
                   panel.grid = ggplot2::element_blank(),
                   text = ggplot2::element_text(family = "sans", size = 11)
                   )
}
