# wikipathways-pmcpaperbot
This repo manages the social media posts for the WikiPathways project

## PubMed Image Query
The GitHub Action is configured to run `scripts/fetch_pmc.R` on demand and
monthly (by default) in order to query PMC for any new
figures published since the last run. The script downloads .jpg files and 
prepares a .yml file with metadata for each figure and its parent paper.

### Configure your query
Enter your query terms and an optional date information in `query_config.yml`

**terms** - Enter either a list of terms to be used in a default AND query, or a 
valid query string, *e.g., (network OR PPI) AND cytoscape*

**last_run** - (Optional) Date of the last run. Auto-filled by script. Uses prior
month if blank; overriden by `date_range`. Format: %Y/%m/%d, *e.g., 2022/10/29*

**date_range** - (Optional) Either a list of two dates (%Y/%m/%d) or a valid
date string, *e.g,. 2022/10/01[PUBDATE]:2023/01/01[PUBDATE]*
*IMPORTANT: If used, this field will override the use of `last_run`*

## Social Media Posts
When files are added to the `inbox` folder, then `scripts/post_social.R` is
launched to format tweets and toots based on the .yml and .jpg. Processed
data are moved to the `outbox` folder, which is cleared quarterly.

## Manual entries
If you'd like to submit your own published figure to the system, simply use one
of the previous .yml as an example and push to the `inbox` folder.