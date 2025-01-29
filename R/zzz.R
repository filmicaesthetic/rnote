# Define a global variable to store the rnote archive path
.rnote_dir <- NULL

.onLoad <- function(libname, pkgname) {
  .rnote_dir <<- tools::R_user_dir("rnote", which = "data")

  if (!dir.exists(.rnote_dir)) {
    success <- dir.create(.rnote_dir, recursive = TRUE, showWarnings = FALSE)

    # If creation fails, set .rnote_dir to NULL to avoid normalizePath errors
    if (!success) {
      warning("Failed to create rnote directory: ", .rnote_dir)
      .rnote_dir <<- NULL
      return()
    }
  }

  .rnote_dir <<- normalizePath(.rnote_dir, winslash = "/")
}
