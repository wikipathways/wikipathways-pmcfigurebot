## This script takes in a set of yaml files and image files, constructs and posts tweets/toots.

library(dplyr)
library(yaml)
install.packages("rtoot")
library(rtoot)
install.packages("tidyverse")
library(tidyverse)

###############################
## Read in yaml files from inbox
files <- list.files("./inbox", pattern = "\\.yml$")

## for testing
#testfile = "PMC9616486__gr4_lrg.yml"

yaml.df <- data.frame()

##TO-DO: Consider a smarter way of picking a subset of keywords, for example check against a list

for (f in files){
  yaml <- read_yaml(f)
  image_filename <- yaml[[1]]
  article_title <- yaml[[2]]
  citation <- yaml[[3]]
  doi <- paste("https://doi.org/",yaml[[4]], sep="")
  journal <- yaml[[5]]
  keywords <- formatKeywords(yaml$keywords[1:3]) ##store only first three and format
  yaml.df <- rbind(yaml.df, data.frame(image_filename, article_title, doi, keywords))
}
   
###############################
## Construct tweet / toot

social.df <- yaml.df %>%
  dplyr::mutate(status = as.character(paste(article_title, doi, keywords, sep = "\n")))

###############################
## Post to social (Mastodon)

##TO-DO: Authentication
#Authentication
#auth_setup()

#Loop through all yaml/image file
for (i in 1:nrow(social.df)){
  print(social.df$status)
  
  ## post toot
  #post_toot(status, media = social.df$image_filename, alt_text = "network image")

}

###############################
## Move to outbox

for (f in list.files("./inbox", pattern=".jpeg|.yml")){
  file.rename(from = file.path("./inbox",f),
            to = file.path("./outbox",f))
}

################################

formatKeywords <- function(keywords){
  kw <- paste("#",keywords, sep ="") ##Add hashtag
  kw <- str_to_title(kw)  ##First letter uppercase
  kw <- gsub(" ","", kw, ignore.case = T) ##remove spaces
  kw <- paste(kw, collapse=' ')
  return(kw)
}
