
dir.create("inst")
dir.create("inst/extdata")

#' Make a note to yourself that you can recall later in the console from any project.
#' @importFrom utils read.csv
#' @importFrom utils write.csv
#' @importFrom utils stack
#' @importFrom stats setNames
#' @param note text content to be stored as a note
#' @param topics tag(s) added to the note for filtering with checknotes()
#' @export
jotdown <- function(note, topics = "general") {
  if (file.exists(paste0(.libPaths()[1], "/rnote/extdata/notepad.csv")) == FALSE) {
    pad_st <- data.frame(note_id = c(0),
                          date = c(as.character(as.Date(Sys.Date()))),
                          project = c("test"),
                          topics = c("welcome"),
                          note = c("Welcome to rnote"))
  } else {
    # import existing notes
    pad_st <- read.csv(paste0(.libPaths()[1],"/rnote/extdata/notepad.csv"))
  }

  orig_dir <- getwd()
  proj_name <- gsub(".*\\/", "", getwd())
  setwd(paste0(.libPaths()[1], "/rnote"))

  # create new note
  newnote <- data.frame(note_id = c(nrow(pad_st)),
                        date = c(as.character(Sys.Date())),
                        project = c(proj_name),
                        topics = c(paste(topics, collapse = ',')),
                        note = c(note))
  # append new note
  pad_f <- rbind(pad_st, newnote)

  # save updated notepad
  write.csv(pad_f, "extdata/notepad.csv", row.names = F)

  #copy notepad
  pad_a <- pad_f

  # split topics to individual rows
  t1 <- data.frame(stack(setNames(strsplit(pad_a$topics, ","), pad_a$note_id)))
  # rename columns
  colnames(t1) <- c("topics", "note_id")
  # remove original topics column
  pad_a$topics <- NULL
  # merge to create long df
  note_arc <- merge(pad_a, t1, by = "note_id")

  #save notepad archive
  write.csv(note_arc, "extdata/notepad_archive.csv", row.names = F)

  setwd(orig_dir)
}

#' Recall notes you've made with jotdown() By default, only notes from the current project will be recalled, to recall all notes, set current_project = FALSE
#' @param topic specify a topic to return just notes containing that tag, returns all by default
#' @param current_project specify whether you want to return notes from just this project, FALSE by default
#' @param n maximum number of notes to display
#' @export
checknotes <- function(topic = "all", current_project = FALSE, n = 10) {
  orig_dir <- getwd()
  proj_name <- gsub(".*\\/", "", getwd())
  setwd(paste0(.libPaths()[1], "/rnote"))

  if (file.exists("extdata/notepad_archive.csv") == FALSE) {
    print("No notes found")
  } else {

    # import notepad archive
    n_all <- read.csv("extdata/notepad_archive.csv")

    n_sel <- n_all

    # filter if topic provided
    if (topic != "all") {
      n_sel <- n_sel[n_sel$topics == topic,]
    }
    # filter if project provided
    if (current_project == TRUE) {
      n_sel <- n_sel[n_sel$project == proj_name,]
    }
    # arrange by newest first
    n_srt <- n_sel[order(-n_sel[,"note_id"]), , drop = FALSE]
    # select relevant columns
    n_col <- n_srt[, c('date', 'note', 'project')]
    # remove duplicates
    n_uni <- unique(n_col)
    # get top notes
    max_n <- ifelse(nrow(n_uni) < 10, nrow(n_uni), 10)
    # number of top notes
    n_top <- n_uni[1:max_n,c('date', 'project', 'note')]

    proj_text <- if (current_project == TRUE) {
      " in this project"
    } else {
      ""
    }

    topic_text <- if (topic == "all") {
      ""
    } else {
      paste0(" under the topic ", topic)
    }

    if (is.na(n_top$date[1])) {
      print(paste0("No notes found",proj_text, topic_text, ".'"))
    } else {
      writeLines(paste(paste(n_top$project, n_top$date, sep = " | "), n_top$note, sep = "\n"))
    }

  }

  setwd(orig_dir)
}

#' Back up your notes to a new location
#' @param file location to save new file
#' @param current_project specify whether to save all notes, or just notes from the current project
#' @export
backup.notes <- function(file = "rnote_notes.csv", current_project = FALSE) {
  if (file.exists(paste0(.libPaths()[1], "/rnote/extdata/notepad.csv")) == FALSE) {
    print("No notes found")
  } else {
    # import existing notes
    note_st <- read.csv(paste0(.libPaths()[1],"/rnote/extdata/notepad.csv"))

    proj_name <- gsub(".*\\/", "", getwd())

    if (current_project == TRUE) {
      note_st <- note_st[note_st$project == proj_name,]
    }

    write.csv(note_st, file, row.names = FALSE)
  }
}
