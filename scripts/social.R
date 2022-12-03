## This script takes in a set of yaml files and image files, constructs and posts tweets/toots.
library(dplyr)
library(yaml)
install.packages("rtoot")
library(rtoot)

## Read in yaml files from inbox
setwd("./inbox")
files <- list.files(pattern = "\\.yml$")

## for testing
#testfile = "PMC9616486__gr4_lrg.yml"

yamlreader <- function(x){
  yamlfile <- read_yaml(x)
}

pubslist <- lapply(files, yamlreader)
pubs.df <- as.data.frame(do.call(rbind, pubslist))

## Construct tweet / toot
social.df <- pubs.df %>%
  dplyr::mutate(doi = paste("https://",doi, sep="")) %>%
  dplyr::select(-"citation") %>%
  dplyr::select(-"journal")

social.df <- social.df %>%
  dplyr::mutate(status = paste(article_title,doi,keywords, sep = "\n"))

## Post to social
## Mastodon
