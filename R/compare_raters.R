#' Compare Two Raters' Codes Cell-by-Cell
#'
#' @description
#' This function compares two sets of rater codes, provided as two matrices,
#' data frames, or tibbles. It returns a new data object in the same structure,
#' marking any cell-level differences between the two inputs using custom
#' symbols specified via `beg_symbol` and/or `sep_symbol`.
#'
#' @param rater_1 Rater 1's data. Can be a `matrix`, `data.frame`, or `tibble`.
#' @param rater_2 Rater 2's data. Can be a `matrix`, `data.frame`, or `tibble`.
#' @param beg_symbol (Optional) text string appearing before coder 1's code for inconsistent cells.
#' @param sep_symbol Text string separating both coders' codes for inconsistent cells.
#' @param output_class (Optional) text string specifying what to output data as. Can be one of: "matrix", "data.frame", or "tibble". By default, the outputted data will be the same format as `rater_1`.
#'
#'
#' @returns A data frame (if input is a `data.frame`), a tibble (if input is a `tibble`), or a matrix (if input is a `matrix`).
#'
#' @import dplyr
#' @import tibble
#' @import tidyr
#'
#' @export
#'
#' @examples
#' X_dat <- data.frame(var_1 = c(1, 3, 2),
#'                    var_2 = c(2, 2, 2),
#'                    var_3 = c(NA, 1, 1))
#' Y_dat <- data.frame(var_1 = c(1, 3, 2),
#'                    var_2 = c(2, 2, 1),
#'                    var_3 = c(3, 1, 0))
#' compare_raters(X_dat, Y_dat)
#'
#' # Can use different symbols than \ to separate two raters' codes.
#' # Separate different scores with "or":
#' compare_raters(X_dat, Y_dat,
#'                sep_symbol = " or ")
#'
#' # Separate different scores with "Rater 1:" and "Rater 2:"
#' compare_raters(X_dat, Y_dat,
#'                beg_symbol = "Rater 1: ",
#'                sep_symbol = "; Rater 2: ")

compare_raters <- function(rater_1, rater_2, beg_symbol = "", sep_symbol = "/",
                           output_class = NULL)
{
    valid_input <- function(x) {
        is.matrix(x) || is.data.frame(x) || tibble::is_tibble(x)
    }

    # Make sure rater_1 and rater_2 are the appropriate type of data
    if (!valid_input(rater_1) || !valid_input(rater_2)) {
        stop(
            paste(
                "\nBoth inputted objects must be matrices, data frames, or tibbles.",
                "\nRater 1:", ifelse(valid_input(rater_1), "Valid", "Invalid"),
                "\nRater 2:", ifelse(valid_input(rater_2), "Valid", "Invalid")
            )
        )
    }

    # Save rows and columns
    r1_rows <- nrow(rater_1)
    r2_rows <- nrow(rater_2)
    r1_cols <- ncol(rater_1)
    r2_cols <- ncol(rater_2)

    # Replace any NAs in the raters' data frames with "NA" and convert to character matrix
    rater_1_mod <- rater_1 |>
        as.data.frame() |>
        dplyr::mutate_at(colnames(rater_1), ~tidyr::replace_na(as.character(.), "NA"))
    rater_2_mod <- rater_2 |>
        as.data.frame() |>
        dplyr::mutate_at(colnames(rater_2), ~tidyr::replace_na(as.character(.), "NA"))

    rater_1_mat <- rater_1_mod |> as.matrix()
    rater_2_mat <- rater_2_mod |> as.matrix()

    # Create empty object for later storage
    new_df <- matrix(nrow = r1_rows, ncol = r1_cols,
                     dimnames = list(NULL, colnames(rater_1)))

    # Make sure dimensions are equal
    if (r1_rows == r2_rows & r1_cols == r2_cols) {
        new_df <- ifelse(rater_1_mat == rater_2_mat,
                         rater_1_mat,
                         paste0(beg_symbol, rater_1_mat, sep_symbol, rater_2_mat))
        colnames(new_df) <- colnames(rater_1)

        if(is.null(output_class)) {
            if(tibble::is_tibble(rater_1)) new_df |> tibble::as_tibble()
            else if(is.matrix(rater_1)) new_df |> as.matrix()
            else if(is.data.frame(rater_1)) new_df |> as.data.frame()
        }
        else {
            if (output_class == "tibble") {
                tibble::as_tibble(new_df)
            }
            else if (output_class == "data.frame") {
                return(as.data.frame(new_df))
            }
            else if (output_class == "matrix") {
                return(as.matrix(new_df))
            }

        }
    } else {
        stop("Dimensions of data frames are not equal.")
    }
}
