## This script takes in approved yaml files  and posts tweets/toots.

library(yaml)
library(rtoot)

## Get token
toot_token <- structure(
    list(
      bearer = Sys.getenv("MASTODON_TOKEN"),
      type = "user",
      instance = "fosstodon.org"
    ),
    class = "rtoot_bearer"
  )

## Read in approved yaml files from inbox
yaml_files <- list.files("inbox", pattern = "\\.yml$")

## Just post the first one from inbox
y <- yaml_files[1] 
social.nls <- yaml::read_yaml(file.path("inbox",y))
rtoot::post_toot(status = social.nls$status, 
                 media = file.path("inbox",social.nls$media), 
                 alt_text = "article figure", token = toot_token)

## Move yml and jpg to outbox
file.rename(from = file.path("inbox",y),
            to = file.path("outbox",y))
j <- sub("\\.yml","\\.jpg",y)
file.rename(from = file.path("inbox",j),
            to = file.path("outbox",j))
