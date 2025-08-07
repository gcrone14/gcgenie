#' Convenience wrapper to `dplyr::count()`
#'
#' @description
#' Like dplyr::count(), but always sorts descending and adds a perc_n column with percentage of total counts.
#'
#' @param dat Data set as a matrix, data frame, or tibble.
#' @param ... Additional arguments to add to dplyr::count, such as the variables to count.
#' @param sort (optional) when set to TRUE, sorts the output
#' so that higher-frequency items appear above less frequent ones.
#' Defaults to TRUE.
#'
#' @import dplyr
#' @import rlang
#'
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
    if(!valid_data(dat)) stop("Data is not a matrix, data frame, or tibble.")

    dat |>
        dplyr::count(..., sort = sort) |>
        dplyr::mutate(perc_n = n/sum(n)*100)
}

#' Count Unique Values Across Delimited Entries
#'
#' @description
#' Generates a frequency table for a categorical variable containing delimiter-separated values by counting each unique element.
#'
#' @param dat Data set (tibble, data.frame, or matrix).
#' @param var The name of the variable (column) to analyze, unquoted
#' @param delim A string indicating the delimiter used to separate values within a cell.
#' @param ... Additional arguments passed to [gcgenie::freq_count()].
#'
#' @returns Returns an object of the same class as dat: a tibble, data frame, or matrix.
#' @export
#'
#' @examples
#' df <- tibble::tibble(person = c("Jane,Joe", "Joe", "Joe,Kai", "Kai"))
#'
#' df |> unique_count(person)
#'
unique_count <- function(dat, var, delim = ",", ...) {
    if(!valid_data(dat)) stop("Data is not a matrix, data frame, or tibble.")
    dat |>
        tidyr::separate_longer_delim({{var}}, delim) |>
        freq_count({{var}}, ...)
}

#' Generate a Count Plot from a Count Table
#'
#' @description
#' Generates a column plot from a frequency table,
#' with categories sorted by descending frequency.
#'
#' @param dat Frequency table (tibble, data.frame, or matrix) that includes a categorical (counted or grouped) and a corresponding count column (usually, 'n').
#' @param var The categorical variable in the frequency table, unquoted.
#' @param count_var The count of the variable, usually 'n', unqouted. By default, it is assumed to be 'n'.
#' @param head_n The number of final unique values to include in the plot.
#' @param label (Optional) If TRUE, will provide text of the frequnecy count to the right of each bar.
#' @param hjust (Optional) Horizontal offset for x-axis labels; effective only when label = TRUE.
#'
#' @returns A ggplot2 column plot of frequencies.
#'
#' @import utils
#' @export
#'
#' @examples
#'
#' df <- data.frame(person = c("Jane,Joe", "Joe", "Joe,Kai", "Kai"))
#'
#' # Regular count plot without labels
#' df |> unique_count(person) |> count_plot(person)
#' # With labels
#' df |> unique_count(person) |> count_plot(person, label = TRUE, hjust = 2)

count_plot <- function(dat, var = NULL, count_var = n, head_n = nrow(dat), label = FALSE, hjust = -0.1) {
    # Convert "var", "count_var", and "hjust" to symbols
    var <- rlang::enquo(var)
    count_var <- rlang::enquo(count_var)

    if(!valid_data(dat)) {
        stop("Data is not a matrix, data frame, or tibble.")
    }

    if (rlang::quo_is_null(var)) {
        stop("var is missing. Please specify the variable to create the count plot for.")
    }

    p <- dat |>
    dplyr::mutate(
        !!var := forcats::fct_reorder(!!var, !!count_var)
    ) |>
    dplyr::filter(!is.na(!!var), !!var != "") |>
    head(head_n) |>
    ggplot2::ggplot(ggplot2::aes(x = !!var, y = !!count_var)) +
    ggplot2::geom_col(color = "black", fill = "royalblue") +
    ggplot2::coord_flip()

    # Add labels if requested
    if (label) {
        max_y <- max(rlang::eval_tidy(count_var, data = dat))

        p + ggplot2::geom_text(ggplot2::aes(label = !!count_var), hjust = -hjust) +
            ggplot2::ylim(0, max_y + 1/2*hjust)
    }
    else p
}


