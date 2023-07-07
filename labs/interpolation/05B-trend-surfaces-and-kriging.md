#### GISC 422 T2 2023

# Two digressions on trend surfaces and kriging

Run this first to make sure all the data and packages you need are loaded. If any data are missing you probably didn't make them in one of the previous instruction pages.

```{r message = FALSE}
library(sf)
library(tmap)
library(terra)
library(dplyr)
library(gstat)

## The warnings are a bit out of hand on this page so
options("rgdal_show_exportToProj4_warnings"="none")

volcano <- rast("data/maungawhau.tif")
names(volcano) <- "height"

controls <- st_read("data/controls.gpkg")
sites_sf <- st_read("data/sites-sf.gpkg")
sites_raster <- rast("data/sites-raster.tif")
```

## Some thoughts on kriging in `gstat`

Although `gstat` is the 'go to' package for geostatistics in *R* and although it is very flexible, it has some limitations. Among these are:

-   Awkward interfaces to spatial data (not exclusive to `gstat`!)
-   Making the variogram by hand is tricky
-   Inclusion of a trend surface to run *universal kriging* is particularly challenging to get right
-   And, even if you can get *universal kriging* to work, you can't use a localised trend surface (admittedly this is not supported by many platforms)

## Digression 1: evenly space control points

Some of the challenges encountered in the main instructions are mitigated with better control points. You can use `spatstat` spatial processes to control the `st_sample` function so the code chunk below shows how this can improve kriging results.

```{r}
# new control set using the rSSI point process from spatstat
controls_ssi <- st_read("data/interp-ext.gpkg") %>%
  st_sample(size = 250, type = "SSI", r = 30, n = 250) %>%
  st_sf() %>%
  st_set_crs(st_crs(controls))

heights_ssi <- controls_ssi %>%
  extract(x = volcano)

controls_ssi <- controls_ssi %>%
  mutate(height = heights_ssi$height)
```

Now put them on a web map and note how much more evenly spaced the `controls_ssi` points are.
```{r}
tmap_mode('view')
tm_shape(controls) + tm_dots(col = "black") + tm_shape(controls_ssi) + tm_dots(col = "red")
```

```{r}
# make a new variogram
v_ssi <- variogram(
  height ~ 1,
  data = as(controls_ssi, "Spatial"),
  cutoff = 500,
  width = 25,
)
# fit the variogram
v.fit_ssi <- fit.variogram(v_ssi, vgm(model = "Gau"))
# make the kriging model
fit_K_ssi <- gstat(
  formula = height ~ 1,
  data = as(controls_ssi, "Spatial"),
  model = v.fit_ssi,
  nmax = 8
)
# interpolate!
interp_pts_K_ssi <- predict(fit_K_ssi, sites_sf)
interp_K_ssi <- rasterize(as(interp_pts_K_ssi, "SpatVector"), 
                          sites_raster, field = c("var1.pred", "var1.var"))$var1.pred

persp(interp_K_ssi$var1.pred, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

The lesson here is that we *always* could use better data!

## Digression 2: Using a local trend surface in universal kriging

In theory universal kriging models overall trends with a trend surface of some kind, then interpolates the residuals from that surface using a variogram and kriging.

But we saw before that with a localised trend surface you can already get a pretty nice interpolation using that alone. However, `gstat` doesn't let you use localised trend surfaces in kriging---at least not in any simple way. In the code chunk below, I show how this limitation can potentially be sidestepped.

```{r}
# make a trend surface interpolation
fit_TS <- gstat(
  formula = height ~ 1,
  data = as(controls, "Spatial"),
  nmax = 24,
  degree = 3,
)
interp_pts_TS <- predict(fit_TS, sites_sf)
interp_TS <- rasterize(as(interp_pts_TS, "SpatVector"), sites_raster, field = c("var1.pred", "var1.var"))$var1.pred

persp(interp_TS, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

Now we proceed to krige on the residuals from this surface.

```{r}
# get the ts values and include in controls also making a residual
ts_estimates <- extract(interp_TS, as(controls, "SpatVector")) %>%
  as_tibble() %>%
  select(var1.pred) %>%
  rename(ts = var1.pred)

controls_resid <- controls %>%
  bind_cols(ts_estimates) %>%
  mutate(resid = height - ts)

# now proceeed with kriging on the residual values
v_resid <- variogram(
  resid ~ 1,
  data = as(controls_resid, "Spatial"),
  cutoff = 500,
  width = 25,
)
# fit the variogram
v.fit_resid <- fit.variogram(v_resid, vgm(model = "Sph"))
# make the kriging model
fit_K_resid <- gstat(
  formula = resid ~ 1,
  data = as(controls_resid, "Spatial"),
  model = v.fit_resid,
  nmax = 8
)
# interpolate!
interp_pts_K_resid <- predict(fit_K_resid, sites_sf)
interp_K_resid <- rasterize(as(interp_pts_K_resid, "SpatVector"), sites_raster, field = c("var1.pred", "var1.var"))
interp_K_final <- interp_TS + interp_K_resid$var1.pred

persp(interp_K_final, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```
Back to [trend surfaces and kriging](05-trend-surfaces-and-kriging.md) | On to [splines](06-splines.md)
