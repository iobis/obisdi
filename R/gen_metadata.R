#' Generate metadata object for individuals
#'
#' @param givenName first name
#' @param surName family name
#' @param organizationName organization name
#' @param positionName position name
#' @param role role in the organization (optional)
#' @param phone phone (optional)
#' @param electronicMailAddress e-mail (optional, but recommended)
#' @param deliveryPoint address related (optional)
#' @param postalCode postal code (optional)
#' @param city  city (optional)
#' @param administrativeArea administrative area (optional)
#' @param country country (ISO conforming, optional)
#' @param onlineUrl website or ORCID page of the person (optional)
#'
#' @details
#' There is a + method for selecting just one or multiple names from a meta_person object (the object generated with this function).
#' Thus, suppose you create an object called \code{people} for three persons: John Doe, Max Planck, Carl Pol. But you decide that only one will be used to the \code{contact} field. Then you can do:
#'
#' \code{selected_people <- people + "John Doe"}
#'
#' Similarly you can supply a vector:
#'
#' \code{selected_people <- people + c("John Doe", "Max Planck")}
#'
#' Of course, names should match the original ones, otherwise an error is thrown.
#'
#' The - method works for excluding someone from the list:
#'
#' \code{selected_people <- people - "John Doe"}
#'
#'
#' @return a list containing the original values and a list of XML ready objects
#' @export
#'
#' @examples
#' \dontrun{
#' people <- gen_meta_person("John", "Doe", "My company", "CEO")
#' people
#' }
gen_meta_person <- function (
    givenName,
    surName,
    organizationName,
    positionName,
    role = NULL,
    phone = NULL,
    electronicMailAddress = NULL,
    deliveryPoint = NULL,
    postalCode = NULL,
    city = NULL,
    administrativeArea = NULL,
    country = NULL,
    onlineUrl = NULL
) {

  ar <- as.list(match.call())
  ar <- ar[-1]

  ar <- as.data.frame(ar)

  res_xml <- list()

  for (j in 1:nrow(ar)) {

    name_sec <- "<individualName>
                <givenName></givenName>
                <surName></surName>
            </individualName>
            <organizationName></organizationName>
            <positionName></positionName>
            <address>
            	<deliveryPoint></deliveryPoint>
                <city></city>
                <administrativeArea></administrativeArea>
                <postalCode></postalCode>
                <country></country>
            </address>
            <phone></phone>
            <electronicMailAddress></electronicMailAddress>
            <onlineUrl></onlineUrl>"

    for (z in 1:length(ar)) {
      na <- colnames(ar)[z]
      name_sec <- gsub(paste0("<", na, ">", "</", na, ">"),
                       paste0("<", na, ">", ar[j,z], "</", na, ">"),
                       name_sec)
    }

    res_xml[[j]] <- name_sec
  }

  names(res_xml) <- paste(ar$givenName, ar$surName, sep = "_")

  flist <- list(
    xml = res_xml,
    original = ar
  )

  class(flist) <- c(class(flist), "meta_person")

  return(flist)
}

#' @export
print.meta_person <- function(x){
  print(x$original)
  return(invisible(NULL))
}

#' @export
`+.meta_person` <- function(e1, e2) {
  e2 <- gsub(" ", "_", e2)
  if (!all(grepl("_", e2))) {
    e2[!grepl("_", e2)] <- paste0(e2[!grepl("_", e2)], "_")
  }
  nams <- names(e1$xml)
  if (!all(e2 %in% nams)) {
    stop("There are no persons registered for one or more of those names")
  }
  new_xml <- e1$xml[e2]
  new_list <- list(original = paste("Modified meta_person object containing data for",
                                    gsub("_", " ", paste(e2, collapse = ", "))),
                   xml = new_xml)
  class(new_list) <- c(class(new_list), "meta_person")
  return(new_list)
}


#' @export
`-.meta_person` <- function(e1, e2) {
  e2 <- gsub(" ", "_", e2)
  if (!all(grepl("_", e2))) {
    e2[!grepl("_", e2)] <- paste0(e2[!grepl("_", e2)], "_")
  }
  nams <- names(e1$xml)
  if (!all(e2 %in% nams)) {
    stop("There are no persons registered for one or more of those names")
  }
  new_xml <- e1$xml[!nams %in% e2]
  new_list <- list(original = paste("Modified meta_person object excluding data for",
                                    gsub("_", " ", paste(e2, collapse = ", "))),
                   xml = new_xml)
  class(new_list) <- c(class(new_list), "meta_person")
  return(new_list)
}

