## This script takes in a set of yaml files and image files, constructs and posts tweets/toots.

library(dplyr)
library(yaml)
library(rtoot)
library(stringr)

###############################
## FUNCTIONS 

formatKeywords <- function(keywords){
  kw <- paste("#",keywords, sep ="") ##Add hashtag
  kw <- stringr::str_to_title(kw)  ##First letter uppercase
  kw <- gsub(" ","", kw, ignore.case = T) ##Remove spaces
  kw <- gsub("-","", kw, ignore.case = T) ##Remove hyphen
  kw <- gsub("\\s*\\(.*?\\)","", kw, ignore.case = T) ##Remove text within parenthesis
  kw <- paste(kw, collapse=' ')
  return(kw)
}

###############################
## Before running, check the images in "inbox" to confirm for each image:
## 1. Image contains something relevant to WikiPathways/PathVisio that is easily recognized.
## 2. If there are more than one image for the same paper (see filenames), choose the best one. Only keep both if they are outstanding examples.
## 3. Move any non-relevant images (and accompanying yaml) to skipped subdir.

## Read in yaml files from inbox
files <- list.files("./inbox", pattern = "\\.yml$")

## Run code starting at the if statement below, with rtoot::post_toot line COMMENTED OUT. Check the output in Console (social.df$status) before proceeding. Make sure:
## 1. Keywords are reasonable. If not, delete specific keywords from yaml and run again.
## 2. Article title is correct.
## 3. doi is formatted correctly.

## If all looks good, uncomment rtoot::post_toot line and run again

##TODO: Consider a smarter way of picking a subset of keywords, for example check against a list
## Note: This code assumes the user has reviewed input files and followed instructions above. It does not do any checks for empty fields in the yaml.
if (length(files) != 0){
for (f in files){
  social.df <- as.data.frame(yaml::read_yaml(file.path("./inbox",f)))[1:3,] %>%
    dplyr::group_by(across(c(-keywords))) %>%
    dplyr::summarise(keywords = formatKeywords(keywords)) %>%
    dplyr::mutate(doi = paste0("https://doi.org/",doi)) %>%
    dplyr::mutate(status = as.character(paste(article_title, doi, keywords))) %>%
    dplyr::mutate(image_filename = paste0(pmcid,"__",image_filename)) %>%
    as.data.frame()
  
    print(social.df$status)
    
    ## post toot
    ##rtoot::post_toot(social.df$status, media = file.path("./inbox",social.df$image_filename), alt_text = "article figure")
}
}

###############################
## Move to outbox

for (f in list.files("./inbox", pattern=".jpeg|.yml|.jpg")){
  file.rename(from = file.path("./inbox",f),
            to = file.path("./outbox",f))
}