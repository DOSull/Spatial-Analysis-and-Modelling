
# Preparing for interpolation
Run this first to make sure all the data and packages you need are loaded:
```{r}
library(sf)
library(tmap)
library(terra)
library(dplyr)

volcano <- rast("data/maungawhau.tif")
names(volcano) <- "height"
```

## Spatial extent of the study area
It's useful to have a spatial extent polygon. For the example dataset, here's one I prepared earlier (**remember you wouldn't normally be able to do this!**).

```{r}
interp_ext <- st_read("data/interp-ext.gpkg")
```

*Normally*, we would make the extent from the control points, or from some pre-existing desired study area extent polygon. The code to make it from a set of control points is shown below (this is for reference, don't run it, but you may need it later when you tackle the assignment).

```
controls <- st_read("controls.gpkg")
interp_ext <- controls %>%
  st_union() %>%
  st_bbox() %>%
  st_as_sfc() %>%
  st_sf() %>%
  st_set_crs(st_crs(controls))
```

## Control points
For the demonstration data, we already know the result.

Normally, we would have a set of control points in some spatial format and would simply read them with `sf::st_read`. Here, we will make set of random control points to work with in the other steps of these instructions when we are using the Maungawhau data. We start from the interpolation extent, and use `st_sample` to get a specified random number of points in the extent, then convert it to an `sf` dataset. Finally we use the `terra::extract` function to extract values from the raster dataset and assign their values to a height attribute of the `sf` dataset.

```{r}
controls <- interp_ext %>%
  st_sample(size = 250) %>%
  st_sf() %>%
  st_set_crs(st_crs(interp_ext))

heights <- controls %>%
  extract(x = volcano)

controls <- controls %>%
  mutate(height = heights$height)
```

Every time you run the above you will get a different random set of the specified number of control point locations. It is useful to map them on top of the underlying data and think about how many you might need to get a reasonable representation of the height map of Maungawhau.

For simplicity, I am going to write these control points out to a file, which can be loaded into later instructions documents.

```{r}
st_write(controls, "data/controls.gpkg", delete_dsn = TRUE)
```

Some interpolation tools don't want an `sf` dataset, but a simple dataframe with `x`, `y` and `z` attributes, so let's also make one of those:

```{r}
st_read("data/controls.gpkg") %>%
  cbind(st_coordinates(.)) %>%          # this adds the coordinates of the points as X and Y columns
  st_drop_geometry() %>%                # throw away the geometry, so it's just a dataframe
  mutate(x = X, y = Y, z = height) %>%  # rename to the generic x, y, z
  dplyr::select(x, y, z) %>%            # and retain only those three
  write.csv("data/controls-xyz.csv", row.names = FALSE)  # write out to a file
```

Remember that if you change the control points, you should also change this file to keep them matching.

## Make a set of locations to interpolate
Unlike the previous step which may not be necessary when you are provided with control points to interpolate directly, this step is always required. Basically, *R* wants a raster layer to *interpolate into*. We'll call this `sites` and make `sf`, `terra` and simple xyz versions of these.

```{r}
sites_sf <- interp_ext %>% # start with the extent
  st_make_grid(cellsize = 10, what = "centers") %>%
  st_sf() %>%
  st_set_crs(st_crs(interp_ext))

sites_xyz <- sites_sf %>%
  bind_cols(st_coordinates(.)) %>%
  st_drop_geometry() %>%
  mutate(Z = 0)

sites_raster <- sites_xyz %>%
  rast(type = "xyz")
crs(sites_raster) <- st_crs(controls)$wkt
```

Again, it's a good idea to write these all out to files so we don't have to keep remaking them

```{r}
st_write(sites_sf, "data/sites-sf.gpkg", delete_layer = TRUE)
write.csv(sites_xyz, "data/sitex-xyz.csv", row.names = FALSE)
writeRaster(sites_raster, "data/sites-raster.tif", overwrite = TRUE)
```

Back to [the example dataset](02-example-dataset.md) | On to [Near neighbour and IDW](04-nn-and-idw.md)
