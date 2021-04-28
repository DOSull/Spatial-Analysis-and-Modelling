#### GISC 422 T1 2021
# Assignment 4 Geodemographics in Wellington
I have assembled some demographic data for Wellington from the 2018 census at the Statistical Area 1 level in a file called `welly.gpkg` which you should find in the folder with this week's materials. The data were obtained [here](https://datafinder.stats.govt.nz/layer/104612-2018-census-individual-part-1-total-new-zealand-by-statistical-area-1/)). Descriptions of the variables are in [this table](sa1-2018-census-individual-part-1-total-nz-lookup-table.csv).

Use these data to conduct multivariate data exploration using any of the approaches discussed here. Think of it as producing a descriptive report of the social geography of Wellington focusing on some aspect of interest (but **not** a single dimension like ethnicity, race, family structure, or whatever, in other words, work with the multivariate, multidimensional aspect of the data).

There are lots more variables than you need, so you should reduce the data down to a selection (use `dplyr::select` for this). Think about which variables you want to retain before you start!

When you have a reduced set of variables to work with (but not too reduced... the idea is to demonstrate handling high-dimensional data), then you should also standardise the variables in some way so that they are all scaled to a similar numerical range. You can do this with `mutate` functions. You will probably need to keep the total population column for the standardisation!

Once that data preparation is completed, then run principal components analysis and clustering analysis (either method) to produce maps that shed some light on the demographic structure of the city as portrayed in the 2018 Census.

Include these maps in a report that shows clear evidence of having explored the data using any tools we have seen this week (feel free to include others from earlier weeks if they help!)

Prepare your report in R Markdown and run it to produce a final output PDF or Word document (I prefer it if you can convert Word to PDF format) for submission (this means I will see your code as well as the outputs!) Avoid any outputs that are just long lists of data, as these are not very informative (you can do this by prefixing the code chunk that produces the output with ````{r, results = FALSE}`.

Submit your report to the dropbox provided on Blackboard by **24 May**.
