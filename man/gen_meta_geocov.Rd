% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gen_metadata.R
\name{gen_meta_geocov}
\alias{gen_meta_geocov}
\title{Generate metadata object for geographical coverage}
\usage{
gen_meta_geocov(
  geographicDescription,
  westBoundingCoordinate = NULL,
  eastBoundingCoordinate = NULL,
  northBoundingCoordinate = NULL,
  southBoundingCoordinate = NULL
)
}
\arguments{
\item{geographicDescription}{description/name of the area of coverage}

\item{westBoundingCoordinate, eastBoundingCoordinate, northBoundingCoordinate, southBoundingCoordinate}{coordinates
of the longitude and latitude limits (numeric)}
}
\value{
a meta_cov object containing the geographical coverage xml
}
\description{
Generate metadata object for geographical coverage
}
\examples{
\dontrun{
gen_meta_geocov("The area of study")
}
}
