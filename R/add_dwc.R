#' Add Darwin Core mapping of events class to Rmarkdown
#'
#' @description
#' This function enables to easily add a code chunk with the fields which usually needs to be
#' mapped when describing an events type for OBIS (as well as GBIF).
#'
#'
#' @param markup the identifier which will be replaced by the code chunk containing
#' the code to perform the mapping (see details).
#' @param full \code{logical} indicating if you want all the fields available for the event class
#' or just the essential ones (when \code{FALSE}).
#' @param acode a code to be added to the start of the new column names. This enables easy
#' tracking of the new fields and easy cleanup at the end of the process.
#' @param object_name the name of the object from which the original fields will come.
#' @param rmd_file an optional path to an Rmd file to be edited. If \code{NULL}, then the usual
#' Rmd file of the package is used.
#'
#' @return an edited Rmarkdown
#' @export
#'
#' @details
#' For this function to work, you need to first add the **`markup`** to the
#' Rmarkdown. The standard one is \code{<!--DWC_EVENT-->} (with no quotation
#' marks). Then, the function will locate the markup and substitute it for the
#' formated code chunk. Note that you can use any markup, but this have to be
#' identifiable within your file.
#'
#' Note that the `full` does not contains all fields available in DwC for this class. Also, the recommended
#' fields for the class include some other fields that should usually be included, but are not necessary. See
#' the references for more information. Special attention should be taken when describing events and associated
#' occurrences as some additional fields may be needed and others omitted in each table.
#'
#' @seealso
#' - \href{https://ipt.gbif.org/manual/en/ipt/latest/sampling-event-data}{GBIF manual for event data}
#' - \href{https://rs.gbif.org/core/dwc_event_2022-02-02.xml}{GBIF repository of DwC schemas}
#'
#'
#' @examples
#' \dontrun{
#' add_dwc_event()
#' }
add_dwc_event <- function(markup = "<!--DWC_EVENT-->", full = FALSE, acode = "dwc",
                          object_name = "dataset",
                          rmd_file = NULL){

  if (is.null(rmd_file)) {
    rmd_file <- "src/obisdi_general.Rmd"
  }

  ol <- readLines(rmd_file)

  if (full) {
    fields <- c("eventID",
                "parentEventID",
                "samplingProtocol",
                "sampleSizeValue",
                "sampleSizeUnit",
                "samplingEffort",
                "eventDate",
                "eventTime",
                "startDayOfYear",
                "endDayOfYear",
                "year",
                "month",
                "day",
                "verbatimEventDate",
                "habitat",
                "fieldNumber",
                "fieldNotes",
                "eventRemarks",
                "locationID",
                "country",
                "countryCode",
                "minimumDepthInMeters",
                "maximumDepthInMeters",
                "locationRemarks",
                "decimalLatitude",
                "decimalLongitude",
                "geodeticDatum",
                "coordinateUncertaintyInMeters",
                "type",
                "bibliographicCitation",
                "institutionID",
                "datasetID"
    )
  } else {
    fields <- c("eventID",
                "eventDate",
                "samplingProtocol",
                "sampleSizeValue",
                "sampleSizeUnit",
                "samplingEffort",
                "locationID",
                "decimalLatitude",
                "decimalLongitude",
                "geodeticDatum",
                "country",
                "countryCode",
                "minimumDepthInMeters",
                "maximumDepthInMeters"
    )
  }

  nl <- paste0(
"```{r}
events <- dataset %>%
\tmutate(", "\n",
paste0("\t\t", acode, "_", fields, " = ", object_name, collapse = ",\n"),
"\n)
```", collapse = "\n"
  )

  ol <- gsub(markup, nl, ol)

  writeLines(ol, rmd_file)

  cli::cli_alert_success("DwC event mapping added to {.file {rmd_file}}.")

  return(invisible(NULL))
}



#' Add Darwin Core mapping of occurrence class to Rmarkdown
#'
#' @description
#' This function enables to easily add a code chunk with the fields which usually needs to be
#' mapped when describing an occurrence type for OBIS (as well as GBIF).
#'
#'
#' @param markup the identifier which will be replaced by the code chunk containing
#' the code to perform the mapping (see details).
#' @param full \code{logical} indicating if you want all the fields available for the event class
#' or just the essential ones (when \code{FALSE}).
#' @param acode a code to be added to the start of the new column names. This enables easy
#' tracking of the new fields and easy cleanup at the end of the process.
#' @param object_name the name of the object from which the original fields will come.
#' @param rmd_file an optional path to an Rmd file to be edited. If \code{NULL}, then the usual
#' Rmd file of the package is used.
#'
#' @return an edited Rmarkdown
#' @export
#'
#' @details
#' For this function to work, you need to first add the **`markup`** to the
#' Rmarkdown. The standard one is \code{<!--DWC_EVENT-->} (with no quotation
#' marks). Then, the function will locate the markup and substitute it for the
#' formated code chunk. Note that you can use any markup, but this have to be
#' identifiable within your file.
#'
#' Note that the `full` does not contains all fields available in DwC for this class. Also, the recommended
#' fields for the class include some other fields that should usually be included, but are not necessary. See
#' the references for more information. Special attention should be taken when describing events and associated
#' occurrences as some additional fields may be needed and others omitted in each table.
#'
#' @seealso
#' - \href{https://ipt.gbif.org/manual/en/ipt/latest/occurrence-data}{GBIF manual for occurrence data}
#' - \href{https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml}{GBIF repository of DwC schemas}
#'
#' @examples
#' \dontrun{
#' add_dwc_occurrence()
#' }
add_dwc_occurrence <- function(markup = "<!--DWC_OCCURRENCES-->", full = FALSE,
                          acode = "dwc",
                          object_name = "dataset",
                          rmd_file = NULL){

  if (is.null(rmd_file)) {
    rmd_file <- "src/obisdi_general.Rmd"
  }

  ol <- readLines(rmd_file)

  if (full) {
    fields <- c("eventID",
                "parentEventID",
                "fieldNumber",
                "eventDate",
                "eventTime",
                "year",
                "month",
                "day",
                "habitat",
                "samplingProtocol",
                "sampleSizeValue",
                "sampleSizeUnit",
                "samplingEffort",
                "fieldNotes",
                "eventRemarks",
                "identificationID",
                "identifiedBy",
                "identifiedByID",
                "identificationRemarks",
                "locationID",
                "country",
                "countryCode",
                "minimumDepthInMeters",
                "maximumDepthInMeters",
                "locationRemarks",
                "decimalLatitude",
                "decimalLongitude",
                "geodeticDatum",
                "coordinateUncertaintyInMeters",
                "coordinatePrecision",
                "occurrenceID",
                "individualCount",
                "organismQuantity",
                "organismQuantityType",
                "occurrenceStatus",
                "type",
                "institutionID",
                "datasetID",
                "institutionCode",
                "datasetName",
                "basisOfRecord",
                "scientificName",
                "kingdom","phylum","class","order","family","genus",
                "taxonRank",
                "scientificNameID"
    )
  } else {
    fields <- c("occurrenceID",
                "basisOfRecord",
                "scientificName",
                "eventDate",
                "taxonRank",
                "kingdom",
                "decimalLatitude",
                "decimalLongitude",
                "geodeticDatum",
                "countryCode",
                "individualCount",
                "occurrenceStatus"
    )
  }

  nl <- paste0(
    "```{r}
occurrences <- dataset %>%
\tmutate(", "\n",
    paste0("\t\t", acode, "_", fields, " = ", object_name, collapse = ",\n"),
    "\n)
```", collapse = "\n"
  )

  ol <- gsub(markup, nl, ol)

  writeLines(ol, rmd_file)

  cli::cli_alert_success("DwC occurrence mapping added to {.file {rmd_file}}.")

  return(invisible(NULL))
}
