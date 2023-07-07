#### GISC 422 T2 2023
# Multivariate data
In this document, we look at the general problem of dealing with highly multivariate data, which in later documents we will tackle using tools from the [*R* `tidyverse`](02-the-r-tidyverse.md), and techniques broadly categorised as [dimensional reduction](03-dimensional-reduction.md), [classification](04-classification-and-clustering.md), and (next week) statistical modelling.

## Libraries
As usual, we need to load some libraries. If any are missing from your installation, install them in the usual way.
```{r message = FALSE}
library(sf) # for spatial data
library(tmap) # simple mapping
library(tidyr)
library(ggplot2) # nice plots - we will learn more about this later in the session
library(RColorBrewer) # nice colour palettes for the default mapping
```

## Data
As a vehicle for this exploration we use a demographic dataset for San Francisco, assembled by [Luc Guillemot](http://lucguillemot.com/) and demonstrated on this [web page](http://lucguillemot.github.io/bayareageodemo/). These data have been tidied up quite nicely and thus provide a good exploration for this analysis. The materials including the data for this week's session are in [this zip file](multivariate-analysis.zip?raw = true).
```{r}
sfd <- st_read('sf_demo.geojson')
```

In the usual way, **have a bit of an explore**, using `View`, `plot`, `summary` and so on. 

Here's another option, which makes a boxplot of all the variables in the dataset. Don't worry too much about how I made this, focus for now on the complexity of the data.
```{r}
boxplot(as.list(st_drop_geometry(sfd)),  # drop the geometry otherwise the boxplot function complains
        horizontal = TRUE,               # plot boxes horizontally
        par(las = 1, cex = 0.65,         # label alignment and font size
            mar = c(3, 10, 2, 1)))       # plot margins
```

It's a bit fiddly to make, because I had to change the figure margins using `par(mar = ...)`to accommodate the variables names, and `par(las = 1)` to orient the labels the right way round.

Most of the variables are expressed as proportions, although `density` has been standardised so that the highest population density is 1 and all the other values are relative to that number.

The important thing is that this is clearly a *complicated* dataset. There may be things to learn about San Francisco in 2014 from it, but we'll have to work at extracting that information.

## Maps
One option is mapping the data. For example
```{r}
tm_shape(sfd) +
  tm_polygons(col = 'Punemployed', title = "Unemployed") +
  tm_legend(legend.outside = T)
```

Remember that you can use `tmap_mode('view')` if you'd like a web map for orientation. You should explore some of the other variables, until you get an overall sense of the dataset. You can also, of course simply plot the whole thing (or as much of it as `sf` lets you!) with
```{r}
plot(sfd, 
     pal = brewer.pal(9, "Reds"), # the default palette is difficult to parse
     lwd = 0.15)                  # finer lines make the maps easier to read
```

# Multivariate approaches
There are various approaches to mutlivariate analysis, two of which we look at in this session, but first we need to get a handle on what is meant by 'data dimensions'.

## High dimensional data and the problems they give us
There are 23 variable in this dataset (not including the geometry). We can look at any two of them relative to each other, fairly easily. The plot below might not look that simple (we'll consider in more detail how it's made later in the session), but conceptually it is straightforward: one variable in the dataset is assigned to two spatial dimensions, horizontal _x_, and vertical _y_.
```{r}
ggplot(sfd) +
  geom_point(aes(x = PownerOccUnits, y = PmarriedCouple))
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

Note that I drop the NAs first, and then drop the geometry in this order so that the two datasets, with and without the geometry retain the same set of rows in the same order. This is useful if we need to put them back together again later. Where possible, I will use `sfd` (with the geometry) but if a function can't cope with a dataset that has geographical objects associated, then I will use `sfd.d` instead. 

A useful overview of a dataset is sometimes obtained with the `plot` command. Let's try that
```{r}
plot(sfd.d)
```

R has attempted to make scatter plots of every possible pair of variables in the dataset. It can take a while, but it will generally be successful in making such a plot. However, it can be very difficult to read! Other options (such as the boxplot above) are possible. Another example from the `GGally` package is the `ggcorr` function:
```{r}
library(GGally)
ggcorr(sfd.d, hjust = 1, name = "Correlation", layout.exp = 4, cex = 3)
```

Another option is a _parallel coordinate plot_. 
```{r}
library(MASS) # this provides a primitive parallel coordinate plot
parcoord(sfd.d)
```

Here each row in the data table is plotted as a 'string' connecting the values of that row on each attribute, where the attributes are a series of vertical axes. 

Unfortunately, it's not particularly easy to make sense of this as a static plot! We can improve things a bit by using colour, but unfortunately that is itself complicated and involves another function from `GGally`. Here's the code, so you can see it in action:
```{r}
pcp <- ggparcoord(sfd, columns = 1:24, groupColumn = "density", scale = "globalminmax", alphaLines = 0.5) + 
  scale_colour_distiller(palette = "Spectral") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
pcp
```

Colouring the lines makes it a little bit easier to see the relationships among variables, although it is still not easy!

The complexity of plots like these has led to the development of *interactive scientific visualization tools* that make it possible to interact with a plot such as that above, and which may assist in gaining insights. One quick way to do this in R is using the `plotly` package's ability to make an interactive version of most `ggplot` objects such as `pcp` above:
```{r message = FALSE}
library(plotly)
ggplotly(pcp, tooltip = c("density", "variable", "value"))
```

This is still not great, and really we need to consider advanced toolkits for interactive scientific visualization. See for example [this example](https://bl.ocks.org/jasondavies/1341281), in D3 which also has good spatial tools. These are all examples of *exploratory data analysis* which we have already seen in spatial form in *GeoDa*.

However, those methods would make for a completely different course! 

For now we are going to proceed in a different way by trying to *reduce the dimensions* of the problem, or by *classifying the observations*.

Before doing that here is a quick recap of the data dimension problem.

## Data dimensions
Roughly speaking, we can consider each variable in a dataset to be a *dimension* of the data. This can be interpreted fairly literally, in the sense that each *numeric* variable allows the data to be plotted along an axis. Let's see that with the first three variables in this dataset. To begin I will use the basic *R* plot functions to do this, since we haven't learned yet about `ggplot`.
```{r}
# one varible, one dimension
stripchart(sfd$density, vertical = T, main = "density")
# two variables, two dimensions
plot(sfd$density, sfd$medianYearBuilt, xlab = "density", ylab = "median year built")
# there variables, three dimensions
library(scatterplot3d)
scatterplot3d(sfd$density, sfd$medianYearBuilt, sfd$PoneUnit, xlab = "density", ylab = "median year built", zlab = "proportion single unit")
```

But now what? How can we simultaneously visualize a fourth, or fifth, or even 24th dimension (as in the `sfd` dataset)? We could also use symbol size and symbol colour. To get a sense of how this might work, here are two variables in space, one in colour, and one in size, this time using `ggplot` to handle the complications
```{r}
ggplot(sfd) +
  geom_point(aes(x = density,
                 y = medianYearBuilt,
                 colour = PoneUnit,
                 size = PownerOccUnits), alpha = 0.5) +
  scale_colour_distiller(palette = "Spectral")
```

As we saw above all this visualization trickery works up to a point, but there's a lot going on in even a simple 4 variable plot, and perhaps a better approach is to address the problem directly by  *reducing the number of dimensions in the data*.

We'll look at that in a little bit. But first, we need to remond ourselves about the *R* `tidyverse` and its associated plotting library `ggplot2` to make handling all the data manipulations a little bit easier. We've already [seen this back in week 2](../making-maps-in-r/02-data-wrangling-in-r.md) but revisit it in the [next document](02-the-tidyverse.md).
