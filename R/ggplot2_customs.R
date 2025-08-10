#' Visually Appealing Custom ggplot2 Theme
#' @description
#' Customized, clean theme for any ggplot2 graph.
#'
#' @returns A customized ggplot2 graph.
#' @export
#'
#' @examples
#' sample_dat <- data.frame(x = c(rnorm(5000, mean = 10, sd = 1),
#'                                rnorm(5000, mean = 6, sd = 1)),
#'                          y = rnorm(10000, mean = 7, sd = 1),
#'                          grp = c(rep("Experimental", 5000),
#'                                  rep("Control", 5000)))
#'
#' # Histogram example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     ggplot2::geom_histogram(binwidth = 1, fill = "royalblue", color = "black", boundary = 1) +
#'     ggplot2::labs(title = "Histogram of x") +
#'     theme_custom()
#'
#' # Box plot example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     ggplot2::geom_boxplot() +
#'     ggplot2::labs(title = "Box Plot of x") +
#'     ggplot2::scale_y_discrete(name = NULL) +
#'     ggplot2::xlim(0, 15) +
#'     ggplot2::coord_flip() +
#'     theme_custom()
#'
#' # Scatterplot example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x, y)) +
#'     ggplot2::geom_point() +
#'     ggplot2::labs(title = "Scatterplot of x and y") +
#'     theme_custom()
#'
#' # Sample plot with faceting and legend
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x, fill = grp)) +
#'     ggplot2::geom_boxplot() +
#'     ggplot2::scale_y_discrete(name = NULL) +
#'     ggplot2::labs(title = "Box Plot of x") +
#'     ggplot2::coord_flip() +
#'     ggplot2::facet_wrap(~grp) +
#'     ggplot2::xlim(0, 15) +
#'     theme_custom()
theme_custom <- function() {
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text  = ggplot2::element_text(size = ggplot2::rel(0.8)),
                   axis.title = ggplot2::element_text(size = ggplot2::rel(1.2)),
                   plot.title = ggplot2::element_text(hjust = 0.5, size = 14),
                   panel.grid = ggplot2::element_blank(),
                   text = ggplot2::element_text(family = "sans", size = 11),
                   strip.background = ggplot2::element_rect(fill = "grey90", color = NA),
                   strip.text = ggplot2::element_text(size = ggplot2::rel(1)),
                   legend.title = ggplot2::element_text(size = ggplot2::rel(1)),
                   legend.text  = ggplot2::element_text(size = ggplot2::rel(0.9)),
                   legend.key   = ggplot2::element_blank(),
                   legend.position = "bottom"
                   )
}

#' Visually Appealing Custom ggplot2 Dark Theme
#'
#' @description
#' Customized, clean dark theme for any ggplot2 graph.
#' @returns A customized ggplot2 graph.
#' @export
#'
#' @note
#' For dark themes, we recommend setting `color = "white"` in your geom or
#' stat calls to ensure better visibility.
#'
#' @examples
#' sample_dat <- data.frame(x = c(rnorm(5000, mean = 10, sd = 1),
#'                                rnorm(5000, mean = 6, sd = 1)),
#'                          y = rnorm(10000, mean = 7, sd = 1),
#'                          grp = c(rep("Experimental", 5000),
#'                                  rep("Control", 5000)))
#'
#' # Histogram example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     ggplot2::geom_histogram(binwidth = 1, fill = "royalblue", color = "white", boundary = 1) +
#'     ggplot2::labs(title = "Histogram of x") +
#'     theme_custom_dark()
#'
#' # Box plot example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x)) +
#'     ggplot2::geom_boxplot(outlier.color = "white") +
#'     ggplot2::labs(title = "Box Plot of x") +
#'     ggplot2::scale_y_discrete(name = NULL) +
#'     ggplot2::xlim(0, 15) +
#'     ggplot2::coord_flip() +
#'     theme_custom_dark()
#'
#' # Scatterplot example
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x, y)) +
#'     ggplot2::geom_point(color = "white") +
#'     ggplot2::labs(title = "Scatterplot of x and y") +
#'     theme_custom_dark()
#'
#' # Sample plot with faceting and legend
#' sample_dat |>
#'     ggplot2::ggplot(ggplot2::aes(x, fill = grp)) +
#'     ggplot2::geom_boxplot(outlier.color = "white", color = "white") +
#'     ggplot2::scale_y_discrete(name = NULL) +
#'     ggplot2::labs(title = "Box Plot of x") +
#'     ggplot2::coord_flip() +
#'     ggplot2::facet_wrap(~grp) +
#'     ggplot2::xlim(0, 15) +
#'     theme_custom_dark()
theme_custom_dark <- function() {
    ggplot2::theme_dark() +
    ggplot2::theme(
        axis.text         = ggplot2::element_text(size = ggplot2::rel(0.8), colour = "white"),
        axis.title        = ggplot2::element_text(size = ggplot2::rel(1.2), colour = "white"),
        axis.ticks        = ggplot2::element_line(colour = "white"),
        plot.title        = ggplot2::element_text(hjust = 0.5, size = 14, colour = "white"),
        panel.background  = ggplot2::element_rect(fill = "#222222", colour = NA),
        plot.background   = ggplot2::element_rect(fill = "#222222", colour = NA),
        panel.border      = ggplot2::element_rect(colour = "white", fill = NA, size = 0.5),
        panel.grid        = ggplot2::element_blank(),
        text              = ggplot2::element_text(family = "sans", size = 11, colour = "white"),
        strip.background  = ggplot2::element_rect(fill = "#444444", colour = NA),
        strip.text        = ggplot2::element_text(size = ggplot2::rel(1), colour = "white"),
        legend.background = ggplot2::element_rect(fill = "#222222", colour = NA),
        legend.title      = ggplot2::element_text(size = ggplot2::rel(1), colour = "white"),
        legend.text       = ggplot2::element_text(size = ggplot2::rel(0.9), colour = "white"),
        legend.key        = ggplot2::element_rect(fill = "#222222", colour = NA),
        legend.position   = "bottom"
        )
}



