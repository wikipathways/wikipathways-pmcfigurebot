## This script takes in a set of yaml files and image files and constructs draft posts for QC.

library(yaml)
library(stringr)

###############################
## FUNCTIONS 

formatKeywords <- function(kw){
  if (!is.null(kw)){
    kw <- head(kw,5) ##Only first few
    kw <- paste("#",kw, sep ="") ##Add hashtag
    kw <- stringr::str_to_title(kw)  ##First letter uppercase
    kw <- gsub(" ","", kw, ignore.case = T) ##Remove spaces
    kw <- gsub("-","", kw, ignore.case = T) ##Remove hyphen
    kw <- gsub("\\s*\\(.*?\\)","", kw, ignore.case = T) ##Remove text within parenthesis
    kw <- paste(kw, collapse=' ')
  }
  return(kw)
}

## Read in yaml files from inbox
files <- list.files("figures", pattern = "\\.yml$")
check <- list(approved =  NULL)

for (f in files){
  social.nls <- yaml::read_yaml(file.path("figures",f))
  
  # Check for empty fields and missing files
  jpg_check <- file.exists(file.path("figures",sub("\\.yml","\\.jpg",f)))
  title_check <- nchar(social.nls$article_title) > 5
  doi_check <- startsWith(social.nls$doi, "10")
  if(jpg_check & title_check & doi_check) {
    # Construct status
    social.nls$status <- as.character(paste(
      social.nls$article_title, 
      paste0("https://doi.org/",social.nls$doi),
      formatKeywords(social.nls$keywords)))
    # Construct media
    social.nls$media = paste0(social.nls$pmcid,"__",social.nls$image_filename)
    # Update yaml file
    yaml::write_yaml(social.nls,file.path("figures",f))
    # Update approved list
    check$approved <- append(check$approved, sub("\\.yml","",f))
  }
}

# Write approved.log
writeLines(check$approved, file.path("figures","approved.log"))
