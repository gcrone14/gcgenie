#' Efficiently Score Test Data
#'
#' @description
#' Scoring utility function that takes a data frame of responses and a
#' vector of correct answers, returning overall test scores per
#' participant or per question.
#'
#'
#' @param responses Data set (tibble, data.frame, or matrix) with responses: columns are items, rows are respondents.
#' @param answers Vector of correct answers, with the ith element matching the ith column of the response data.
#' @param display (Optional) Character string specifying score display per participant: "sum" (total correct), "prop" (proportion correct), or "perc" (percentage correct).
#' @param show_questions (Optional) Logical. If TRUE, displays scores per question instead of per participant. Helps check if questions are being scored correctly.
#'
#' @returns A numeric vector.
#' @export
#'
#' @note
#' If a participant does not answer a question (i.e., has `NA` in a given cell),
#' the function assumes the question was answered incorrectly. This function
#' is stricter than [gcgenie::score_embed]
#'
#'
#' @examples
#' responses <- data.frame(
#' q1 = c(NA, "b", "b", "b"),
#' q2 = c("d", NA, "d", "a"),
#' q3 = c("c", "d", "c", "a")
#' )
#'
#' answers <- c("b", "d", "c")
#'
#' # Display scores per participant
#' responses |> score(answers)
#' responses |> score(answers, display = "prop")
#' responses |> score(answers, display = "perc")
#'
#' # Display scores per question
#' responses |> score(answers, show_questions = TRUE)
#' responses |> score(answers, display = "prop", show_questions = TRUE)
#' responses |> score(answers, display = "perc", show_questions = TRUE)
score <- function(responses, answers, display = "sum", show_questions = FALSE) {
    # Safety behavior to ensure responses and answers are of the correct type
    if (!valid_data(responses)) {
        stop("'responses' is not a matrix, data frame, or tibble.")
    }

    if (!valid_vector(answers)) {
        stop("'answers' is not a vector.")
    }

    # Safety behavior to ensure length of answers it the number of columns
    # in 'responses'.
    if (length(answers) != ncol(responses)) {
        stop("Length of 'answers' must match the number of columns in 'responses'")
    }

    # Modify var such that correct answers are 1 and
    # incorrect answers are 0
    for(question in 1:length(answers)) {
        responses[,question] <- responses[,question] == answers[question]
    }

    # Save scores for each participant
    scores <- rowSums(responses, na.rm = TRUE)

    # Save scores on each question across questions
    questions <- colSums(responses, na.rm = TRUE) |> as.numeric()

    # Questions displays the raw answers for the questions

    # If you do NOT want to show questions (default), display scores
    if(show_questions == FALSE) {
        # If "sum", then print scores as sum
        if(display == "sum") scores
        # If "prop", produce scores as proportion
        else if(display == "prop") round(scores / length(answers), 2)
        # If "perc", produce scores as a percentage
        else if(display == "perc") round(scores / length(answers) * 100, 2)
        # If no valid input, then let user know
        else stop("Invalid display selected. For `display`, please select one of: 'sum', 'prop', or 'perc'.")
    }

    # Otherwise, show questions
    else{
        # Save the responses data.frame, omitting all responses
        # that contain only NAs
        responses_complete <- responses |>
            dplyr::filter(!dplyr::if_all(dplyr::everything(), is.na))

        # Same display options, but for questions
        if(display == "sum") questions
        else if(display == "prop") round(questions / nrow(responses_complete), 2)
        else if(display == "perc") round(questions / nrow(responses_complete) * 100, 2)
        # If no valid input, then let user know
        else stop("Invalid display selected. For `display`, please select one of: 'sum', 'prop', or 'perc'.")
    }
}

#' Embed Scored Data into a Data Set
#'
#' @description
#' Scoring utility function that takes a data frame of responses and a
#' vector of correct answers, embedding the overall test scores as a new
#' column within the inputted data set.
#'
#' @param responses Data set (tibble, data.frame, or matrix) with responses: columns are items, rows are respondents.
#' @param answers Vector of correct answers, with the ith element matching the ith column of the response data.
#' @param cols A specification (e.g., q1:q10, starts_with("q")) indicating which columns contain responses to be scored. By default, all columns are assumed to contain responses to be scored.
#' @param display (Optional) Character string specifying score display per participant: "sum" (total correct), "prop" (proportion correct), or "perc" (percentage correct).
#' @param name (Optional) Character string specifying what to call the new score column.

#' @returns Returns an object of the same class as 'responses': a tibble, data frame, or matrix.
#' @export
#'
#' @import rlang
#'
#' @note
#' If a participant does not answer a question (i.e., has `NA` in a given cell),
#' the function assumes the question was answered incorrectly.
#'
#' @examples
#' responses <- data.frame(
#'     q1 = c(NA, "b", "b", "b"),
#'     q2 = c("d", NA, "d", "a"),
#'     q3 = c("c", "d", "c", "a")
#' )
#'
#' responses_full <- data.frame(
#'     var1 = c(TRUE, FALSE, TRUE, TRUE),
#'     var2 = c(1, 4, 2.2, 6),
#'     q1 = c(NA, "b", "b", "b"),
#'     q2 = c("d", NA, "d", "a"),
#'     q3 = c("c", "d", "c", "a")
#' )
#'
#' answers <- c("b", "d", "c")
#'
#' # Regular score embedding
#' responses |> score_embed(answers)
#' responses |> score_embed(answers, display = "prop")
#' responses |> score_embed(answers, display = "perc")
#'
#' # Score embedding specifying columns to be scored
#' responses_full |> score_embed(answers, cols = q1:q3)
#' responses_full |> score_embed(answers, cols = dplyr::matches("^q"))
#' responses_full |> score_embed(answers, "q1":"q3")
score_embed <- function(responses, answers, cols = dplyr::everything(),
                        display = "sum", name = "score") {

    # Safety behavior to ensure responses and answers are of the correct type
    if (!valid_data(responses)) {
        stop("'responses' is not a matrix, data frame, or tibble.")
    }

    if (!valid_vector(answers)) {
        stop("'answers' is not a vector.")
    }

    # Select columns (if inputted)
    responses_new <- responses |>
        dplyr::select( {{cols}} )

    # Safety behavior to ensure length of answers it the number of columns
    # in 'responses'.
    if (length(answers) < ncol(responses_new)) {
        stop(
            paste(
            "Length of 'answers' is too short for the selected response columns.\n",
            "  Did you forget to specify the correct columns with `cols`?"
        ))
    }


    # Safety behavior to ensure length of answers it the number of columns
    # in 'responses'.
    else if (length(answers) != ncol(responses_new)) {
        stop("Length of 'answers' must match the number of columns in 'responses'.")
    }

    # Modify var such that correct answers are 1 and
    # incorrect answers are 0
    for(question in 1:length(answers)) {
        responses_new[,question] <- responses_new[,question] == answers[question]
    }

    # Save scores for each participant
    scores <- rowSums(responses_new, na.rm = TRUE)

    # Depending on display, embed the scores inside of the responses data frame
    if(display == "sum") responses |> dplyr::mutate(score = scores) |> dplyr::rename({{name}} := "score")
    else if(display == "prop") responses |> dplyr::mutate(score = round(scores / length(answers), 2)) |> dplyr::rename({{name}} := "score")
    else if(display == "perc") responses |> dplyr::mutate(score = round(scores / length(answers) * 100, 2)) |> dplyr::rename({{name}} := "score")
}
