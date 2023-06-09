% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_dwc.R
\name{add_dwc_event}
\alias{add_dwc_event}
\title{Add Darwin Core mapping of events class to Rmarkdown}
\usage{
add_dwc_event(
  markup = "<!--DWC_EVENT-->",
  full = FALSE,
  acode = "dwc",
  object_name = "dataset",
  rmd_file = NULL
)
}
\arguments{
\item{markup}{the identifier which will be replaced by the code chunk containing
the code to perform the mapping (see details).}

\item{full}{\code{logical} indicating if you want all the fields available for the event class
or just the essential ones (when \code{FALSE}).}

\item{acode}{a code to be added to the start of the new column names. This enables easy
tracking of the new fields and easy cleanup at the end of the process.}

\item{object_name}{the name of the object from which the original fields will come.}

\item{rmd_file}{an optional path to an Rmd file to be edited. If \code{NULL}, then the usual
Rmd file of the package is used.}
}
\value{
an edited Rmarkdown
}
\description{
This function enables to easily add a code chunk with the fields which usually needs to be
mapped when describing an events type for OBIS (as well as GBIF).
}
\details{
For this function to work, you need to first add the \strong{\code{markup}} to the
Rmarkdown. The standard one is \code{<!--DWC_EVENT-->} (with no quotation
marks). Then, the function will locate the markup and substitute it for the
formated code chunk. Note that you can use any markup, but this have to be
identifiable within your file.

Note that the \code{full} does not contains all fields available in DwC for this class. Also, the recommended
fields for the class include some other fields that should usually be included, but are not necessary. See
the references for more information. Special attention should be taken when describing events and associated
occurrences as some additional fields may be needed and others omitted in each table.
}
\examples{
\dontrun{
add_dwc_event()
}
}
\seealso{
\itemize{
\item \href{https://ipt.gbif.org/manual/en/ipt/latest/sampling-event-data}{GBIF manual for event data}
\item \href{https://rs.gbif.org/core/dwc_event_2022-02-02.xml}{GBIF repository of DwC schemas}
}
}
