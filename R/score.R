score <- function(responses, answers, display = "sum", show_questions = FALSE) {
    # Note: Responses must already isolate the vector
    # of only responses to items. Answers must also
    # correspond to the responded-to-items on a 1-to-1
    # basis, i.e., column 1 corresponds to answer 1,
    # column 2 to answer 2, etc...

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
        else "Invalid display selected. For `display`, please select one of: sum, prop, or perc"
    }

    # Otherwise, show questions
    else if (show_questions == TRUE) {

        # Save the responses data.frame, omitting all responses
        # that contain only NAs
        responses_complete <- responses %>%
            filter(!if_all(everything(), is.na))

        # Same display options, but for questions
        if(display == "sum") questions
        else if(display == "prop") round(questions / nrow(responses_complete), 2)
        else if(display == "perc") round(questions / nrow(responses_complete) * 100, 2)
        else "Invalid display selected. For `display`, please select one of: sum, prop, or perc"
    }
}
