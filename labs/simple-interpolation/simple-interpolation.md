#### GISC 422 T1 2020
# Simple interpolation methods in *R*
You'll need to [download the data](simple-interpolation.zip?raw=true) and unzip them. The zip file also contains these instructions in an RMarkdown format.

Load some needed libraries. If any fail to load, then install them in the usual way.
```{r}
library(maptools) # for various conversions of formats
library(spatstat) # for making proximity polygons and doing IDW
library(sf)
library(tmap) # mapping library
library(raster) # handling raster data
library(dplyr) # for making samples
```

## Some sample data
Load a dataset that we will use to explore the methods.
```{r}
heights <- st_read("maungawhau.shp")
```

This is a grid of control points at 10 metre spacing for Maungawhau (Mt. Eden) in Auckland. It was originally digitised by Ross Ihaka at University of Auckland and is a dataset that comes with R in the form of a matrix of height values as the `volcano` dataset. You can get an idea of what you are looking at in a couple of ways.

One is a perspective view of the built in matrix dataset called `volcano`
```{r}
persp(volcano, expand=0.35, theta=30, phi=35, col=rgb(0, .75, .1, .65), lwd=0.5)
```

Experiment with some of the parameters of this plot, to see how they affect the view. `theta` and `phi` are the parameters that will alter the perspective.

However, we won't be using that version of the data, we'll be working with the shapefile points we just read in. We can confirm these look the same, by making a map.

```{r}
tm_shape(heights) +
  tm_dots(col='height', size=0.1, pal='-BrBG') +
  tm_legend(legend.outside=T)
```

Since this is the *end result* we are looking for from any interpolation we run, we need to turn this into a set of *control point* data. We will do this by taking a random sample of points from all the values, using the `sample_n` function

```{r}
controls <- sample_n(heights, size=100) # this is a subset of the heights
tm_shape(controls) +
  tm_dots(col='height', size=0.1, pal='-BrBG') +
  tm_legend(legend.outside=T)
```

Note that every time you run the above cell, you will get a different random sample of the data. Think about how large you might want the sample of points to be (controlled with the `size` parameter) to get a reasonable representation of the underlying surface (experiment with this a little). Also note that it would be very unusual, especially with elevation data for the control points to be a random sample. It is much more likely that surveyors will collect elevation data for key locations.

