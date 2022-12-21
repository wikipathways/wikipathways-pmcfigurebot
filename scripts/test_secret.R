# retrieve secret from environment
secret <- Sys.getenv("SECRET_MSG")

# check that it was retrieved
if (!is.null(secret))
  print("I got the secret!")
