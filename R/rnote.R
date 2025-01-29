
#' Create a new note and save it to the note archive
#'
#' The \code{jotdown} function allows you to store notes with associated topics
#' to a centralised archive and optionally also save them to the current project directory.
#' It creates a unique note ID, appends the note to an existing file (or creates a new one),
#' and saves the updated list of notes.
#'
#' @param note A character string containing the content of the note to be saved.
#' @param topics A character vector of topics associated with the note (defaults to "general").
#'   These topics are used for filtering and organization. The topics are stored as a comma-separated string.
#'
#' @return This function does not return any value. It saves the note to the file system.
#'
#' @details
#' The function saves the note to an RDS file within the central archive directory, using a file
#' name derived from the current project name and topics. It checks if the file exists and appends
#' the note to it. If the file doesn't exist, it creates a new one. Additionally, if the project directory
#' is initialized, the note will also be saved in the project directory for local project-specific note storage.
#'
#' @examples
#' # Example of creating a note with a topic "general"
#' jotdown("This is my note", topics = "general")
#'
#' # Example of creating a note with multiple topics
#' jotdown("This is another note", topics = c("bug", "urgent"))
#'
#' @importFrom stats runif
#' @export
jotdown <- function(note, topics = "general") {
  if (is.null(.rnote_dir)) stop("rnote directory is not initialized.")

  # get current project name
  proj_name <- gsub(".*\\/", "", getwd())

  # Create a file name
  file_name <- paste0(proj_name, "_", paste(topics, collapse = "_"), ".rds")
  file_path <- paste(.rnote_dir, file_name, sep = "/")

  # Check if file exists and load existing data if it does
  if (file.exists(file_path)) {
    note_data <- readRDS(file_path)
  } else {
    note_data <- list()  # Start with an empty list if no file exists
  }

  # Add new note
  note_data[[length(note_data) + 1]] <- list(
    note_id = paste0(gsub("[^0-9]", "", Sys.time()), round(runif(1, 10000, 99999))),
    timestamp = Sys.time(),
    project = proj_name,
    topics = paste(topics, collapse = ','),
    note = note
  )

  # Save the updated file
  saveRDS(note_data, file_path)

  # Save to project directory if initialised
  if(dir.exists(file.path(getwd(), "rnotes"))) {
    saveRDS(note_data, paste(file.path(getwd(), "rnotes"), file_name, sep = "/"))
  }
}

#' Print the most recent notes in a formatted, readable style
#'
#' This function prints the most recent notes to the console
#' including the note, date, project of origin and related topics
#'
#' @param topic The topic to filter notes by, default is "all", resulting in no filter.
#' @param current_project If TRUE, only notes from the current project will be returned.
#' @param n The number of most recent notes to print. Defaults to 10.
#' @importFrom crayon green blue yellow magenta cyan
#' @importFrom utils head
#' @export
checknotes <- function(topic = "all", current_project = FALSE, n = 10) {

  files <- list.files(.rnote_dir, full.names = TRUE, pattern = "\\.rds$")

  # Filter by project name if specified
  if (current_project == T) {
    # get current project name
    proj_name <- gsub(".*\\/", "", getwd())

    files <- files[grepl(proj_name, files)]
  }

  # Filter by topic if specified
  if (topic != "all") {
    files <- files[grepl(topic, files)]
  }

  notes <- lapply(files, readRDS)
  notes <- unlist(notes, recursive = FALSE)

  # Sort notes by timestamp in descending order
  note_indices <- order(sapply(notes, function(x) x$timestamp), decreasing = TRUE)

  # Subset the top 'n' most recent notes
  notes_sorted <- notes[note_indices]
  notes_to_print <- head(notes_sorted, n)

  # Loop through the selected notes and print them
  cat(blue("Your recent notes", "\n\n"))
  for (note in notes_to_print) {
    cat(green(note$project), "|", cyan(as.Date(note$timestamp)), "\n")
    cat(yellow(paste0("#", note$topics)), "\n\n")
    # cat(magenta("Topics:"), paste(note$topics, collapse = ", "), "\n")
    cat(note$note, "\n")
    cat("\n")  # Add a blank line between notes
  }

}

#' Initialize Project Notes Directory
#'
#' Creates a local `rnotes/` directory in the current project, allowing notes
#' to be stored and accessed within the project folder. This function is
#' useful for collaborative work, where team members can share notes related
#' to a specific project.
#'
#' If the directory already exists, the function does nothing and informs
#' the user.
#'
#' @return A message indicating whether the project notes directory was created
#' or if it already exists.
#' @export
#'
#' @examples
#' \dontrun{
#' init_project_notes()  # Initializes the project notes directory
#' }
init_project_notes <- function() {
  project_dir <- file.path(getwd(), "rnotes")

  if (!dir.exists(project_dir)) {
    dir.create(project_dir, recursive = TRUE)
    message("Project notes initialized! Notes will now be stored in ", project_dir)
  } else {
    message("Project notes already initialized.")
  }
}
