#' Add funding details on README and .Rmd files
#'
#' @param article_id the FigShare article ID. This is the number shown at the end
#' of any FigShare document URL (e.g. https://figshare.com/articles/dataset/A_comprehensive_dataset_of_the_cold-water_coral_diversity/21997559,
#' in this case the ID is 21997559)
#' @param download_files \code{logical} if \code{TRUE}, then the files associated to this FigShare
#' document will be downloaded to the "data/raw" folder. A large timeout is set, but depending on the
#' file size it's advised to do the download separately. If any download fail, the user will receive a message.
#' @param save_meta \code{logical} indicating if the metadata should be saved in the "data/raw" folder.
#' @param path the path to save the files and metadata. By standard, it will save in "data/raw", but if you
#' are working in a Rmd file, knitting will take place from the folder where the Rmd file is residing.
#' In this case you can either supply an adjusted path or use [here::here()].
#'
#' @return A \code{list} with information about the FigShare article (see details).
#' @details
#' The returned \code{list} will contain the following fields:
#' - title
#' - authors
#' - description (usually the abstract)
#' - version (the version of the dataset)
#' - date
#' - doi
#' - license
#' - url
#' - download_url (the URLs to download the files; a list with named (file name) lists containing the URLs)
#'
#' All those details are relevant metadata that should ideally be included in your document. Note that some fields may be empty or with a "try-error",
#' which indicates that the field was not available.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_figshare(21997559)
#' }
get_figshare <- function(article_id, download_files = FALSE, save_meta = FALSE,
                         path = NULL){

  if (is.null(path)) {
    path <- "data/raw"
  }

  response <- httr::GET(paste0("https://api.figshare.com/v2/articles/",
                               article_id))

  if (response$status_code != 200) {
    stop("Failed getting FigShare details. Check article id and internet connection.")
  } else {
    t_resp <- httr::content(response, "parsed", encoding = "UTF-8")
  }

  full_details <- list(
    title = t_resp$title,
    authors = paste(unlist(lapply(t_resp$authors,
                                  function(x){x$full_name})), collapse = ", "),
    description = try(t_resp$description),
    version = try(t_resp$version),
    date = t_resp$published_date,
    doi = t_resp$doi,
    license = t_resp$license$name,
    url = t_resp$figshare_url,
    download_url = lapply(t_resp$files, function(x){
      file_name <- x$name
      url = x$download_url
      nl <- list(url)
      names(nl) <- file_name
      return(nl)
    })
  )

  if (download_files) {
    options(timeout=9999999)
    dr <- list()
    for (i in 1:length(full_details$download_url)) {
      cli::cli_inform(cli::col_cyan("Downloading file {names(full_details$download_url[[i]])}"))
      dr[[i]] <- try(download.file(full_details$download_url[[i]][[1]],
                              paste0(path, "/", names(full_details$download_url[[i]]))))
    }
    dr <- unlist(lapply(dr, function(x){class(x)}))
    if (any(grepl("try-error", dr))) {
      cli::cli_alert_warning("One or more files were not downloaded. Check carefully.")
    } else {
      cli::cli_inform(c(i = "Files downloaded to data/raw"))
    }
  }

  if (save_meta) {
    meta_details <- data.frame(title = NA)
    for (i in 1:8) {
      eval(parse(text = paste0(
        "meta_details$", names(full_details[i]), "<- full_details[[i]]"
      )))
    }
    meta_details$download_urls <- paste0("{", names(unlist(full_details$download_url)),
                                         " : ",  unlist(full_details$download_url) ,"}",
                                         collapse = ";")
    meta_details$reponame <- "FigShare"
    meta_details$doi <- gsub("https://doi.org/", "", meta_details$doi)
    write.csv(meta_details, paste0(
      path, "/figshare_metadata_", format(Sys.Date(), "%d%m%Y"), ".csv"
    ), row.names = F)
  }

  return(full_details)
}
