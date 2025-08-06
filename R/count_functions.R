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