#' Generate metadata object for geographical coverage
#'
#' @param geographicDescription description/name of the area of coverage
#' @param westBoundingCoordinate,eastBoundingCoordinate,northBoundingCoordinate,southBoundingCoordinate coordinates
#' of the longitude and latitude limits (numeric)
#'
#' @return a meta_cov object containing the geographical coverage xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_geocov("The area of study")
#' }
gen_meta_geocov <- function(
    geographicDescription,
    westBoundingCoordinate = NULL,
    eastBoundingCoordinate = NULL,
    northBoundingCoordinate = NULL,
    southBoundingCoordinate = NULL
) {

  ar <- as.list(match.call())
  ar <- ar[-1]

  ar <- as.data.frame(ar)

  name_sec <- "<geographicCoverage>
                <geographicDescription></geographicDescription>
                <boundingCoordinates>
                    <westBoundingCoordinate></westBoundingCoordinate>
                    <eastBoundingCoordinate></eastBoundingCoordinate>
                    <northBoundingCoordinate></northBoundingCoordinate>
                    <southBoundingCoordinate></southBoundingCoordinate>
                </boundingCoordinates>
            </geographicCoverage>"

  for (z in 1:length(ar)) {
    na <- colnames(ar)[z]
    name_sec <- gsub(paste0("<", na, ">", "</", na, ">"),
                     paste0("<", na, ">", ar[1,z], "</", na, ">"),
                     name_sec)
  }

  flist <- list(
    xml = name_sec,
    original = ar
  )

  class(flist) <- c(class(flist), "meta_cov")

  return(flist)
}


#' Generate metadata object for temporal coverage
#'
#' @param singleDateTime a single date for the coverage
#' @param beginDate,endDate start (end) date of the coverage.
#'
#' @details
#' You can supply a single date \code{singleDateTime} or the start AND end date,
#' but you can supply both the single date and the range.
#'
#' In all cases use the format YYYY-MM-DD (ISO conform) or just YYYY-MM or YYYY
#'
#' @return a meta_cov object containing the temporal coverage xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_temporalcov("2023-05-05")
#' }
gen_meta_temporalcov <- function(
    singleDateTime = NULL,
    beginDate = NULL,
    endDate = NULL
) {

  if (is.null(singleDateTime) & is.null(beginDate)) {
    stop("At least one of singleDateTime or the other two should be supplied.")
  } else {
    if (!is.null(singleDateTime) & !is.null(beginDate)) {
      stop("Only singleDateTime OR the other two should be supplied (not all).")
    }
  }

  ar <- as.list(match.call())
  ar <- ar[-1]

  ar <- as.data.frame(ar)

  if (is.null(singleDateTime)) {
    name_sec <- "<temporalCoverage>
                <rangeOfDates>
                    <beginDate></beginDate>
                    <endDate></endDate>
                </rangeOfDates>
            </temporalCoverage>"
  } else {
    name_sec <- "<temporalCoverage>
                <singleDateTime></singleDateTime>
            </temporalCoverage>"
  }

  for (z in 1:length(ar)) {
    na <- colnames(ar)[z]
    name_sec <- gsub(paste0("<", na, ">", "</", na, ">"),
                     paste0("<", na, "><calendarDate>", ar[1,z], "</calendarDate></", na, ">"),
                     name_sec)
  }

  flist <- list(
    xml = name_sec,
    original = ar
  )

  class(flist) <- c(class(flist), "meta_cov")

  return(flist)
}

#' Generate metadata object for taxonomic coverage
#'
#' @param generalTaxonomicCoverage a description of the taxonomic coverage
#' @param taxonRankName optional
#' @param taxonRankValue optional
#' @param commonName optional
#'
#' @return a meta_cov object containing the taxonomic coverage xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_taxoncov("Plantae of Europe")
#' }
gen_meta_taxoncov <- function(
    generalTaxonomicCoverage,
    taxonRankName = NULL,
    taxonRankValue = NULL,
    commonName = NULL
) {
  ar <- as.list(match.call())
  ar <- ar[-1]

  ar <- as.data.frame(ar)

  name_sec <- "<taxonomicCoverage>
                <generalTaxonomicCoverage></generalTaxonomicCoverage>
                <CLASSIFICATION>
            </taxonomicCoverage>"

  name_sec <- gsub(
    "<generalTaxonomicCoverage></generalTaxonomicCoverage>",
    paste0("<generalTaxonomicCoverage>", ar$generalTaxonomicCoverage[1],
           "</generalTaxonomicCoverage>"),
    name_sec
  )

  if (ncol(ar) > 1) {
    class_xml <- c()
    for (j in 1:nrow(ar)) {
      class_sec <- "<taxonomicClassification>
                    <taxonRankName></taxonRankName>
                    <taxonRankValue></taxonRankValue>
                    <commonName></commonName>
                </taxonomicClassification>"

      for (z in 2:length(ar)) {
        na <- colnames(ar)[z]
        class_sec <- gsub(paste0("<", na, ">", "</", na, ">"),
                         paste0("<", na, ">", ar[j,z], "</", na, ">"),
                         class_sec)
      }

      class_xml <- c(class_xml, class_sec)
    }
    class_xml <- paste(class_xml, collapse = "\n")
  } else {
    class_xml <- ""
  }

  name_sec <- gsub(
    "<CLASSIFICATION>", class_xml, name_sec
  )

  flist <- list(
    xml = name_sec,
    original = ar
  )

  class(flist) <- c(class(flist), "meta_cov")

  return(flist)
}


