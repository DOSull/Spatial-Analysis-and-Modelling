#### GISC 422 T1 2021
First just make sure we have all the data and libraries we need set up.
```{r message = FALSE}
library(sf)
library(tmap)
library(tidyr)
library(dplyr)

sfd <- st_read('sf_demo.geojson')
sfd <- drop_na(sfd)
sfd.d <- st_drop_geometry(sfd)
```
## Clustering
Whereas dimensional reduction methods focus on the variables in a dataset, clustering methods focus on the observations and the differences and similarities between them. The idea of clustering analysis is to break the dataset into clusters or groups of observations that are similar to one another and different from others in the data.

There is no easy way to define clusters beyond recognising that clusters are the groups of observations identified by a clustering method! Like PCA, clustering analysis depends a great deal on the interpretation of an analyst.

What do we mean by 'similar' and 'different'? We extend the basic idea of distance in Euclidean (two dimensional) space where $d_{ij} = \sqrt{(x_i-x_j)^2+(y_i-y_j)^2}$, that is the square root of the sum of the squared difference in each coordinate to higher dimensions. So if we are in 24 dimensional data space, we take the sum of the squared differences in each of the 24 dimensions (i.e. on each variable) between two observations, add them together and take the square root. Other versions of the basic idea of 'total difference' in attribute values are possible. An important consideration is that all the attributes should be *rescaled* so that the differences in one particular attribute which happens to have large values associated with it don't 'drown out' differences in other variables. A similar concern is that we take care not to include lots of strongly correlated variables in the analysis (sometimes clustering is done on principal component scores for this reason).

### K-means clustering
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
km <- kmeans(sfd.d, 7)
sfd$km7 <- as.factor(km$cluster)

tmap_mode('view')
tm_shape(sfd) +
  tm_polygons(col = 'km7') +
  tm_legend(legend.outside = TRUE)
```

The `kmeans` function does the work, and requires that we decide in advance how many clusters we want (I picked 7 just because... well... SEVEN). We can retrieve the resulting cluster assignments from the output `km` as `km$cluster` which we convert to a `factor`. The numerical cluster number is meaningless, so the cluster number is properly speaking a factor, and designating as such will allow `tmap` and other packages to handle it intelligently. We can then add it to the spatial data and  map it like any other variable.

Try changing the number of clusters in the above code.

The 'quality' of a particular clustering solution is dependent on how well we feel we can interpret it. Measures of the variance within and between clusters can be used to assess quality in a more technical sense and are available from the `kmeans` object produced by the function.

### Hierarchical clustering
K-means is quick and very scalable - it can be successfully applied to very large datasets (see for example the [Landcare LENZ data](https://www.landcareresearch.co.nz/resources/maps-satellites/lenz)). It doesn't however provide much clue about the structure of the clusters it produces. Hierarchical methods do a better job of showing us how observations got assembled into the clusters they are in.

The algorithm in this case looks something like

1. Calculate all the (multivariate) distances between every pair of observations
2. Find the nearest pair of observations and merge them into a cluster
3. For the newly formed cluster determine its distances from all the remaining observations (and any other clusters)
4. Go back to 3 and repeat until all cases are in a cluster

This approach is 'agglomerative' because we start with individual observations. It is possible to proceed in the other direction repeatedly subdividing the dataset into subsets until we get to individual cases, or perhaps until some measure of the cluster quality tells us we can't improve the solution any further. This method is very often used with network data when cluster detection is known as *community detection* (more on that next week).

In *R*, the necessary functions are provided by the `hclust` function
```{R}
hc <- hclust(dist(sfd.d))
plot(hc)
```

Blimey! What the heck is that thing? As the title says it is a *cluster dendrogram*. Starting at the bottom, each individual item in the dataset is a 'branch' of the diagram. At the distance or 'height' at which a pair were joined into a cluster the branches merge and so on up the diagram. The dendrogram provides a complete picture of the whole clustering process.

As you can see, even for this relatively small dataset of only 189 observations, the dendrogram is not easy to read. Again, interactive visualization methods can be used to help with this. However another option is to 'cut the dendrogam' specifying either the height value to do it at, or the number of clusters desired. In this case, it looks like 6 is not a bad option, so...

```{r}
sfd$hc5 <- as.factor(cutree(hc, k = 5))
tm_shape(sfd) +
  tm_polygons(col = 'hc5') +
  tm_legend(legend.outside = TRUE)
```

It's good to see that there are clear similarities between this output and the k-means one (at least there were first time I ran the analysis!)

As with k-means, there are more details around all of this. Different approaches to calculating distances can be chosen (see `?dist`) and various options for the exact algorith for merging clusters are available by setting the `method` option in the `hclust` function. The function help is the place to look for more information. Other clustering methods are also available. A recently popular one has been the DBSCAN family of methods([here is an R package](https://github.com/mhahsler/dbscan)).

Once clusters have been assigned, we can do further analysis comparing characteristics of different clusters. For example

```{r}
boxplot(sfd$Punemployed ~ sfd$hc5, xlab = 'Cluster', ylab = 'Unemployment')
```

Or we can aggregate the clusters into single areas and assign them values based on the underlying data of all the member units:

```{r}
sfd.c <- sfd %>%
  group_by(hc5) %>%              # group_by is how you do a 'dissolve' with sf data
  summarise_if(is.numeric, mean) # this is how you apply a function to combine results
plot(sfd.c, pal = RColorBrewer::brewer.pal(7, "Reds"))
```

## Further reading
In the specific context of demographic data, clustering analysis is often referred to as *geodemographics* and a nice example of this is provided in this paper

Spielman, S. E., and A. Singleton. 2015. [Studying Neighborhoods Using Uncertain Data from the American Community Survey: A Contextual Approach](http://www.tandfonline.com/doi/full/10.1080/00045608.2015.1052335). Annals of the Association of American Geographers 105 (5):1003–1025.

which describes a cluster analysis of the hundreds of thousands of census tracts of the United States. Accompanying data is [available here](https://www.openicpsr.org/openicpsr/project/100235/version/V5/view?path=/openicpsr/100235/fcr:versions/V5/Output-Data&type=folder) and to [visualise here](https://observatory.cartodb.com/editor/5de68840-16ef-11e6-bf4f-0ea31932ec1d/embed), although it's kind of enormous! An interactive map of a classification of London at fine spatial resolution is the [London Open Area Classification](https://maps.cdrc.ac.uk/#/geodemographics/loac11/default/BTTTFFT/10/-0.1500/51.5200/).

Although geodemographics ia a very visible example of cluster-based classification, exactly the same methods are applicable to other kinds of data, such as physical, climate or other variables (and these methods are the basis of remote sensed imagery classificaion).

Classification and clustering is an enormous topic area with numerous different methods available, many of them now falling under the rubric of machine-learning.

OK... on to [the assignment](05-assignment-multivariate-analysis.md).
