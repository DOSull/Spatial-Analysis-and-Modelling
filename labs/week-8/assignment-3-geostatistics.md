# Assignment 3: Geostatistics in *R*
<hr>

## THIS IS NOT THE 2020 EDITION OF THESE INSTRUCTIONS!
**Instructions need to be updated to use `sf` and `tmap` and friends.**

<hr>

In this document we will look at performing geostatistical interpolation (commonly known as kriging) using the `gstats` package in R.

You'll need to [download the data](week-8.zip?raw=true) and unzip them.

We need a bunch of libraries (as usual).

```{r}
# For handling and mapping spatial data
library(sf)
library(tmap)
library(tmaptools)
library(RColorBrewer)

# For geostatistics and other spatial manipulations
library(sp)
library(gstat)
library(raster)
```

## The data we will work with
We will work with some old weather data for Pennsylvania on 1 April 1993. It is surprisingly hard to find well behaved data for interpolation, and these work. I tried some local Wellington weather data, but they were (maybe unsurprisingly), not well-behaved...

```{r}
pa <- st_read('pa.shp')
paw <- st_read('paw19930401.shp')
```

## Inspect the data
Make simple maps to get some idea of things. The code below will do the rainfall results. Change it to view other variables. I've added as a scale bar so you have an idea of the scale. If you switch the map mode to `'view'` with `tmap_mode('view')` you can see it in context on a web map.

```{r}
tm_shape(pa) +
  tm_polygons() +
  tm_shape(paw) +
  tm_bubbles(col='rain_mm', palette='Blues') +
  tm_legend(legend.outside=T) +
  tm_scale_bar(position=c('right', 'TOP')) +
  tm_layout(main.title='Pennsylvania weather, 1 April 1993')
```

