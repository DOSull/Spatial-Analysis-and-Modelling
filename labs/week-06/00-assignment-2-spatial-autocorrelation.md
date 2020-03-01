#### GISC 422 T1 2020
# **Assignment 2** Spatial autocorrelation in R and GeoDa
This assignment walks you through applying spatial autocorrelation measures, specifically Moran's index of spatial autocorrelation in both its local and global forms.

These instructions show how these analyses can be performed in *R*, although many of you may prefer to complete the assignment using *GeoDa* which is installed on the lab machines and also free to download and install from [this website](http://geodacenter.github.io/download.html). Operation of *GeoDa* is relatively self-explanatory whereas performing these analyses in *R* using the `spdep` package is not, so you are on your own in *GeoDa*, but should find these instructions a useful overview of the methods helpful for either platform.

## Materials
Materials for this assignment are in [this zip file](week-6.zip?raw=true). Unpack these to a folder, and make sure to set it as the working directory for your R session.

## Required packages
We need a bunch of these, so load them all now. 
```{r}
library(sf)
library(tmap)

library(dplyr) # for manipulating datasets
```

And also, the package that provides the spatial autocorrelation methods we need
```{r}
library(spdep)
```

## The data
OK... now we are ready to load the data for this lab. This is a super-set of the data we previously used for the point pattern analysis lab, which includes the TB data for the old Auckland City, but extended to a wider region, and also with the additional inclusion of contemporary ethnicity data from the 2006 Census.

```{r}
ak <- st_read("akregion-tb-06.shp")
```

One of the advantages of the `sf` type is that plotting it provides maps of *all* the attributes, so let's look at that.
```{r}
plot(ak)
```

The maps are a little small, but this is a nice overview. The legibility is improved somewhat if you set the plot parameter `lwd` (line width) to something less than 1. We can also `select` columns to plot (say the ethnicity percentages) by specifying their column numbers.

```{r}
plot(select(ak, 6:9), lwd=0.35)
```

Remember that we can also make maps of specific attributes as follows
```{r}
map <- tm_shape(ak) + 
  tm_fill(col="EUR_P_06", palette='Blues') + # add colour fill
  tm_borders(col='gray', lwd=0.5) # add borders to the polygons
map
```
Remember that if we want an interactive web map, we can change the `tmap` mode to `"view"`
```{r}
tmap_mode("view")
map
```

For now, we probably don't need interactive web maps, so change back to `"plot"` mode and make sure everything is still good to go

```{r}
tmap_mode("plot")
map
```

## Back to spatial autocorrelation
The functions discussed in this section and the remainder of these instructions are provided by the `spdep` package. This is an older package, which can work with `sf` objects but with some difficulty, so it is easier to make a `sp` package compatible `SpatialPolygonsDataFrame` object from our data for some of the operations to follow. We'll call this `akp` and will use the original `ak` object where it is more convenient, but work with `akp` when needed.

```{r}
akp <- as_Spatial(ak)
```

Since `akp` and `ak` are derived from the same underlying data and retain the same *order* of entries in their data tables, we shouldn't run into any problems.

The main reason for making this object is that the key functions of `spdep` require the construction of *neighbourhoods* for each polygon in the dataset, on which the autocorrelation calculations will be based. The most basic neighbourhood construction is based on adjacency and is generated using the `poly2nb()` function. This is how it works

```{r}
nb <- poly2nb(akp, row.names=ak$AU_NAME, queen=TRUE)
```

We can inspect what we just did, with the `summary()` function

```{r}
summary(nb)
```

We can see here that we made a neighbourhood object that has 1612 adjacency links between polygons, and we also get a summary of the number of polygons that have each number of neighbours, along with some information about the least and most connected locations.

To get a better idea what is going on we can map these

```{r}
plot(akp, col="lightgrey", lwd=0.5, border='white')
plot(nb, coordinates(akp), col='red', lwd=0.5, cex=0.35, add=T)
```

At this point, you should experiment with the `poly2nb` function (what happens if you set `queen=FALSE`?).

### Other neighborhood construction methods
It is possible to construct neighbourhoods on other bases, such as for example, the k nearest neighbours approach. This is unfortunately where the `spdep` package shows its age, because doing so is fiddly. Here is how it works, just as an example, that you are welcome to explore further.

```{r}
ak_k5 <- knearneigh(coordinates(akp), k=5)
nb_k5 <- knn2nb(ak_k5)
plot(akp, col="lightgrey", lwd=0.5, border='white')
plot(nb_k5, coordinates(akp), cex=0.35, lwd=0.5, col='red', add=T)
```

Or another alternative is to use a distance criterion
```{r}
nb_d2500 <- dnearneigh(coordinates(akp), d1=100, d2=2500)
plot(akp, col="lightgrey", lwd=0.5, border='white')
plot(nb_d2500, coordinates(akp), cex=0.35, lwd=0.5, col='red', add=T)
```

You can probably see here why I say that the `spdep` functions are a bit obscure to work with.  Anyway, let's return to doing the analysis based on simple adjacency, as recorded in the `nb` object we made before.

## Back to spatial autocorrelation
Something to pay attention to from here forward is that many of the Moran's index methods run into problems if an area has no neighbours. To tell functions to ignore this problem (which exists in our dataset) we set the option `zero.policy=T` in many of the function calls in the remained of these instructions.

Another quirk of the `spdep` package is that it requires the neighbourhood information in a particular format to work, and this is *not* the format that the various neighbourhood construction methods produce. To get the right format we must convert the neighbourhood information to a `listw` object

```{r}
wl <- nb2listw(nb, style="W", zero.policy=T)
summary(wl, zero.policy=T)
```

As you can see (and reassuringly!) this object has exactly the same characteristics as the neighbourhood object we made before.

## Finally! Moran's index
After all that, the moment of truth is very simple. We can calculate the value of Moran's index. The permutation approach discussed in lectures is the most appropriate way to put some kind of statistical limits on the result for interpretive purposes. This is invoked by `moran.mc()`

```{r}
moransI <- moran.mc(ak$ASI_P_06, wl, nsim=999, zero.policy=T)
moransI
```

And we can also easily plot this, showing the distribution of simulated results relative to the actual.

```{r}
plot(moransI)
```

An even more useful plot is the scatter plot of the data values (*x*-axis) against the local mean values (*y*-axis), which can be produced using `moran.plot()`

```{r}
moran.plot(ak$ASI_P_06, wl, zero.policy=TRUE)
```

What do you think the gray circle represents in the plot?

## Local Moran's index
Finally, we can also calculate the local version of Moran's *I*.

```{r}
localm <- localmoran(ak$ASI_P_06, wl, zero.policy=T)
head(localm)
```

The index values are in the `Ii` column, and we also get expected values, variances, Z scores and an associated set of p values in the `Pr` column. These are what form the basis of the widely used LISA plots. These are much more conveniently produced in *GeoDa*, but for completeness I wrote simple functions to produce them in *R*. To run them, you need to import and run the script file `moran_plots.R`

```{r}
source('moran_plots.R')
```

This makes available a `moran_cluster_map()` function

```{r}
moran_cluster_map(ak, 'ASI_P_06', wl)
```

and a `moran_significance_map()` function

```{r}
moran_significance_map(ak, 'ASI_P_06', wl)
```

# Go and give *GeoDa* a try!
I've already said that *GeoDa* is easier and more friendly, so I suggest you go and play with it now!

Once you have a reasonable idea what you are up to, then complete the assignment as set out below.

# Assignment 2 questions & Deliverables
You should first work through the instructional materials, also exploring the capabilities of *R*. You need to develop a reasonable understanding of what is going on.

You don't need to understand all the intricacies of various bits of code, but you should assure yourself that you know how to make maps of any particular variable, how to build the neigbourhood object required for Moran's I analysis, how to find the Moran's statistic for a specified variable, and how to produce local Moran's cluster and significance maps (which may be easier in *GeoDa*).

Once you feel that you have got a handle on things, take a look at the questions below and put together a short report including results and maps produced either in *R* or in *GeoDa* that answer the questions. Your report should be in PDF format, and the file name should include your own name to assist in marking. Upload your completed report to the dropbox provided on blackboard by **28 April**. Your report shouldn't need more than about 500 words, but will need a few maps and/or other charts.

### Q1. Determine the Moran’s I statistic for each of the four population groups. Which is *least* clustered based on these results? Suggest a simple reason why this might be the case.

### Q2. Perform a univariate local Moran's I analysis for the TB_RATE variable. Based on this analysis, you should be able to identify two general areas of clustering of the tuberculosis cases. By checking back to population distribution maps, which population groups are these clusters most associated with? Suggest any theories for why there might be such an association?

### Q3. Based on working in *R* and also in *GeoDa* on these analyses suggest one advantage that each platform has for performing these kinds of analysis.
