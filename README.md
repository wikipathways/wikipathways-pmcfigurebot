# wikipathways-pmcpaperbot
This repo manages the social media posts for the WikiPathways project

### PubMed Image Query
On the first of each month, `scripts/fetch_pmc.R` queries PMC for any new
figures published in the last month. The script downloads the .jpg and prepares 
a .yml file with metadata for each figure.

### Social Media Posts
When files are added to the `inbox` folder, then `scripts/post_social.R` is
launched to format tweets and toots based on the .yml and .jpg. Processed
data are moved to the `outbox` folder, which is cleared quarterly.

### Manual entries
If you'd like to submit your own published figure to the system, simply use one
of the previous .yml as an example and push to the `inbox` folder.