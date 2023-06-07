add_funding <- function(fund_message = "This work was funded by",
                        fund_name,
                        fund_code = NULL,
                        html_text = NULL) {

  if (!is.null(html_text)) {
    nl <- paste(
      "<!--FUNDING_DETAILS-->", html_text
    )
  } else {
    nl <- paste(
      "<!--FUNDING_DETAILS-->", fund_message, fund_name, fund_code, "<br>"
    )
  }

  rol <- readLines("README.md")
  rol[grep("<!--FUNDING_DETAILS-->", rol)] <- paste0(nl, "<br>")
  writeLines(rol, "README.md")
  cli::cli_alert_success("Institutional details added to README.md")
  fol <- readLines("src/static/footer.html")
  fol[grep("<!--FUNDING_DETAILS-->", fol)] <- paste0(nl, "<br>")
  writeLines(fol, "src/static/footer.html")
  cli::cli_alert_success("Institutional details added to src/static/footer.html")
  return(invisible(NULL))
}
