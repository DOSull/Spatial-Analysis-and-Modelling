# Exploring spatial data and building simple statistical models
This week we are going to do something a bit different. I think it is useful to take stock of where you have got to and spend the session exploring a couple of datasets, without too much direction from me. This will mean making more use of the R help, and using tools you have already learned. You should focus particularly on interactively mapping the data, tidying it up as you go and understanding the overall patterns that may be present.

## Datasets
I have assembled a couple of datasets

- **Party vote results from the 2017 New Zealand general election** and the **Index of Multiple Deprivation** developed by Dan Exeter and his team at University of Auckland
- Some Los Angeles Airbnb data, as made available by the [Inside Airbnb website](http://insideairbnb.com)

You will find all these in the [week-9.zip](week-9.zip?raw=True) file.

I have no particular expectation that you will discover anything in either setting.

## R packages
I would expect you to be using at least the following packages

```{r}
library(sf) # for reading the spatial data
library(tmap) # for mapping
library(dplyr) # for tidying and sorting the data
```

### Other tools
For the New Zealand data in particular, you will probably want to combine the data spatially. There are tools for doing this in R, which I encourage you to explore, particularly `aggregate`, `st_join` and possibly also `st_centroid` and `st_simplify`. I would encourage you to explore these before resorting to QGIS or ArcGIS. I think you will find the R tools impressively straightforward, even if the help is confusing at times.

## Data exploration
You should aim to get a good understanding of the distribution (both statistical and spatial) in the two datasets. Use `hist`, `boxplot` and `plot` to do this. When a dataset is spatial, the `plot` function makes maps whether you want it to or not, so you might consider `st_drop_geometry` so you can see the more useful scatterplot matrix that is the default for a plain dataframe. The `cor` function is useful for examining correlations among variables.

From a mapping perspective, it is likely that `tmap` will be all you need. You may find particular use for the `view` mode in the New Zealand data case, where seeing what is going on in the cities is otherwise really difficult.

Don't be afraid to remove outliers and variables from the data, so you can get to underlying patterns. Doing this can involve either the `[` indexing methods, or the `filter` and `select` tools from `dplyr`. It is a good idea to develop some familiarity with both.

# Simple models
Simple regression models are baked into the heart of R, using the `lm` function.  This is not a statistics class, so all the variations and details of regression modelling are beyond our scope. I would encourage you to spend a little time exploring, but it's likely you need to take other classes if this is something you plan on doing a lot of! I suspect that for these datasets you will conclude that regression models offer only limited insights.