#' @export
print.meta_cov <- function(x){
  print(x$original)
  return(invisible(NULL))
}


#' Generate metadata object for project info
#'
#' @param personnel an object of class \code{meta_person} generated with [gen_meta_person] optional
#' @param funding optional
#' @param studyAreaDescription optional
#' @param designDescription optional
#'
#' @details
#' You can chose any or several fields to fill.
#'
#'
#' @return meta_proj object containing the project section xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_project(funding = "Funder #0000")
#' }
gen_meta_project <- function(
    personnel = NULL,
    funding = NULL,
    studyAreaDescription = NULL,
    designDescription = NULL
  ){

  ar <- as.list(match.call())
  ar <- ar[-1]

  name_sec <- '<project>
            <title>TITLE</title>
            <personnel>
                <INDIVIDUAL>
            </personnel>
            <funding>
                <para><FUNDING></para>
            </funding>
            <studyAreaDescription>
                <descriptor name="generic" citableClassificationSystem="false">
                    <descriptorValue><STAREA_DESC></descriptorValue>
                </descriptor>
            </studyAreaDescription>
            <designDescription>
                <description><DESIGN_DESC></description>
            </designDescription>
        </project>'

  if (is.null(personnel)) {
    personnel <- ""
  } else {
    if (!"meta_person" %in% class(personnel)) {
      stop("personnel should be an object generated with gen_meta_person")
    } else {
      personnel <- paste(personnel$xml, collapse = "\n")
    }
  }

  name_sec <- gsub(
    "<INDIVIDUAL>", personnel, name_sec
  )

  name_sec <- gsub(
    "<FUNDING>", ifelse(is.null(funding), "", funding),
    name_sec
  )

  name_sec <- gsub(
    "<STAREA_DESC>", ifelse(is.null(studyAreaDescription), "", studyAreaDescription),
    name_sec
  )

  name_sec <- gsub(
    "<DESIGN_DESC>", ifelse(is.null(designDescription), "", designDescription),
    name_sec
  )

  flist <- list(
    xml = name_sec,
    original = ar
  )

  class(flist) <- c(class(flist), "meta_proj")

  return(flist)
}


#' Generate metadata object for methods info
#'
#' @param steps_description a \code{vector} containing one or more step descriptions
#' @param studyExtent the extent of the study area
#' @param samplingDescription the description of the sampling
#' @param qualityControl the quality control procedure (optional)
#'
#' @return a meta_method object containing the methods section xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_methods("The description", "The study extent", "A sampling description")
#' }
gen_meta_methods <- function(
    steps_description,
    studyExtent,
    samplingDescription,
    qualityControl = NULL
  ) {

  step_base <- "<methodStep>
                <description>
                    <para>STEP_TEXT</para>
                </description>
            </methodStep>"

  step_xml <- c()

  for (z in 1:length(steps_description)) {
    new_step <- gsub("STEP_TEXT", steps_description[z],
                     step_base)
    step_xml <- c(step_xml, new_step)
  }

  step_xml <- paste(step_xml, collapse = "\n")

  meth_xml <- "<sampling>
                <studyExtent>
                    <description>
                    	<para>EXTENT_TEXT</para>
                    </description>
                </studyExtent>
                <samplingDescription>
                    <para>SAMPLING_TEXT</para>
                </samplingDescription>
            </sampling>"

  meth_xml <- gsub("EXTENT_TEXT",
                   studyExtent, meth_xml)

  meth_xml <- gsub("SAMPLING_TEXT",
                   samplingDescription, meth_xml)

  if (!is.null(qualityControl)) {
    qc <- "<qualityControl>
                <description>
                    <para>QUALITY_TEXT</para>
                </description>
            </qualityControl>"

    qc <- gsub("QUALITY_TEXT",
               qualityControl, qc)
  } else {
    qc <- ""
  }

  meth_xml_final <- paste(
    step_xml, meth_xml, qc,
    collapse = "\n"
  )

  class(meth_xml_final) <- c(class(meth_xml_final), "meta_method")

  return(meth_xml_final)
}


