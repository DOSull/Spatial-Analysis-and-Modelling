# Multivariate data
In this notebook, we look at the two broad categories of descriptive statistical approaches to dealing with highly multivariate data *dimension reduction* and *classification*.

## Libraries
```{r}
library(sf)
library(tmap)
library(MASS)
library(ggplot2) # you might need to install this
library(tidyr)
library(scatterplot3d) # you may need to install this
```

## Data
As a vehicle for this exploration we use a demographic dataset for San Francisco, assembled by [Luc Guillemot](http://lucguillemot.com/) and nicely demonstrated on this [web page](http://lucguillemot.com/bayareageodemo/). These data have been tidied up quite nicely and thus provide a good exploration for this analysis.

The materials for this week's session are in [this zip file](week-10.zip).

```{r}
sfd <- st_read('sf_demo.geojson')
```

In the usual way, have a bit of an explore, using `View`, `plot`, `summary` and so on. Here's another option, whih makes a boxplot of all the variables in the dataset.

```{r}
boxplot(as.list(st_drop_geometry(sfd)), horizontal=T, par(las=1, mar=c(3,10,2,1)))
```

It's a bit fiddly to make, because I had to change the figure margins using `par(mar=...)` to accommodate the variables names.

Most of the variables are expressed as percents (actually proportions), although `density` has been standardised so that the highest population density is 1 and all the other values are relative to that number.

The important thing is that this is clearly a complicated dataset. There may be things to learn about San Francisco in 2014 from it, but we'll have to work at extracting that information.

## Maps
One option is mapping the data. For example

```{r}
tmap_mode('plot')
tm_shape(sfd) +
  tm_polygons(col='PCunemployed') +
  tm_legend(legend.outside=T)
```

You should explore some of the other variables, until you get an overall sense of the dataset.

# Multivariate approaches
There are two broad categories of approach in mutlivariate analysis (other than statistical modelling, which focuses on one 'dependent variable'). We look at each of these in turn below.

## Dimension reduction
There are 23 variable in this dataset (not including the geometry). We can look at any two of them relative to each other, very easily.

```{r}
plot(sfd[,c(4,10)])
```

Drat! Geography when I don't want it. Try that again:

```{r}
plot(st_drop_geometry(sfd)[, c(4,10)])
```

If we want to see all the relationships, we can do correlation analysis among all the variables, but it's pretty overwhelming.

```{r}
cor(st_drop_geometry(sfd), use='complete.obs')
```

You will notice that in the above cases we have had to specify how to handle 'NA' or missing values, and also had to tell the functions to ignore the geometry. It's probably easier to clean the data and get rid of these problems. We'll drop the NA's first, then make a new copy of the data table, without the geometry.

```{r}
sfd <- drop_na(sfd)
sfdd <- st_drop_geometry(sfd)
```

I did it in this order that the two datasets, with and without the geometry retain the same set of rows in the same order. This will be useful if we need to put them back together again later. A useful overview of a dataset is sometimes obtained with the `plot` command. Let's try that

```{r}
plot(sfdd)
```

R has attempted to make scatter plots of every possible pair of variables in the dataset. In fact it has successfully made such a plot, it's just very difficult to read it. Another option is a parallel coordinate plot

```{r}
parcoord(sfdd)
```

The complexity of plots like this has led to the development of interactive scientific visualization tools that make it possibly to interact with a plot such as that above, and which may assist in gain insights. The latest tool in this area is the D3 toolkit, See for example [this example](https://bl.ocks.org/jasondavies/1341281), which also has good spatial tools. These are examples of *exploratory data analysis* which we have already seen in spatial form in *GeoDa*.

However, for now we are going to proceed in a different way be trying to *reduce the dimensions* of the problem

### Data dimensions
Roughly speaking, statisticians consider each variable in a dataset to be a *dimension* of the data. This can be interpreted fairly literally, in the sense that each *numeric* variable allows the data to be plotted along an axis. Let's see that with the first three variables in this dataset...

```{r}
# one varible, one dimension
stripchart(sfdd[, 1], vertical=T)
# two variables, two dimensions
plot(sfdd[, 1:2])
# there variables, three dimensions
scatterplot3d(sfdd[, 1:3])
```

But now what? How can we simultaneously visualize a fourth, or fifth, or even 24th dimension? We could use symbol size and symbol colour. To get a sense of how this might work, here are two variables in space, one in colour, and one in size

```{r}
ggplot(sfdd) +
  geom_point(aes(x=density,
                 y=medianYearBuilt,
                 colour=PConeUnit,
                 size=PCownerOccUnits), alpha=0.5)
```

This works up to a point, but there's a lot going on in even that simple plot, and perhaps a better approach is to reduce the number of dimensions in the data.

## Dimension reduction methods
There are a number of dimensional reduction methods. The most widely known is probably *principal component analysis* (PCA), and we will look that now. We've already seen in the above exploration of the data, that many of the variables in this dataset are correlated. If you're not convinced about that, try `plot(sfd)` again to see maps of some of the variables. It's clear that many of the variables exhibit similar distributions. This *non-independence* of the variables means that there is the potential to used weighted combinations of various variables to stand in for the full dataset. With any luck, the weighted sums will be interpretable, and we'll only need a few of them, not 24 of them to get an overall picture of the data.

The mathematics of this are pretty complicated. They rely on analysis of the correlation matrix of the dataset (we already saw this above when we ran the `cor` function), specifically the calculation of the matrix *eigenvectors* and corresponding *eigenvalues*. Roughly speaking (very roughly) each eigenvector is a direction in multidimensional along which the data set can be projected. By ordering the eigenvectors from that along which the data has the greatest extent to that with the least (using the eigenvalues), and ensuring that the eigenvectors are perpendicular to one another, we obtain a set of components, which capture the variance in our original data.

This [interactive graphic](https://www.joyofdata.de/public/pca-3d/) provides a nice illustration of the idea, just imagine it in 24 dimensions and you'll be there!

OK... so how does this work in practice. It's actually pretty easy. The function `princomp` in R performs the analysis.

```{r}
sfpca <- princomp(sfdd, cor=T)
```

The results are stored in the `sfpca` object. We can get a summary

```{r}
summary(sfpca)
```

which tells us the total proportion of all the variance in the dataset accounted for by the principal components starting from the most significant and working down. These results show that about 2/3 of the variance in this dataset can be accounted for by only three principal components. What are the principal components? Each is a weighted sum of the original variables, which we can examine in the `loadings` of the result.

```{r}
sfpca$loadings
```

Determining the interpretation of each component is based on which variable weights heavily positive or negative on each component in the loadings table.

A plot which sometimes helps is the biplot produced as below

```{r}
biplot(sfpca, pc.biplot=T, cex=0.5)
```

This helps us to see which variables weight similarly on the components (they point in similar directions) and also which observations (i.e. which census tracts in this case) score highly or not on each variable. It is important to keep in mind when inspecting such plots that they are a reduction of the original data (that's the whole point) and must be interpreted with caution.

If we want to see the geography of components, then we can extract components from the PCA analysis `scores` output.

```{r}
sfd$PC1 <- sfpca$scores[,1]
tm_shape(sfd) +
  tm_polygons(col='PC1') +
  tm_legend(legend.outside=T)
```

Related techniques to PCA are *factor analysis* and *multidimensional scaling* (MDS), although the last of these is also closely related to the second broad class of methods we will look at... so let's do that now.

## Clustering
Whereas dimensional reduction methods focus on the variables in a dataset, clustering methods focus on the observations and the differences and similarities between them. The idea of clustering analysis is to break the dataset into clusters or groups of observations that are similar to one another and different from others in the data.

There is no easy way to define clusters beyond recognising that clusters are the groups of observations identified by a clustering method. Like PCA, clustering analysis depends a great deal on the interpretation of an analyst.

What do we mean by 'similar' and 'different'? We extend the basic idea of distance in Euclidean (two dimensional) space where $d_{ij}=\sqrt{(x_i-x_j^2)+(y_i-y_j)^2}$, that is the square root of the sum of the squared difference in each coordinate to higher dimensions. So if we are in 24 dimensional data space, we take the sum of the squared differences in each of the 24 dimensions (i.e. on each variable) between two observations, add them together and take the square root. Other versions of the basic idea of 'total difference' in attribute values are possible. An important consideration is that all the attributes be rescaled so that the differences in one particular attribute which happens to have large values associated with it don't 'drown out' differences in other variables. A similar concern is that we take care not to include lots of strongly correlated variables in the analysis (sometimes clustering is done on principal component scores for this reason).

*** K-means clustering
One common clustering approach is k-means clustering. The algorithm is pretty simple:

1. Decide on the number of clusters you want, call this *k*
2. Choose *k* cluster centres
3. Assign each observation to its nearest cluster centre
4. Calculate the mean centre of each cluster and move the cluster centre accordingly
5. Go back to 3 and repeat, until the cluster assignments stop changing

Here's an [illustration of this working](https://kkevsterrr.github.io/K-Means/) to help with following the description above.

It's important to realise that k-means clustering is non-deterministic, as the choice of intial cluster centres is often random, and can affect the final assignment arrived at.

So here is how we accomplish this in R.

```{r}
km <- kmeans(sfdd, 7)
clusters <- fitted(km, method='classes')
sfd[, 'c7'] <- clusters
tm_shape(sfd) +
  tm_polygons(col='c7', palette='cat') +
  tm_legend(legend.outside=T)
```

The `kmeans` function does the work, and requires that we decide in advance how many clusters we want (I picked 7 just because...). We retrieve the resulting cluster assignments using the `fitted` function, and map it like any other variable&mdash;remembering that it is a categorical variable, hence the `cat` palette specification.

Try changing the number of clusters in the above.

The 'quality' of a particular clustering solution is dependent on how well we feel we can interpret it. Measures of the variance within and between clusters can be used to assess quality in a more technical sense and are available from the `kmeans` object produced by the function.

### Hierarchical clustering
K-means is quick and very scalable - it can be successively applied to very large datasets (see for example the [Landcare LENZ data](https://www.landcareresearch.co.nz/resources/maps-satellites/lenz)). It doesn't provide much clue about the structure of the clusters it produces. Hierarchical methods do a better job of showing us how observations got assembled into the clusters they are in.

The algorithm in this case looks something like

1. Calculate all the (multivariate) distances between every pair of observations
2. Find the nearest pair of observations and merge them into a cluster
3. For the newly formed cluster determine its distances from all the remaining observations (and any other clusters)
4. Go back to 3 and repeat until all cases are in a cluster

This approach is 'agglomerative' because we start with individual observations. It is possible to proceed in the other direction repeatedly subdividing the dataset into subsets until we get to individual cases, or perhaps until some measure of the cluster quality tells us we can't improve the solution any further. This method is very often used with network data when cluster detection is known as *community detection* (more on that next week).

In R, the necessary functions are provided by the `hclust` function

```{R}
hc <- hclust(dist(sfdd))
plot(hc)
```

Blimey! What the heck is that thing? As the title says it is a *cluster dendrogram*. Starting at the bottom each individual item in the dataset is a 'branch' of the diagram. At the distance or 'height' at which a pair were joined into a cluster the branches merge and so on up the diagram. The dendrogram provides a complete picture of the whole clustering process.

As you can see, even for this relatively small dataset of only 189 observations, the dendrogram is not that easy to read. Again, interactive visualization methods can be used to help with this. However another option is to 'cut the dendrogam' specifying either the height value to do it at, or the number of clusters desired. In this case, it actually looks like 7 is not a bad option, so...

```{r}
sfd[, 'hc7'] <- cutree(hc, k=7)
tm_shape(sfd) +
  tm_polygons(col='hc7', palette='cat') +
  tm_legend(legend.outside=T)
```

It's good to see that there are clear similarities between this output and the k-means one (at least there were first time I ran the analysis!)

As with k-means analysis, there are more details around all of this. Different approaches to calculating distances can be chosen (see `?dist`) and various options for the exact algorith for merging clusters are available by setting the `method` option in the `hclust` function. The function help is the place to look for more information.

Once clusters have been assigned, we can do further analysis comparing characteristics of different clusters. FOr example

```{r}
boxplot(sfd$PCunemployed ~ sfd$hc7, xlab='Cluster', ylab='Unemployment')
```

Or we can aggregate the clusters into single areas and assign them values based on the underlying data of all the member units:

```{r}
sfdc <- aggregate(sfd, by=list(sfd$hc7), mean)
plot(sfdc)
```

## Further reading
In the specific context of demographic data, clustering analysis is often referred to as *geodemographics* and a nice example of this is provided in this paper

Spielman, S. E., and A. Singleton. 2015. [Studying Neighborhoods Using Uncertain Data from the American Community Survey: A Contextual Approach](http://www.tandfonline.com/doi/full/10.1080/00045608.2015.1052335). Annals of the Association of American Geographers 105 (5):1003–1025.

which describes a cluster analysis of the hundreds of thousands of census tracts of the United States. Accompanying data is [available here](https://www.openicpsr.org/openicpsr/project/100235/version/V5/view?path=/openicpsr/100235/fcr:versions/V5/Output-Data&type=folder), although it's kind of enormous! An interactive map of a classification of London at fine spatial resolution is the [London Open Area Classification](https://maps.cdrc.ac.uk/#/geodemographics/loac11/default/BTTTFFT/10/-0.1500/51.5200/).

Although geodemographics ia a very visible example of cluster-based classification, exactly the same methods are applicable to other kinds of data, such as physical, climate or other variables.

# Assignment
I have assembled some [demographic data for Aotearoa New Zealand](nz-2193-cau-2013.zip) (you will need to unzip this file) from the 2013 census at the Area Unit level. Use these to conduct multivariate data exploration using any of the approaches discussed here. Based on your analysis put together a report on some aspect of the demographics of the country that you think may be of interest (you can reduce the area of interest to a smaller local area if this seems appropriate). You may feel that there is a need to reduce the number of data attributes in the analysis for various reasons (topic of interest, balancing the clustering analysis, etc).

In any case, your report should show clear evidence of having explored the data closely using the many tools we have seen this semester so far (no need to use all of them, and it's fine to focus on only the ones from this week, if you wish).

Prepare your report in R-Markdown and run it to produce a final output PDF or Word document for submission (this means I will see your code as well as the outputs!) Avoid any outputs that are just long lists of data (like this file includes), as these are not very informative.

Submit to the dropbox provided on Blackboard.
