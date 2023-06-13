# PROJECT_NAME

## About this dataset

<!-- DATASET_METADATA -->
[add a description of your dataset here.]

## Workflow

[source data](<GITHUB-REPO>/tree/master/data/raw) → Darwin Core [mapping script](<GITHUB-REPO>/blob/master/src/obisdi_general.Rmd) → generated [Darwin Core files](<GITHUB-REPO>/tree/master/data/processed)

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
    ├── index.Rmd          : Template for website homepage
    └── static             : Figures and CSS code for the website
```
<!-- Please don't edit below this line -->
<!-- PACKAGE DETAILS -->
<br>

<!--INSTITUTIONAL_DETAILS-->
<!--FUNDING_DETAILS-->

This repository was created using the
`obisdi` package [(download here)](https://github.com/iobis/obisdi/) and was inspired by the [TrIAS Project checklist recipe](https://github.com/trias-project/checklist-recipe/). This README is a direct adaptation of the TrIAS model, with slight changes.
<hr>
<br>  
<img src="src/static/obisdi_logo.png" width="60" align="left" /> OBIS Data Ingestion | Ocean Biodiversity Information System <a href = "https://obis.org/">(obis.org)</a>
