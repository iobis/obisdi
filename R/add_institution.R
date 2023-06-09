#' Add institutional details on README and .Rmd files
#'
#' @param inst_message \code{character} message to be written
#' @param inst_name \code{character} name of the institution
#' @param inst_details \code{character} further details. Will be separated by a "|"
#' @param html_text a \code{character} with HTML code to be inserted in the
#' institutional details area. If used, all other parameters are ignored.
#'
#' @return Edited files.
#' @export
#'
#' @examples
#' \dontrun{
#' add_institution(inst_name = "My institution")
#' }
add_institution <- function(inst_message = "Dataset edited by",
                            inst_name,
                            inst_details = NULL,
                            html_text = NULL) {

  if (!is.null(html_text)) {
    nl <- paste(
      "<!--INSTITUTIONAL_DETAILS-->", html_text
    )
  } else {
    if (!is.null(inst_details)) {
      inst_details <- paste("|", inst_details)
    }
    nl <- paste(
      "<!--INSTITUTIONAL_DETAILS-->", inst_message, inst_name, inst_details, "<br>"
    )
  }

  rol <- readLines("README.md")
  rol[grep("<!--INSTITUTIONAL_DETAILS-->", rol)] <- paste0(nl, "<br>")
  writeLines(rol, "README.md")
  cli::cli_alert_success("Institutional details added to README.md")
  fol <- readLines("src/static/footer.html")
  fol[grep("<!--INSTITUTIONAL_DETAILS-->", fol)] <- paste0(nl, "<br>")
  writeLines(fol, "src/static/footer.html")
  cli::cli_alert_success("Institutional details added to src/static/footer.html")
  return(invisible(NULL))
}
