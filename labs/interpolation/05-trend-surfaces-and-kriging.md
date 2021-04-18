#### GISC 422 T1 2021

# Trend surfaces and kriging

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

There are many different styles of kriging. We'll work here with universal kriging which models variation in the data with two components a *trend surface* and a *variogram* which models how control points vary with distance from one another. So... to perform kriging we have to consider each of these elements in turn.

## Trend surfaces

Trend surfaces are a special kind of linear regression where we use the spatial coordinates of the control points as predictors of the values measured at those points. The function that is fitted is a polynomial expression in the coordinates. Trend surfaces in addition to being a component part of a universal kriging interpolation are sometimes a reasonable choice of overall interpolation especially when data and knowledge are limited, or the investigation is exploratory.

```{r}
fit_TS <- gstat(
  formula = height ~ 1, 
  data = as(controls, "Spatial"), 
  # nmax = 24,
  degree = 2,
)
```

The form of the trend surface function is specified by the `degree` parameter and tells you the maximum power to which the coordinates may be raised in the polynomial. For example with `degree = 2`, the polynomial is $z=b_0 + b_1x + b_2y + b_3xy + b_4x^2 + b_5y^2$.

```{r}
interp_pts_TS <- predict(fit_TS, sites)
interp_TS <- rasterize(as(interp_pts_TS, "Spatial"), sites_raster)

persp(interp_TS$var1.pred, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

You can only specify degree from 1 to a maximum of 3. In theory you can specify it as 0, but I am still trying to figure out what `degree = 0` means... besides which, it appears not to work, at least in this case.

You can also specify  `nmax` and `nmin` which will cause localised trend surfaces to be made. Although if you set `nmax` too low for a particular `degree` (higher degrees need higher `nmax` settings) it can cause strange behaviour particularly in empty regions of the control point dataset or near the edges. I recommend experimenting with the degree setting, then uncommenting the `nmax` setting and experimenting further to see how changing the model `fit_TS` changes the interpolations below.

### Variance estimates

Notice this time that we get multiple layers in the resulting interpolation.

```{r}
plot(interp_TS)
```

This is why in the perspective plot we specify `interp_TS$var1.pred` which is the predicted value. The `var1.var` is an estimate of likely variance in the estimates. It will generally be higher where control points are sparse, or where the surface is changing rapidly.

## Making a variogram

The other half of kriging is the model of the residual spatial structure (after the trend surface is accounted for) that we use, otherwise known as a *variogram*.

The simplest variogram model is based on fitting a curve to the *empirical variogram* which is essentially a plot of distance between control points against some measure of difference in associated values.

```{r}
v <- variogram(
  height ~ 1,
  data = as(controls, "Spatial"),
  cutoff = 600,
  width = 25,
  # cloud = TRUE
)
plot(v)
```

The `cutoff` is the separation distance between control points beyond which we aren't interested. Since we'd be unlikely to use information from two points more than 600m apart in this case, we set that as an upper limit. It's generally good to see the empirical variogram plot levelling off as it does with the settings above. This plot is based on averaging differences in a series of distance intervals (width set using the `width` parameter). If you want to see the full underlying dataset then uncomment the `cloud = TRUE` setting and run the above chunk again. If you do that **be sure to rerun with `cloud = TRUE` commented out again** before proceeding.

Next, we fit a curve to the empirical variogram using the `fit.variogram` function. This requires a functional form (the `model` parameter) which is set by calling the `vgm` function). Many possible curves are possible (you can get a list by running`vgm()`with no parameters), although for these data, I've found that `"Sph"` is the most convincing option.

```{r}
v.fit <- gstat::fit.variogram(v, vgm(model = "Sph"))
plot(v, v.fit)
```

## Using the variogram for ordinary kriging

Now everything is set up to perform kriging interpolation. Kriging in principle is just another geostatistical model and we make it in a similar way to the others. The key difference is we specify the variogram with the `model` parameter setting:

```{r}
fit_K <- gstat(
  formula = height ~ 1, 
  data = as(controls, "Spatial"),
  model = v.fit,
  nmax = 8
)
```

I have found that it is important to set a fairly low `nmax` with these data. I believe that this is because the control points are randomly located and sometimes may have dramatically different values from the interpolation location. But... really I am unsure about this, and we'll consider this in more detail in the next section.

```{r}
interp_pts_K <- predict(fit_K, sites)
interp_K <- rasterize(as(interp_pts_K, "Spatial"), sites_raster)

persp(interp_K$var1.pred, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

You may see some areas where the interpolation has not worked out so well (you might not, as it depends on the control point locations you got). If so, might be able to can see by running the code chunk below why this is.

```{r}
tm_shape(interp_K$var1.var) + 
  tm_raster(pal = "Reds", style = "cont") +
  tm_legend(outside = TRUE) +
  tm_shape(controls) + 
  tm_dots(col = "black") +
  tm_scale_bar()
```

Kriging is complicated and this exercise is intended only to give you a flavour of that, so we will move on. 

However, it is worth also looking at a couple of ['digressions' on kriging in this notebook](05B-trend-surfaces-and-kriging.md) if you are keen to know more about kriging in particular.

Back to [NN and IDW](04-nn-and-idw.md) | On to [splines](06-splines.md)