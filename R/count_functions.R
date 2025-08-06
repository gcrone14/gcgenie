#' Convenience wrapper to `dplyr::count()`
#'
#' @description
#' This function replicates the behavior of dplyr::count(), but with more
#' informative defaults: it always sorts rows in descending order of frequency
#' and includes a perc_n column indicating the percentage each count represents
#' relative to the total.
#'
#' @param dat Data set as a matrix, data frame, or tibble.
#' @param ... Additional arguments to add to dplyr::count, such as the variables to count.
#' @param sort (optional) when set to TRUE, sorts the output
#' so that higher-frequency items appear above less frequent ones.
#' Defaults to TRUE.
#'
#' @import dplyr
#' @returns Returns an object of the same class as dat: a tibble, data frame, or matrix.
#' @export
#'
#' @examples
#' dat <- data.frame(
#'     name = c("John", "Jane", "Jim", "Jill", "Joe", "Anna"),
#'     occupation = c("Academic", "Academic", "Librarian", "Firefighter", "Doctor", "Doctor"),
#'     native_language = c("En", "En", "Fr", "Fr", "En", "Fr"))
#'
#' dat |> freq_count(occupation)
#' dat |> freq_count(native_language)
#' dat |> freq_count(occupation, native_language)
freq_count <- function(dat, ..., sort = TRUE) {
    dat |>
        dplyr::count(..., sort = sort) |>
        dplyr::mutate(perc_n = n/sum(n)*100)
}

#' Title
#'
#' @param dat
#' @param var
#' @param delim
#' @param ...
#'
#' @returns
#' @export
#'
#' @examples
unique_count <- function(dat, var, delim = ",", ...) {
    dat %>%
        tidyr::separate_longer_delim({{var}}, delim) %>%
        freq_count({{var}}, ...)
}


#' Title
#'
#' @param dat
#' @param var
#' @param n
#' @param label
#' @param x_nudge
#' @param ...
#'
#' @returns
#' @export
#'
#' @examples
count_plot <- function(dat, var, n = 30, label = FALSE, x_nudge = NULL, ...) {
    var <- rlang::enquo(var)

    # Define plot
    p <- dat %>%
        mutate(!!var := fct_reorder(!!var, n)) %>%
        filter(!is.na(!!var), !!var != "") %>%
        head(n = n) %>%
        ggplot(aes(x = !!var, y = n)) +
        geom_col(color = "black", fill = "royalblue") +
        coord_flip() +
        labs(y = "Number of retractions", ...)

    # If label = TRUE, add labels
    if(label == TRUE) p + geom_text(aes(label = n), nudge_y = x_nudge)
    else p
}