## Geostatistical interpolation
Again, I have drawn heavily on [this resource](https://mgimond.github.io/Spatial/interpolation-in-r.html), to put together the instructions below.

Before we start, we have to convert the simple features (`sf`) data to `SpatialPointsDataFrame` data, because... well, because like many other analysis packages, `gstat` is happier working with the older `sp` formats.

```{r}
paws <- as_Spatial(paw)
```

We have to add `X` and `Y` columns to the `weather_sp` data table for the `gstat` functions to make use of.

```{r}
paws$X <- coordinates(paws)[,1]
paws$Y <- coordinates(paws)[,2]
```

### An output grid
We also need an output grid of locations where we will perform the interpolation. To make this we use the `makegrid` function.

```{r}
output <- as.data.frame(makegrid(paws, "regular", cellsize=5))
names(output) <- c('X', 'Y')
coordinates(output) <- c('X', 'Y')
gridded(output) <- T
fullgrid(output) <- T
proj4string(output) <- proj4string(paws)
```

### Trend surfaces
Trend surfaces are a special kind of linear regression where we use the spatial coordinates of the control points as predictors of the values measured at those points. The function that is fitted is a polynomial expression in the coordinates. For example a degree 2 polynomial is of the form <i>z = b<sub>0</sub> + b_<sub>1</sub>x + b_<sub>2</sub>y + b_<sub>3</sub>xy + b4x^<sup>2</sup> + b_5y^<sup>2</sup></i>.

```{r}
tr2 <- krige(rain_mm ~ 1, paws, output, degree=2)
r <- raster(tr2)

r
```

We can map this as usual... although, for some reason, using `tm_raster()` seems to prevent the polygon layer from imposing its extent on the map view. I haven't got to the bottom of this problem yet, which is why I have changed map mode here to `view`. If you decide later to compile the R markdown file to a PDF for assignment submission, then you should make sure to produce the maps in `plot` mode.

```{r}
# change this if producing a PDF
tmap_mode('view')

tm_shape(r) +
  tm_raster(palette='Blues', title='Predicted rainfall (mm)') +
  tm_shape(pa) +
  tm_polygons(alpha=0) +
  tm_shape(paws) +
  tm_bubbles(col='rain_mm', palette='Blues') +
  tm_legend(legend.outside=T)
```

You can also see the trend surface in a 3D view.

```{r}
persp(r, theta=30, phi=25, expand=0.35)
```

For kriging, it is necessary to retain the trend surface for use. Unfortunately, the way this works is that we have to retain the *formula* associated with the trend surface, not the object produced when we do the interpolation. Here's what that looks like

```{r}
# a set of formulae for 0, 1st, 2nd and 3rd order trend surfaces
ts.f0 <- rain_mm ~ 1
ts.f1 <- rain_mm ~ 1 + X + Y
ts.f2 <- rain_mm ~ 1 + X + Y + I(X*Y) + I(X^2) + I(Y^2)
ts.f3 <- rain_mm ~ 1 + X + Y + I(X*Y) + I(X^2) + I(Y^2) + I(X^2*Y) + I(X*Y^2) + I(X^3) + I(Y^3)
```

And here is how we do trend surface analysis using a formula. It involves making a *linear model* using the `lm()` function. We will see more of this when we look at regression in the next couple of weeks. For now don't worry too much about exactly what is happening.

```{r}
# use this line to specify which formula to use
f <- ts.f3
# use lm to make a linear model
t <- lm(f, data=paws)
# use the model to calculate predicted values at the output locations
ts <- SpatialGridDataFrame(output, data.frame(var1.pred = predict(t, newdata=output)))

tm_shape(raster(ts)) +
  tm_raster(alpha=0.75, palette='Blues') +
  tm_legend(legend.outside=T)
```

Here's another way to plot the data, just for interest.

```{r}
image(r, asp=1, col=brewer.pal(9,'Blues'))
plot(pa, col=rgb(1,1,1,0), border='gray', add=T)
contour(r, col='red', add=T, cex=4)
```

### Making a variogram
The other half of kriging is the model of spatial structure in the data that we use, otherwise known as a variogram.

The simplest variogram model is based on a plot of distance between control points against the difference in associated values.

```{r}
v <- variogram(ts.f2, paws, cloud=T, cutoff=150)
plot(v)
```

If instead of plotting all the points, we summarise the values at a series of distances, then we get an empirical variogram.

```{r}
v <- variogram(ts.f2, paws, cloud=F, cutoff=150)
plot(v)
```

From this plot, we can estimage a range (say around 50) and a sill value (say 50), and we then use these to fit a variogram mode to the data.

```{r}
fit.v <- fit.variogram(v, vgm(psill=50, model='Exp', range=50))
plot(v, fit.v)
```

Many different models are available, see `vgm()` to get a list.

### Finally, kriging
Now we have a variogram, we can do the actual kriging.

```{r}
k <- krige(ts.f2, paws, fit.v, newdata=output)
r <- raster(k)
ci <- sqrt(raster(k, layer='var1.var')) * 1.96
```

Note that I've retained both the predicted values in the raster `r` and also a 95% confidence interval number in the raster `ci`.  We can plot whichever we are interested in in the usual way.

```{r}
tm_shape(r) +
  tm_raster(alpha=0.75, palette='Blues', title='Predicted rainfall (mm)') +
  tm_shape(paws) +
  tm_bubbles(col='rain_mm', palette='Blues') +
  tm_shape(pa) +
  tm_polygons(alpha=0) +
  tm_legend(legend.outside=T)
```

## Assignment 3
Using methods eiher from this session (or in last week's) produce interpolated maps of rainfall and maximum and minimum temperatures from the provided data.

Write up a report on the process, providing the R code used to produce your final maps, and also discussing reasons for the choices of methods and parameters you made.

There are a number of choices to make, and consider in your write up:

+ interpolation method: Thiessen polygons, IDW, trend surface, or kriging;
+ resolution of the output (this is controlled by the cellsize setting in the `makegrid` function);
+ parameters associated with particular methods, such as power (for IDW), the trend surface degree for trend surfaces and kriging; and
+ variogram model&mdash;although this is not really one you can make a well informed choice about.

Submit a PDF report. Note that you could also do this using the knitr functionality of the provide R markdown file, although will obviously need to add additional R code to this document, and tidy things up generally (ask me about this, if you are interested).
