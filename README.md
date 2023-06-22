
<!-- README.md is generated from README.Rmd. Please edit that file -->

# obisdi <img src="man/figures/obisdi_logo.png" align="right" alt="" width="120" />

<!-- badges: start -->
<!--[![CRAN status](https://www.r-pkg.org/badges/version/dplyr)](https://cran.r-project.org/package=dplyr)
[![R-CMD-check](https://github.com/tidyverse/dplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/dplyr/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/tidyverse/dplyr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tidyverse/dplyr?branch=main)-->
<!-- badges: end -->

Marine biodiversity data ingestion for OBIS using a reproducible
workflow

## Overview

This package is still under development. To install it, use:

``` r
# install.packages("devtools")
devtools::install_github("iobis/obisdi")
```

## How to use

There are two main ways of using the `obisdi` package: by setting a new
project through RStudio or by using one of the package functions:

### By setting a new project

After you installed the package, you can set up a new project which will
follow the standard of `obisdi`. In RStudio, go to “File \> New Project”

<img style="width: 30%; margin-right: 20px;" src="man/figures/pkg_s1.png">

Choose “New directory”

<img style="width: 30%; margin-right: 20px;" src="man/figures/pkg_s2.png">

Then, select the **Marine Biodiversity data ingestion - OBIS** format

<img style="width: 50%; margin-right: 20px;" src="man/figures/pkg_s3.png">

Supply the directory name (don’t use spaces or special characters!) and
the dataset name.

You can also select your raw data files to be included in the project.
For that use the “Data file” box. At this moment, the following formats
are accepted:

- `zip` files
- `csv` files

In case you supply a `zip` file it should be composed of *only* `csv`
files. You can also convert the files with more than 50MB into
lightweight `parquet` files by checking the box “Convert to parquet”.
This conversion is strongly advised as GitHub does not allow big files
to be uploaded (the limit is 100MB).

You may also skip this step and add your data manually on the “data/raw”
folder. There is also a function in the package for pre-processing data
(like converting to a lightweight format).

<img style="width: 50%; margin-right: 20px;" src="man/figures/pkg_s4.png">

When the project is done, it will open a new session with the two main
files of the project: the `README.md` and the `Rmd` file for data
processing.

<img style="width: 60%; margin-right: 20px;" src="man/figures/pkg_s5.png">

The folder is structured using the package standard and is ready to use

<img style="width: 40%; margin-right: 20px;" src="man/figures/pkg_s6.png">

### Using the function

You can set a new project folder using the function `obisdi_create`,
supplying a path for the new folder.

``` r
obisdi_create(path = "be_marine_data",
              dataset_name = "Belgium marine dataset")
```