#' Generate metadata object for keywords
#'
#' @param keyword a \code{vector} containing one or various keywords
#' @param keywordThesaurus one single thesaurus for the keywords set
#'
#' @return a meta_keyword object containing the keywords section xml
#' @export
#'
#' @examples
#' \dontrun{
#' gen_meta_keywords(c("Keyword 1", "Keyword 2"), "Thesaurus of botany")
#' }
gen_meta_keywords <- function(
    keyword,
    keywordThesaurus
  ) {
  if (length(keywordThesaurus) > 1) {
    stop("Only a single thesaurus per keywordSet")
  }

  meta_key <- c()

  for (i in 1:length(keyword)) {
    meta_key <- c(meta_key,
                  paste0(
                    "<keyword>", keyword[i], "</keyword>"
                  ))
  }

  meta_key <- c(meta_key,
                paste0(
                  "<keywordThesaurus>", keywordThesaurus, "</keywordThesaurus>"
                ))

  class(meta_key) <- c(class(meta_key), "meta_keyword")

  return(meta_key)
}



#' Generate an EML metadata file in the XML format to inclusion in the IPT
#'
#' EML (Ecological Markup Language) is a standard format for metadata widely used by the biodiversity databases.
#' This function creates an standard EML file for use when submitting data through one IPT (\url{https://ipt.gbif.org/manual/en/ipt/latest/}).
#'
#'
#' @param outfolder the folder where the xml will be saved
#' @param outfile the name of the metadata file
#' @param title the title of the dataset
#' @param creator the creator of the dataset. Should be of meta_person class, created with [gen_meta_person()]
#' @param metadataProvider the provider of the dataset. Should be of meta_person class, created with [gen_meta_person()]
#' @param language the language of the dataset (ISO conform)
#' @param metadataLanguage the language of the metadata (ISO conform)
#' @param abstract abstract of the project (\code{character})
#' @param associatedParty associated parties. Should be of meta_person class, created with [gen_meta_person()]
#' @param coverage geographical, taxonomic or/and temporal coverage. Should be a list of objects of class meta_cov created using [gen_meta_geocov()], [gen_meta_temporalcov()] or [gen_meta_taxoncov()]
#' @param purpose the purpose of the dataset
#' @param contact the contacts of the dataset. Should be of meta_person class, created with [gen_meta_person()]
#' @param methods methods of the project. Should be a meta_methods object created with [gen_meta_methods()].
#' @param project project info created with [gen_meta_project()]
#' @param intellectualRights intellectual rights (text)
#' @param keywordSet keywords. Should be a list of meta_keyword objects created with [gen_meta_keywords()]
#'
#' @details
#' Some of the fields need objects created with other functions of the "gen_meta" family. When the field asks for a list you can also supply a single object,
#' which will then be converted into a list.
#' For more information about the fields, consult the following link: \url{https://www.gbif.org/sites/default/files/gbif_resource/resource-80640/gbif_metadata_profile_guide_en_v1.pdf}
#'
#' The & symbol should NOT be used in any text, otherwise the reading of the xml will fail.
#'
#' When supplying names for the fields that require an object of type \code{meta_person}, you can select just a couple of names of the full object by using
#' the "+" or "-" method (for more details see [gen_meta_person()]).
#'
#' @seealso [gen_meta_person()],[gen_meta_geocov()], [gen_meta_temporalcov()], [gen_meta_taxoncov()], [gen_meta_project()],
#' [gen_meta_methods()], [gen_meta_keywords()]
#'
#' @return an XML file in the EML language
#' @export
#'
#' @examples
#' \dontrun{
#' person <- gen_meta_person("John", "Doe", "Researcher", "Institute")
#' gen_metadata(title = "My title", creator = person, metadataProvider = person,
#' language = "English", metadataLanguage = "English", abstract = "Some text.")
#' }
gen_metadata <- function(
  outfolder = "data/processed",
  outfile = "metadata",
  title,
  creator,
  metadataProvider,
  language,
  metadataLanguage,
  abstract,
  associatedParty = NULL,
  coverage = NULL,
  purpose = NULL,
  contact = NULL,
  methods = NULL,
  project = NULL,
  intellectualRights = NULL,
  keywordSet = NULL
) {

  init <- '<?xml version="1.0" encoding="utf-8"?>
<eml:eml xmlns:eml="eml://ecoinformatics.org/eml-2.1.1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/terms/"
    xsi:schemaLocation="eml://ecoinformatics.org/eml-2.1.1 eml.xsd"
    xml:lang="en"
    packageId="619a4b95-1a82-4006-be6a-7dbe3c9b33c5/v7" system="http://gbif.org" scope="system">

  <dataset>'

  outpath <- paste0(outfolder, "/", outfile, ".xml")

  final_xml <- c(
    init,
    paste0("<title>", title, "</title>")
  )

  if (!"meta_person" %in% class(creator)) {
    stop("creator should be of type meta_person")
  } else {
    creator <- paste("<creator>", creator$xml, "</creator>", collapse = "\n")
  }

  final_xml <- c(
    final_xml, creator
  )

  if (!"meta_person" %in% class(metadataProvider)) {
    stop("metadataProvider should be of type meta_person")
  } else {
    metadataProvider <- paste("<metadataProvider>", metadataProvider$xml, "</metadataProvider>", collapse = "\n")
  }

  final_xml <- c(
    final_xml, metadataProvider
  )

  if (!is.null(associatedParty)) {
    if (!"meta_person" %in% class(associatedParty)) {
      stop("metadataProvider should be of type meta_person")
    } else {
      associatedParty <- paste("<associatedParty>", associatedParty$xml, "</associatedParty>", collapse = "\n")
    }

    final_xml <- c(
      final_xml, associatedParty
    )
  }

  final_xml <- c(
    final_xml,
    paste0("<language>", language, "</language>"),
    paste0("<metadataLanguage>", language, "</metadataLanguage>")
  )

  for (z in 1:length(abstract)) {
    final_xml <- c(
      final_xml,
      paste0("<abstract><para>", abstract[z], "</para></abstract>")
    )
  }

  if (!is.null(coverage)) {
    if (!all(class(coverage) == "list")) {
      coverage <- list(coverage)
    }
    xmls <- lapply(coverage, function(x){
      if (!"meta_cov" %in% class(x)) {
        stop("coverage should be a list of meta_cov objects")
      }
      x$xml
    })
    xmls <- paste(xmls, collapse = "\n")

    final_xml <- c(
      final_xml,
      paste0("<coverage>", xmls, "</coverage>")
    )
  }

  if (!is.null(purpose)) {
    final_xml <- c(
      final_xml,
      paste0("<purpose><para>", purpose, "</para></purpose>")
    )
  }

  if (!is.null(contact)) {
    if (!"meta_person" %in% class(contact)) {
      stop("metadataProvider should be of type meta_person")
    } else {
      contact <- paste("<contact>", contact$xml, "</contact>", collapse = "\n")
    }

    final_xml <- c(
      final_xml, contact
    )
  }

  if (!is.null(methods)) {
    if (!"meta_method" %in% class(methods)) {
      stop("methods should be a meta_method object")
    }

    final_xml <- c(
      final_xml,
      paste0("<methods>", methods, "</methods>")
    )
  }

  if (!is.null(project)) {
    if (!"meta_proj" %in% class(project)) {
      stop("project should be of type meta_proj")
    }
    final_xml <- c(final_xml, project$xml)
  }

  if (!is.null(intellectualRights)) {
    final_xml <- c(
      final_xml,
      paste0("<intellectualRights><para>", intellectualRights, "</para></intellectualRights>")
    )
  }

  if (!is.null(keywordSet)) {
    if (!all(class(keywordSet) == "list")) {
      keywordSet <- list(keywordSet)
    }
    xmls <- lapply(keywordSet, function(x){
      if (!"meta_keyword" %in% class(x)) {
        stop("keywordSet should be a list of meta_keyword objects")
      }
      x <- paste("<keywordSet>", paste(x, collapse = "\n"), "</keywordSet>")
      x
    })

    final_xml <- c(
      final_xml, paste(xmls, collapse = "\n")
    )
  }

  final_xml <- c(final_xml,
                 "</dataset>
                 </eml:eml>")

  final_xml <- paste(final_xml, collapse = "\n")

  writeLines(final_xml, outpath)

  cli::cli_alert_success("Metadata file {.file {outpath}} successfully created.")

  return(invisible(NULL))
}
