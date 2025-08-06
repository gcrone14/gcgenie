valid_data <- function(x) {
    is.matrix(x) || is.data.frame(x) || tibble::is_tibble(x)
}

valid_vector <- function(x) {
    !valid_data(x)
}
