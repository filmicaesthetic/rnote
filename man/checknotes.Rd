% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rnote.R
\name{checknotes}
\alias{checknotes}
\title{Print the most recent notes in a formatted, readable style}
\usage{
checknotes(current_project = FALSE, n = 10, topic = "all")
}
\arguments{
\item{current_project}{If TRUE, only notes from the current project will be returned.}

\item{n}{The number of most recent notes to print. Defaults to 10.}

\item{topic}{The topic to filter notes by, default is "all", resulting in no filter.}
}
\description{
This function prints the most recent notes to the console
including the note, date, project of origin and related topics
}