## Two simple deterministic interpolation methods
To figure out what follows I drew heavily on the Bivand et al. book, and also on [this useful source](https://mgimond.github.io/Spatial/interpolation-in-r.html).

### Proximity polygons
The idea behind proximity polygons is that we simply assign to every location the value associated with the nearest control point. To do this we will make a Voronoi tessellation of the control points. We can do this with `st_` functions in the `sf` package. First we need a bounding box for the analysis, which we will make from the original heights data
```{r}
bb <- heights %>%
  st_union() %>% ## combine heights into a multipoint
  st_bbox() %>% ## get the bounding box
  st_as_sfc() ## convert it to a polygon
bb
```

Here is a processing pipeline that will do the Voronoi operation on the control points.
```{r}
voronoi <- controls %>%
  st_union() %>% ## combine into a multipoint
  st_voronoi() %>% ## perform Voronoi operation
  st_cast() %>% ## convert to polygons
  st_as_sf() %>% ## convert to features
  st_intersection(bb) %>% ## clip to the bounding box
  st_join(controls) # %>% ## join the heights
voronoi
```
Make sure you understand each of the steps in this processing pipeline. As with most geospatial tools, `sf` can be finicky about the different data types at each step, so there is more to this sequence, than one might expect. For example trying to apply `st_voronoi` to a set of points without applying `st_union` first will result in 100 separate Voronoi polygons for one point each, an operation which makes no sense. We must union the points into a MULTIPOINT so that the Voronoi operation makes sense.

Now we map to see what we got
```{r}
tm_shape(voronoi) +
  tm_polygons(col='height', pal='-BrBG', border.col='black', lwd=0.15) +
  tm_legend(legend.outside=T) +
  tm_shape(controls) +
  tm_dots(size=0.05)
```

Fairly obviously, this method doesn't do very well with a small number of control points. Try going back and making a larger set of control points to see how many you need before the results are acceptable.

### Inverse distance weighted interpolation
An interpolation option in `spatstat` is IDW. To use this, we need a `ppp` set of control points to work with.
```{r}
controls.pp <- as(as_Spatial(controls), 'ppp') # note that this conversion is provided by maptools
```

It's a simple matter to perform IDW with these.
```{r}
idw.ss <- spatstat::idw(controls.pp, power=2)
```

That's it!

Now to plot it... we need to make this into a raster with which we can associate spatial reference information.
```{r}
r.ss <- raster(idw.ss)
crs(r.ss) <- st_crs(heights)$proj4string
```

And then we can plot it using `tmap` with the `tm_raster` function. Note that the various steps in the process result in the data attribute in the raster layer having the very generic name `layer`.
```{r}
tm_shape(r.ss) +
  tm_raster(col='layer', n=10, palette='-BrBG', title="IDW heights") +
  tm_shape(controls) +
  tm_dots(size=0.05) +
  tm_legend(legend.outside=T)
```

A better way to see the limitations of this interpolation is a perspective view, when what is going on should be very clear.
```{r}
persp(r.ss, expand=0.35, theta=30, phi=35, col=rgb(0, .75, .1, .65), lwd=0.5)
```

### IDW interpolation retaining spatial properties
To do IDW in a less quick and dirty way we can use the `gstat` package. We'll see more of this next week, when we use its more advanced options.
```{r}
library(gstat)
```

You'll get a message warning you that the `idw()` function from `spatstat` has now been 'masked' by a similarly named function in `gstat`.

In the code-chunk that follows, you'll see how we use `as_Spatial` to convert our `sf` data to the old `sp` formats, which `gstat` functions require.
```{r}
# we make an empty spatial pixels dataset from
# the original dataset we read in
result <- as(as_Spatial(heights), 'SpatialPixelsDataFrame')

# Interpolate by IDW function from gstat, with power 2
idw.gs <- gstat::idw(height ~ 1, as_Spatial(controls), newdata=result, idp=2.0)
persp(as.matrix(idw.gs), expand=0.35, theta=30, phi=35, col=rgb(0, .75, .1, .65), lwd=0.5)
```
And mapping the results as before:
```{r}
# For mapping make a raster object
r.gs <- raster(idw.gs)
crs(r.gs) <- st_crs(heights)$proj4string

# Note that this time around gstat names the raster attribute var1.pred
tm_shape(r.gs) +
  tm_raster(col='var1.pred', n=10,palette = "-BrBG", title="IDW heights") +
  tm_legend(legend.outside=T) +
  tm_shape(controls) +
  tm_dots(size=0.05)
```

### Splines
#### Using `MBA::mba.surf`
One library we can use for splines is `MBA`. (You will need to install this.)
```{r}
library(MBA)
```

Below is an example of how the `mba.surf` function can be used to perform spline interpolation. You should take a look at the help for this function to see if you can figure out what's going on.
```{r}
xy <- st_coordinates(controls)
xyz <- data.frame(x=xy[,1],
                  y=xy[,2],
                  z=controls$height)


spline.mba <- mba.surf(xyz, no.X=61, no.Y=87, n=87/61, m=1, extend=T, sp=T)$xyz.est

r.spline.mba <- raster(spline.mba)
crs(r.spline.mba) <- st_crs(heights)$proj4string

p <- persp(r.spline.mba, expand=0.35, theta=30, phi=35, col=rgb(0, .75, .1, .65), lwd=0.5)
points(trans3d(xy[,1], xy[,2], controls$height, p), col='purple', pch=20, cex=0.6)
```

```{r}
tm_shape(r.spline.mba) +
  tm_raster(col='z', n=10, palette = "-BrBG", title="mba.surf spline heights") +
  tm_legend(legend.outside=T) +
  tm_shape(controls) +
  tm_dots(size=0.05)
```

#### Using `akima::interp`
Yet another tool that can perform spline interpolation is found in the `akima` package (again you may have to install this.)
```{r}
library(akima)
```

The function is called `interp`.  Again, it has a few settings.
```{r}
xy <- st_coordinates(controls)
xyz <- data.frame(x=xy[,1],
                  y=xy[,2],
                  z=controls$height)

spline.akima <- interp(xyz$x, xyz$y, xyz$z, nx=61, ny=87, extrap=T, linear=F)

p <- persp(spline.akima, expand=0.35, theta=30, phi=35, col=rgb(0, .75, .1, .65), lwd=0.5)
points(trans3d(xy[,1], xy[,2], controls$height, p), col='purple', pch=20, cex=0.6)

r.spline.akima <- raster(spline.akima)
crs(r.spline.akima) <- st_crs(heights)$proj4string
```

And again, mapping it
```{r}
tm_shape(r.spline.akima) +
  tm_raster(col='layer', n=10, palette='-BrBG', title='akima interp spline heights') +
  tm_legend(legend.outside=T) +
  tm_shape(controls) +
  tm_dots(size=0.05)
```
