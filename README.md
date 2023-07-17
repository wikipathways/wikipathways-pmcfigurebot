# pmcfigurebot
Query figures indexed by PubMed Central and collect metadata

## PubMed Image Query
The GitHub Action is configured to run `scripts/fetch_pmc.R` on demand and
monthly (by default) in order to query PMC for any new
figures published since the last run. The script downloads .jpg files and 
prepares a .yml file with metadata for each figure and its parent paper.

#### Configure your query
Enter your query terms and an optional date information in `query_config.yml`

**terms** - Enter either a list of terms to be used in a default AND query, or a 
valid query string, *e.g., (network OR PPI) AND cytoscape*

**last_run** - (Optional) Date of the last run. Auto-filled by script. Uses prior
month if blank; overriden by `date_range`. Format: %Y/%m/%d, *e.g., 2022/10/29*

**date_range** - (Optional) Either a list of two dates (%Y/%m/%d) or a valid
date string, *e.g,. 2022/10/01[PUBDATE]:2023/01/01[PUBDATE]*
Important: If used, this field will override the use of `last_run`

## Usage for social media posting
- The first two workflows, "Fetch relevant article figures monthly" and "Check posts for bugs and content" run monthly on the 1st of the month.
- Check "approved.log" (in figures) and compare the number of figures to the number of figures in figures dir. If the log file has fewer figures, check the corresponding yml for the ones that are excluded to see why they were excluded. For example, it might be because some fields are missing or because its a preprint. If the exclusion seems to be in error, one can manually update the approved.log and manually compile fields "status" and "media" in the corresponding yml.
- Once approved.log is complete, run step 3 "Moves approved posts to inbox for future posting".
- Check that the relevant yamls and jpgs were moved to inbox and then run step 4 "Make social media posts from staged content".

## Use Cases
The collected data files can be used in a variety of ways, including to generate
social media posts, newsletters, feeds, annual reports, etc. See examples in the
`scripts` folder.

## Limitations
* Only accesses the first page of results from PMC with a maximum of 100 figures.
