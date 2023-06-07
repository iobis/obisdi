# PROJECT_NAME

## About this dataset

[add a description of your dataset here.]

## Workflow

[source data]({link to the source data}) → Darwin Core [mapping script]({link to HTML or RMD of the mapping script}) → generated [Darwin Core files]({link to processed data folder})

## Additional metadata

[add any additional information relevant for your project.]

## Published dataset

* [Dataset on the IPT]({once published, link to the published dataset})
* [Dataset on OBIS]({once published, link to the published dataset})

## Repo structure

Files and directories indicated with `GENERATED` should not be edited manually.

```
├── README.md              : Description of this repository
├── LICENSE                : Repository license
├── PROJECT_FOLD_NAME.Rproj : RStudio project file
├── .gitignore             : Files and directories to be ignored by git
│
├── data
│   ├── raw                : Source data, input for mapping script
│   └── processed          : Darwin Core output of mapping script GENERATED
│
├── docs                   : Repository website GENERATED
│
└── src
    ├── dwc_mapping.Rmd    : Darwin Core mapping script
    ├── _site.yml          : Settings to build website in docs/
    └── index.Rmd          : Template for website homepage
```
<!-- Please don't edit below this line -->
<!-- PACKAGE DETAILS -->
<br>
<!--INSTITUTIONAL_DETAILS-->
<!--FUNDING_DETAILS-->
This repository was created using the `obisdi` package [(download here)]() and was inspired by the [TrIAS Project checklist recipe]("https://github.com/trias-project/checklist-recipe"). This README is a direct adaptation of the TrIAS model, with slight changes.
<br>  
<img style="float: left; margin-right: 20px;" src="src/static/obisdi_logo.png" width="60"><hr> OBIS Data Ingestion | Ocean Biodiversity Information System [(obis.org)](https://obis.org/)
