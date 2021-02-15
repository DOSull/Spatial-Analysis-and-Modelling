#### GISC 422 T1 2020
# Multivariate data
In this document, we look at the general problem of dealing with highly multivariate data, which in later documents we will tackle using tools from the [*R* `tidyverse`](02-the-r-tidyverse.md), and techniques broadly categorised as [dimensional reduction](03-dimensional-reduction.md) and [classification](04-classification-and-clustering.md).

## Libraries
As usual, we need to load some libraries. If any are missing from your installation, install them in the usual way.
```{r}
library(sf) # for spatial data
library(tmap) # simple mapping
library(MASS) # multivariate methods
library(scatterplot3d) # 3D plots
library(tidyr)
library(ggplot2) # nice plots - we will learn more about this later in the session
```

## Data
As a vehicle for this exploration we use a demographic dataset for San Francisco, assembled by [Luc Guillemot](http://lucguillemot.com/) and demonstrated on this [web page](http://lucguillemot.com/bayareageodemo/). These data have been tidied up quite nicely and thus provide a good exploration for this analysis. The materials including the data for this week's session are in [this zip file](multivariate-analysis.zip?raw = true).
```{r}
sfd <- st_read('sf_demo.geojson')
```

In the usual way, **have a bit of an explore**, using `View`, `plot`, `summary` and so on. 

Here's another option, which makes a boxplot of all the variables in the dataset. Don't worry too much about how I made this, focus for now on the complexity of the data.
```{r}
boxplot(as.list(st_drop_geometry(sfd)), horizontal = T, par(las = 1, mar = c(3,10,2,1)))
```

It's a bit fiddly to make, because I had to change the figure margins using `par(mar = ...)`to accommodate the variables names, and `par(las = 1)` to orient the labels the right way round.

Most of the variables are expressed as percents (actually proportions), although `density` has been standardised so that the highest population density is 1 and all the other values are relative to that number.

The important thing is that this is clearly a complicated dataset. There may be things to learn about San Francisco in 2014 from it, but we'll have to work at extracting that information.

## Maps
One option is mapping the data. For example
```{r}
tm_shape(sfd) +
  tm_polygons(col = 'PCunemployed') +
  tm_legend(legend.outside = T)
```

Remember that you can use `tmap_mode('view')` if you'd like a web map for orientation. You should explore some of the other variables, until you get an overall sense of the dataset. You can also, of course simply plot the whole thing with
```{r}
plot(sfd)
```

# Multivariate approaches
There are two broad categories of approach in mutlivariate analysis (other than statistical modelling, which focuses on one 'dependent variable'). We look at each of these in turn in this session, but first we need to get a handle on what is meant be 'data dimensions'.

## High dimensional data and the problems they give us
There are 23 variable in this dataset (not including the geometry). We can look at any two of them relative to each other, fairly easily. It might not look that simple, but we'll examine this in more detail later in the session.
```{r}
ggplot(sfd) +
  geom_point(aes(x = PCownerOccUnits, y = PCmarriedCouple))
```

If we want to see all the relationships, among all the variables, we can do correlation analysis among all the variables, but it's pretty overwhelming:
```{r}
cor(st_drop_geometry(sfd), use = 'complete.obs')
```

You will notice that we have had to specify how to handle 'NA' or missing values, and also had to tell the functions to ignore the geometry. It's probably easier to clean the data and get rid of these problems. We'll drop the NA's first, then make a new copy of the data table, without the geometry.
```{r}
sfd <- drop_na(sfd)
sfd.d <- st_drop_geometry(sfd)
```

I did it in this order that the two datasets, with and without the geometry retain the same set of rows in the same order. This will be useful if we need to put them back together again later. Where possible, I will use `sfd` but if a function can't cope with a dataset that has geographical objects associated, then I will use `sfd.d` instead. A useful overview of a dataset is sometimes obtained with the `plot` command. Let's try that
```{r}
plot(sfd.d)
```

R has attempted to make scatter plots of every possible pair of variables in the dataset. It may take a while, but it will generally be successful in making such a plot, it's just very difficult to read it! Another option is a parallel coordinate plot
```{r}
parcoord(sfd.d)
```

The complexity of plots like this has led to the development of interactive scientific visualization tools that make it possibly to interact with a plot such as that above, and which may assist in gain insights. The latest tool in this area is the D3 toolkit, See for example [this example](https://bl.ocks.org/jasondavies/1341281), which also has good spatial tools. These are examples of *exploratory data analysis* which we have already seen in spatial form in *GeoDa*.

However, for now we are going to proceed in a different way either by trying to *reduce the dimensions* of the problem, or by *classifying the observations*.

## Data dimensions
Roughly speaking, we can consider each variable in a dataset to be a *dimension* of the data. This can be interpreted fairly literally, in the sense that each *numeric* variable allows the data to be plotted along an axis. Let's see that with the first three variables in this dataset. For now I will use the basic *R* plot functions to do this, since we haven't learned yet about `ggplot`.
```{r}
# one varible, one dimension
stripchart(sfd$density, vertical = T)
# two variables, two dimensions
plot(sfd$density, sfd$medianYearBuilt)
# there variables, three dimensions
scatterplot3d(sfd$density, sfd$medianYearBuilt, sfd$PConeUnit)
```

But now what? How can we simultaneously visualize a fourth, or fifth, or even 24th dimension? We could use symbol size and symbol colour. To get a sense of how this might work, here are two variables in space, one in colour, and one in size, this time using `ggplot` to handle the complications
```{r}
ggplot(sfd) +
  geom_point(aes(x = density,
                 y = medianYearBuilt,
                 colour = PConeUnit,
                 size = PCownerOccUnits), alpha = 0.5)
```

This works up to a point, but there's a lot going on in even that simple plot, and perhaps a better approach is to reduce the number of dimensions in the data.

We'll look at that in a little bit. But for now, we need to grapple with the *R* `tidyverse` and its associated plotting library `ggplot2` to make handling all the data manipulations a little bit easier. We'll do that in the [next document](02-the-tidyverse.md).
