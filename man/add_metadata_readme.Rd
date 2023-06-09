% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_metadata_readme.R
\name{add_metadata_readme}
\alias{add_metadata_readme}
\title{Add metadata details to the README file}
\usage{
add_metadata_readme(meta)
}
\arguments{
\item{meta}{\code{data.frame} generated by one of the \emph{get_} functions containing metadata info.
You can also pass you own data frame, provided it contain all necessary collumns (see details).}
}
\value{
the edited README file
}
\description{
A short description...
}
\details{
If you pass your own data frame, it should contain only one line and the following collumns:
\itemize{
\item description: the description of the dataset
\item reponame: the name of the repository where the dataset was downloaded
\item doi: the DOI
\item date: when the dataset was published
\item authors: the author(s) of the dataset
\item license: the license of the dataset
}
}
\examples{
\dontrun{
add_metadata_readme(meta = metadata_obj)
}
}
