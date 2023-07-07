#### GISC 422 T2 2023
# Spline interpolation
This is where `gstat` runs out of steam, and where I suggest you take a look at possibilities in QGIS where the GRASS and SAGA toolboxes, or in ArcGIS where the Spatial Analyst and Geostatistical Analyst have tools for various kinds of interpolation.

There is an option in *R* for this too (in fact, there are many), but spline interpolation falls under the rubric of general interpolation techniques that are generally not geographical and so the interfaces to spatial data are primitive in the packages supporting spline interpolation.

One example is the `fields` package, which provides a fairly painless way to run a spline interpolation (it also does kriging and a lot of other things besides, but we've already done that... so we'll not go there again.)

`fields` seems not to work with the `terra` raster data types, so we revert to using the older `raster` package instead.

## Reload our datasets and required libraries
```{r}
library(raster)

controls_xyz <- read.csv("data/controls-xyz.csv")[1:100, ]
sites_raster <- raster("data/sites-raster.tif")
```

And now load `fields` (you may have to install it first...)

```{r}
library(fields)
```

`fields` doesn't really know about geographical data it just wants coordinates and values, so we've loaded the 'xyz' version of the control points data and will provide the necessary columns from this to the spline model constructor `Tps`.

```{r}
spline <- Tps(controls_xyz[, c("x", "y")], controls_xyz$z)
```

We interpolate this to our desired raster output layer like this

```{r}
splined <- raster::interpolate(sites_raster, spline)
```

And we can take a look in the usual ways

```{r}
persp(splined, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

### Kriging in `fields`
Kriging is also available, although we are mainly looking at `fields` for the spline interpolation. Here's what it looks like if you are interested. It's quite slow as the tool is doing a lot of things at once and attempting to optimise fits and so on.

```{r}
spatial_model <- spatialProcess(controls_xyz[, c("x", "y")], controls_xyz$z)
```

Interpolate it to a raster

```{r}
kriged <- raster::interpolate(sites_raster, spatial_model)
```

And inspect. The result can end up being a lot nicer that `gstat`'s effort...

```{r}
persp(kriged, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```
You can also get details of the model used

```{r}
spatial_model
```


Back to [trend surfaces and kriging](05-trend-surfaces-and-kriging.md) | On to [other R packages](07-other-r-packages.md)
