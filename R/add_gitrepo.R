#' Add GitHub repo address on README and .Rmd files
#'
#' @param user_name \code{character} name of GitHub account (usually your user name)
#' @param repo_name \code{character} name of the repository. Except in the cases your repository will be named differently then
#' the folder, you should leave it as \code{NULL}.
#'
#' @return Edited files.
#' @export
#'
#' @examples
#' \dontrun{
#' add_gitrepo("my-git-account")
#' }
add_gitrepo <- function(user_name, repo_name = NULL) {

  if (is.null(repo_name)) {
    wd <- getwd()
    repo_name <- basename(wd)
  }

  ghn <- paste0(
    "https://github.com/",
    user_name, "/", repo_name
  )

  rol <- readLines("README.md")
  rol <- gsub("<GITHUB-REPO>", ghn, rol)
  writeLines(rol, "README.md")

  ol <- readLines("src/obisdi_general.Rmd")
  ol <- gsub("<GITHUB-REPO>", ghn, ol)
  writeLines(ol, "src/obisdi_general.Rmd")

  cli::cli_alert_success("GitHub repo details added to README and Rmd files.")

  return(invisible(NULL))
}
