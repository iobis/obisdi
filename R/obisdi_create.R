#' Create an obisdi standard project
#'
#' @param path the path
#' @param ... other parameters passed by the widget
#'
#' @return the directory
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' obisdi_create("my_path", "My project")
#' }
.obisdi_create <- function(path, ...) {

  # Create path to project
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }

  # Create folder structure
  dir.create(paste0(path, "/data/raw"), recursive = T)
  dir.create(paste0(path, "/data/processed"), recursive = T)
  dir.create(paste0(path, "/src"), recursive = T)

  # collect inputs and paste together as 'Parameter: Value'
  dots <- list(...)
  text <- lapply(seq_along(dots), function(i) {
    key <- names(dots)[[i]]
    val <- dots[[i]]
    paste0(key, ": ", val)
  })

  # If source file is supplied, copy it
  if ("file" %in% names(dots)) {
    src_file <- dots[["file"]]

    if (src_file != "") {
      fext <- tools::file_ext(src_file)

      if (fext == "zip") {
        od <- paste0(path, "/data/raw/zip")
        dir.create(od)
        utils::unzip(src_file, exdir = od)
        src_file <- list.files(od, full.names = T, recursive = T)
      }

      for (i in 1:length(src_file)) {
        sz <- file.size(src_file[i])
        sz <- sz/1e6

        if (sz > 50) {
          if (dots[["convert"]]) {
            f <- utils::read.csv(src_file[i])
            arrow::write_parquet(f,
                                 paste0(path, "/data/raw/",
                                        gsub(".csv", ".parquet", basename(src_file[i]))))
          } else {
            file.copy(src_file[i],
                      paste0(path, "/data/raw"))
          }
        } else {
          file.copy(src_file[i],
                    paste0(path, "/data/raw"))
        }
      }

      if (fext == "zip") {
        unlink(od, recursive = T)
      }
    }
  }

  # Copy the RMD files
  ld <- list.dirs(paste0(.libPaths(), "/obisdi/models/", dots[["type"]]),
                  recursive = T, full.names = F)[-1]
  ld <- paste0(path, "/src/", ld)
  lapply(ld, dir.create, recursive = T)

  lf <- list.files(paste0(.libPaths(), "/obisdi/models/", dots[["type"]]),
                   recursive = T, full.names = F)
  remfile <- lf[grep("README", lf)]
  lf <- lf[-grep("README", lf)]

  file.copy(paste0(.libPaths(), "/obisdi/models/", dots[["type"]], "/", lf),
            paste0(path, "/src/", lf))

  file.copy(paste0(.libPaths(), "/obisdi/models/", dots[["type"]], "/", remfile),
            path)
  file.copy(paste0(.libPaths(), "/obisdi/img/obisdi_logo.png"),
            paste0(path, "/src/static"))

  # Edit headers of files according to supplied details
  ol <- readLines(paste0(path, "/src/obisdi_", dots[["type"]], ".Rmd"))
  ol[3] <- gsub("PROJECT_NAME", dots[["datanam"]], ol[3])
  writeLines(ol, paste0(path, "/src/obisdi_", dots[["type"]], ".Rmd"))
  rm(ol)

  ol <- readLines(paste0(path, "/README.md"))
  ol <- gsub("PROJECT_NAME", dots[["datanam"]], ol)
  fld <- basename(path)
  ol <- gsub("PROJECT_FOLD_NAME", fld, ol)
  writeLines(ol, paste0(path, "/README.md"))

  ol <- readLines(paste0(path, "/src/_site.yml"))
  ol <- gsub("DATASET_NAME", dots[["datanam"]], ol)
  writeLines(ol, paste0(path, "/src/_site.yml"))

  # Save gitignore file
  writeLines(
    "# History files
.Rhistory
.Rapp.history

# Session Data files
.RData

# Example code in package build process
*-Ex.R

# Output files from R CMD build
/*.tar.gz

# Output files from R CMD check
/*.Rcheck/

# RStudio files
.Rproj.user/

# produced vignettes
vignettes/*.html
vignettes/*.pdf

# OAuth2 token, see https://github.com/hadley/httr/releases/tag/v0.3
.httr-oauth

# knitr and R markdown default cache directories
/*_cache/
/cache/

# Temporary files created by R markdown
*.utf8.md
*.knit.md

# Other
.DS_Store
.Rproj.user
src/*.html",
  paste0(path, "/.gitignore"))

}



#' Create an obisdi standard project
#'
#' @description
#' This function is used for...
#'
#'
#' @param path the (absolute or relative) path to generate the project folder
#' @param dataset_name character with the dataset name
#' @param type type of project. At this moment, only "general" is available.
#'
#' @return An structured folder with the necessary files for data processing.
#' @export
#'
#' @examples
#' \dontrun{
#' obisdi_create("my_path", "My project")
#' }
obisdi_create <- function(path,
                          dataset_name,
                          type = "general") {

  # Create path to project
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }

  # Create folder structure
  dir.create(paste0(path, "/data/raw"), recursive = T)
  dir.create(paste0(path, "/data/processed"), recursive = T)
  dir.create(paste0(path, "/src"), recursive = T)

  # Copy the RMD files
  ld <- list.dirs(paste0(.libPaths(), "/obisdi/models/", type),
                  recursive = T, full.names = F)[-1]
  ld <- paste0(path, "/src/", ld)
  lapply(ld, dir.create, recursive = T)

  lf <- list.files(paste0(.libPaths(), "/obisdi/models/", type),
                   recursive = T, full.names = F)
  remfile <- lf[grep("README", lf)]
  lf <- lf[-grep("README", lf)]

  file.copy(paste0(.libPaths(), "/obisdi/models/", type, "/", lf),
            paste0(path, "/src/", lf))

  file.copy(paste0(.libPaths(), "/obisdi/models/", type, "/", remfile),
            path)
  file.copy(paste0(.libPaths(), "/obisdi/img/obisdi_logo.png"),
            paste0(path, "/src/static"))

  # Edit headers of files according to supplied details
  ol <- readLines(paste0(path, "/src/obisdi_", type, ".Rmd"))
  ol[3] <- gsub("PROJECT_NAME", dataset_name, ol[3])
  writeLines(ol, paste0(path, "/src/obisdi_", type, ".Rmd"))
  rm(ol)

  ol <- readLines(paste0(path, "/README.md"))
  ol <- gsub("PROJECT_NAME", dataset_name, ol)
  fld <- basename(path)
  ol <- gsub("PROJECT_FOLD_NAME", fld, ol)
  writeLines(ol, paste0(path, "/README.md"))

  ol <- readLines(paste0(path, "/src/_site.yml"))
  ol <- gsub("DATASET_NAME", dots[["datanam"]], ol)
  writeLines(ol, paste0(path, "/src/_site.yml"))

  # Save gitignore file
  writeLines(
    "# History files
.Rhistory
.Rapp.history

# Session Data files
.RData

# Example code in package build process
*-Ex.R

# Output files from R CMD build
/*.tar.gz

# Output files from R CMD check
/*.Rcheck/

# RStudio files
.Rproj.user/

# produced vignettes
vignettes/*.html
vignettes/*.pdf

# OAuth2 token, see https://github.com/hadley/httr/releases/tag/v0.3
.httr-oauth

# knitr and R markdown default cache directories
/*_cache/
/cache/

# Temporary files created by R markdown
*.utf8.md
*.knit.md

# Other
.DS_Store
.Rproj.user
src/*.html",
    paste0(path, "/.gitignore"))

}
