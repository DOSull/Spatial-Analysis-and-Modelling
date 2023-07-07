#### GISC 422 T2 2023
First just make sure we have all the data and libraries we need set up.
```{r message = FALSE}
library(sf)
library(tmap)
library(dplyr)
library(tidyr)
library(RColorBrewer)

sfd <- st_read('sf_demo.geojson')
sfd <- drop_na(sfd)
sfd.d <- st_drop_geometry(sfd)
```
# Dimension reduction methods
There are a number of dimensional reduction methods. 

The most widely known is probably *principal component analysis* (PCA), so we will look at that. We've already seen in the above exploration of the data, that many of the variables in this dataset are correlated. If you're not convinced about that, try `plot(sfd)` again to see maps of some of the variables. It's clear that many of the variables exhibit similar distributions. This *non-independence* of the variables means that there is the potential to use weighted combinations of various variables to stand in for the full dataset. With any luck, the weighted sums will be interpretable, and we'll only need a few of them, not all 24 of them to get an overall picture of the data.

The mathematics of this are pretty complicated. They rely on analysis of the correlation matrix of the dataset (we already saw this above when we ran the `cor` function), specifically the calculation of the matrix *eigenvectors* and corresponding *eigenvalues*. Roughly speaking (very roughly) each eigenvector is a direction in multidimensional space along which the data set can be projected. By ordering the eigenvectors in descending order from that along which the data has the greatest variance, to that with the least (using the eigenvalues), and ensuring that the eigenvectors are perpendicular to one another, we can obtain a smaller set of *components*, which capture most of the variance in our original data.

This [interactive graphic](https://www.joyofdata.de/public/pca-3d/) provides a nice illustration of the idea, just imagine it in 24 dimensions and you'll be there!

OK... so how does this work in practice? It's actually pretty easy. The function `princomp` in R performs the analysis.
```{r}
sfd.pca <- princomp(sfd.d, cor = TRUE)
```

The results are stored in the `sfd.pca` object. We can get a summary
```{r}
summary(sfd.pca)
```

which tells us the total proportion of all the variance in the dataset accounted for by the principal components starting from the most significant and working down. These results show that about 2/3 of the variance in this dataset (0.3510 + 0.2206 + 0.0956) can be accounted for by only the first three principal components (to see this graphically, use `screeplot(sfd.pca)`. 

What are the principal components? Each is a *weighted sum of the original variables*, which we can examine in the `loadings` component of the result. 
```{r}
sfd.pca$loadings
```

These show us for each component how they can be calculated from the original variables by summing weighted combinations of them. High (>0) weights are 'positive loadings' and high (<0) weights are negative loadings. In the table, we can see for example, that component 1 loads negatively on income and 'white alone' and 'some college', suggesting that high values of this category are associated with poorer mixed ethnic non-white areas. 

Determining the interpretation of each component is based on which variable weights heavily positive or negative on each component in this table.

A plot which sometimes helps is the biplot produced as below
```{r}
biplot(sfd.pca, pc.biplot = TRUE, cex = 0.65)
```

This helps us to see which variables weight similarly on the components (they point in similar directions) and also which observations (i.e. which census tracts in this case) score highly or not on each variable. It is important to keep in mind when inspecting such plots that they are a reduction of the original data (that's the whole point) and must be interpreted with caution.

If we want to see the geography of components, then we can extract components from the PCA analysis `scores` output.
```{r}
sfd$PC1 <- sfd.pca$scores[, "Comp.1"]
tmap_mode('view')
tm_shape(sfd) +
  tm_polygons(col = 'PC1', palette = "PRGn") +   # call it PC1 for principal component 1
  tm_legend(legend.outside = TRUE)
```

You can make a new spatial dataset from the original spatial data with only the component scores, like this:
```{r}
sfd.pca.scores <- sfd %>%
  dplyr::select(geometry) %>%
  bind_cols(as.data.frame(sfd.pca$scores))
plot(sfd.pca.scores, pal = brewer.pal(9, "Reds"))
```

Related techniques to PCA are *factor analysis* and *multidimensional scaling* (MDS), although the last of these is also closely related to the second broad class of methods, classification which we will look at... [so let's do that now](04-classification-and-clustering.md).
