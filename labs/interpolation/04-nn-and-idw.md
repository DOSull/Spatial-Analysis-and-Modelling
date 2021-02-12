#### GISC 422 T1 2021
# Near neighbour and inverse-distance weighted interpolation
Run this first to make sure all the data and packages you need are loaded. If any data are missing you probably didn't make them in one of the previous instruction pages.

```{r}
library(sf)
library(tmap)
library(raster)
library(dplyr)
library(gstat)

volcano <- raster("data/maungawhau.tif")
names(volcano) <- "data/height"

controls <- st_read("data/controls.gpkg")
sites <- st_read("data/sites-sf.gpkg")
sites_raster <- raster("data/sites-raster.tif")
```

## Inverse-distance weighted interpolation
These two methods are very similar, and IDW is actually *more general* so we'll show it first.

As with all the `gstat` methods we use the `gstat::gstat` function to make a statistical model, and then apply it using the `raster::interpolate` function.

```{r}
fit_IDW <- gstat(                 # makes a model 
  formula = height ~ 1,           # The column `height` is what we are interested in
  data = as(controls, "Spatial"), # using sf but converting to sp, which is required
  set = list(idp = 2)
)
```

The `idp` setting here is the inverse-distance power used in the calculation. Once you understand what is going on in general, you should experiment with this to see how the outcome datasets change.

Having made the model (called `fit_IDW`) we pass it to the `predict` function to obtain interpolated values at the locations specified by `sites` and then finally convert this to a raster for visualization.

```{r}
interp_pts_IDW <- predict(fit_IDW, sites)
interp_IDW <- rasterize(as(interp_pts_IDW, "Spatial"), sites_raster, "var1.pred")
names(interp_IDW) <- "height"
```

And then we can view the outcome in the usual ways. 
```{r}
interp_IDW
```
Notice that the name of the variable here is `var1.pred` (i.e., predicted value of variable 1). We can change that to something we like better if we wish using `names(interp_IDW) <- "height"` or whatever, if we feel the need.

We can map the result

```{r}
tm_shape(interp_IDW) + 
  tm_raster(pal = "-BrBG", style = "cont") +
  tm_legend(outside = TRUE)
```

```{r}
persp(interp_IDW, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

### Nearest neighbour
The basic model above can be parameterised differently to make a simple nearest neighbour (i.e. proximity polygon) interpolation:

```{r}
fit_NN <- gstat( # makes a model 
  formula = height ~ 1,
  data = as(controls, "Spatial"), 
  nmax = 1, 
)

# and interpolate like before
interp_pts_NN <- predict(fit_NN, sites)
interp_NN <- rasterize(as(interp_pts_NN, "Spatial"), sites_raster, "var1.pred")
names(interp_NN) <- "height"

# and display it
persp(interp_NN, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

We can confirm this matches with proximity polygons like this:
```{r}
tm_shape(interp_NN) + 
  tm_raster(pal = "-BrBG", style = "cont") + 
  tm_shape(st_voronoi(st_union(controls))) + 
  tm_borders(col = "yellow", lwd = 0.5) + 
  tm_shape(controls) + 
  tm_dots() + 
  tm_legend(outside = TRUE)
```

Back to [data prep](03-preparing-for-interpolation.md) | On to [trend surfaces and kriging](05-trend-surfaces-and-kriging.md)