#### GISC 422 T1 2021
# Point pattern analysis with real data

```{r}
# Reload some libraries in case you are restarting partway through
library(spatstat)
library(RColorBrewer)
# also store the initial graphic options in a variable
# so we can reset them at any time
pardefaults <- par()
```

Now we need to read two data files, one with the point events and one with the study area. These are [here](ak-tb-cases.geojson?raw=true) and [here](ak-tb.geojson?raw=true). Load the `sf` library for handling spatial data.

```{r}
library(sf)
```

and use it to load the data:

```{r}
ak <- st_read("ak-tb.geojson")
tb <- st_read("ak-tb-cases.geojson")
```

Check that things line up OK by mapping them using `tmap`.

```{r}
library(tmap)

tm_shape(ak) +
  tm_polygons() +
  tm_shape(tb) +
  tm_dots()
```

## Reprojecting the data

For PPA we really need to be working in a projected coordinate system that uses real spatial units (like metres, even better kilometres), not latitude-longitude.

```{r}
st_crs(ak)
st_crs(tb)
```

By now you should recognise these as 'unprojected' lat-lon, which is no good to us. We should instead use the New Zealand Transverse Mercator. We get the proj4 string for this from an appropriate source, and use it to transform the two layers. I have modified the projection to centre it on Auckland (the `lat_0` and `lon_0` settings), and also to make the units km (the `units` setting) rather than metres as this has a dramatic effect on how well `spatstat` runs. It also makes it easier to interpret results meaningfully.

```{r}
nztm <- '+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600 +y_0=10000 +ellps=GRS80 +units=km'

ak <- st_transform(ak, nztm)
tb <- st_transform(tb, nztm)
```

Now we should check that things still line up OK.

```{r}
tm_shape(ak) +
  tm_polygons() +
  tm_shape(tb) +
  tm_dots()
```

## Converting spatial data to `spatstat` data

OK. So much for the spatial data. `spatstat` works in its own little world and performs PPA on `ppp` objects, which have two components, a set of (*x*, *y*) points, and a study area or 'window'.

This is quite a fiddly business, which never seems to get any easier (every time I do it, I have to look it up in help). We need some conversion functions `as_Spatial` from the `sf` package, and some more in the \`maptools' package. So load that

```{r}
library(maptools)
```

If it doesn't load, then make sure it is installed and try again. Now we use `as.ppp` to make a point pattern from the geometry of the `tb` data set.

```{r}
tb.pp <- as.ppp(as_Spatial(tb$geometry))
```

and plot it to take a look:

```{r}
plot(tb.pp)
```

That's better than nothing, but ideally we use the land area for the study area. Again, we use a conversion function from `maptools`.

```{r}
tb.pp$window <- as.owin(as_Spatial(st_union(ak)))
```

Now let's take a look:

```{r}
plot(density(tb.pp))
plot(tb.pp, add=T)
```

Finally!

If we were doing a lot of this kind of analysis starting with lat-lon datasets, then we would build a function from some of the elements above to automate all these steps. In this case, since we are only running the analysis once for this lab, I will leave that as an exercise for the reader...

[**back to PPA with `spatstat`**](01-ppa-in-spatstat.md) \| [**on to assignment**](03-assignment-instructions.md)
