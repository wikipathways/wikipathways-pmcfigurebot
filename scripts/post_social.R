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

##TODO: Consider a smarter way of picking a subset of keywords, for example check against a list

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
    #rtoot::post_toot(social.df$status, media = file.path("./inbox",social.df$image_filename), alt_text = "article figure")
}

# ##Test
# rtoot::post_toot(social.df$status, media = file.path("inbox",social.df$image_filename) , alt_text = "article figure")
###############################
## Move to outbox

for (f in list.files("./inbox", pattern=".jpeg|.yml")){
  file.rename(from = file.path("./inbox",f),
            to = file.path("./outbox",f))
}


