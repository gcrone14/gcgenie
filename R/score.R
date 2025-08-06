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
#'
#' @examples
#' responses <- data.frame(
#' q1 = c("a", "b", "b", "b"),
#' q2 = c("d", "a", "d", "d"),
#' q3 = c("c", "c", "c", "a"))
#'
#' answers <- c("b", "d", "c")
#'
#' responses |> score(answers)

score <- function(responses, answers, display = "sum", show_questions = FALSE) {
    # Modify var such that correct answers are 1 and
    # incorrect answers are 0
    for(question in 1:length(answers)) {
        responses[,question] <- responses[,question] == answers[question]
    }

    # Save scores for each participant
    scores <- rowSums(responses, na.rm = TRUE)

    # Save scores on each question across questions
    questions <- colSums(responses, na.rm = TRUE)

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
        else "Invalid display selected. For `display`, please select one of: sum, prop, or perc."
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
        else "Invalid display selected. For `display`, please select one of: sum, prop, or perc."
    }
}
