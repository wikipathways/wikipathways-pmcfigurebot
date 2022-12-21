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
  kw <- gsub(" ","", kw, ignore.case = T) ##remove spaces
  kw <- paste(kw, collapse=' ')
  return(kw)
}

###############################
## Read in yaml files from inbox

files <- list.files("./inbox", pattern = "\\.yml$")

## for testing
#testfile = "PMC9616486__gr4_lrg.yml"

##TODO: Consider a smarter way of picking a subset of keywords, for example check against a list

for (f in files){
  social.df <- as.data.frame(yaml::read_yaml(file.path("./inbox",f)))[1:3,] %>%
    dplyr::group_by(across(c(-keywords))) %>%
    dplyr::summarise(keywords = formatKeywords(keywords)) %>%
    dplyr::mutate(doi = paste0("https://doi.org/",doi)) %>%
    dplyr::mutate(status = as.character(paste(article_title, doi, keywords))) %>%
    as.data.frame()
  
  print(social.df$status)
    
  ## post toot
  ##TODO: Authentication
  #Authentication
  #auth_setup()
  rtoot::post_toot(status, media = file.path("./inbox",social.df$image_filename), alt_text = "article figure")
}
 
###############################
## Move to outbox

for (f in list.files("./inbox", pattern=".jpeg|.yml")){
  file.rename(from = file.path("./inbox",f),
            to = file.path("./outbox",f))
}


