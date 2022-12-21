# retrieve secret from environment
secret <- Sys.getenv("TEST_SECRET")

# check that it was retrieved
if (!is.null(secret))
  sprintf("I got the secret %i characters long!", nchar(secret))
