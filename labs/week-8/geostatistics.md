# Geostatistics in R
In this document we will look at performing geostatistical interpolation (commonly known as kriging) using the `gstats` package in R.

We need a bunch of libraries (as usual).

```{r}
# For handling and mapping spatial data
library(sf)
library(tmap)
library(tmaptools)

# For some table joins
library(dplyr)

# For geostatistics
library(gstat)
```

## The data we will work with
I pulled some weather data for rainfall and temperatures in the Wellington region from the [NIWA climate database](https://cliflo.niwa.co.nz/). The data are for 12 April 2019, and are in simple comma-separated variable format to begin (although... I had to do some cleaning to get them to this state!)

```{r}
all_stations <- read.csv('stations.csv')
rain <- read.csv('rain.csv')
temp <- read.csv('temp.csv')
```

Inspect these using the `View()` function.

The spatial component is in the `stations` dataset, in columns named `Long.dec_deg.` and `Lat.dec_deg.` (note the full stops, a NIWA silliness). To convert these into a spatial dataset we can use the `sf::st_as_sf` function.

```{r}
stns <- st_as_sf(all_stations, coords=c('Long.dec_deg.', 'Lat.dec_deg.'), crs=4326)
```

Note that we've specified the projection as EPSG 4326 (i.e. unprojected, lat-lon). The above simple function only works this straightforwardly for point data.

Now we can map the data, so we can make sure we are in the right place.

```{r}
tmap_mode('view')
tm_shape(stns) + tm_bubbles()
```

To join the other data to the spatial data, we can use the `dplyr::inner_join` function.

```{r}
weather <- inner_join(stns, rain, by='Agent')
weather <- inner_join(weather, temp, by='Agent')
```

This has introduced some variables we don't really need, namely `X.x` and `X.y` (these tell us where the joined data came from, i.e. which row in the joined data), but we aren't interested in that. So...

```{r}
weather <- weather[, c(1:3,5,7:9)]
```

After all that, we should probably project to NZ coordinates, and save our work:

```{r}
weather <- st_transform(weather, 2193)
st_write(weather, 'weather.shp', delete_dsn=T)
```

## Inspect the data
Make simple maps to get some idea of things. The code below will do the rainfall results. Change it to view other variables.

```{r}
tm_shape(weather) + tm_bubbles(col='rain.mm', palette='Blues')
```

## Geostatistical interpolation
Again, I have drawn heavily on [this resource](https://mgimond.github.io/Spatial/interpolation-in-r.html), to put together the instructions below.

Before we start, we have to convert the simple features (`sf`) data to `SpatialPointsDataFrame` data, because... well, because like many other analysis packages, `gstat` cannot yet handle the `sf` formats.

```{r}
weather_sp <- as_Spatial(weather)
```

We have to add `X` and `Y` columns to the `weather_sp` data table for the `gstat` functions to make use of.

```{r}
weather_sp$X <- coordinates(weather_sp)[,1]
weather_sp$Y <- coordinates(weather_sp)[,2]
```

We also need an output grid of locations where we will perform the interpolation. To make this we are going to need the `sp` package.

```{r}
library(sp)
```

And then we use the `spsample` function.

```{r}
output <- as.data.frame(spsample(weather_sp, "regular", n=50000))
names(output) <- c('X', 'Y')
coordinates(output) <- c('X', 'Y')
gridded(output) <- T
fullgrid(output) <- T
proj4string(output) <- proj4string(weather_sp)
```

### Trend surfaces
Trend surfaces are a special kind of linear regression where we use the spatial coordinates of the control points as predictors of the values measured at those points. The function that is fitted is a polynomial expression in the coordinates. For example a degree 2 polynomial is of the form $z=b_0+b_1x+b_2y+b_3xy+b4x^2+b_5y^2$.

```{r}
tr2 <- krige(rain.mm ~ 1, weather_sp, output, degree=2)
r <- raster(tr2)

tm_shape(r) +
  tm_raster(alpha=0.6, palette='Blues') +
  tm_shape(weather_sp) +
  tm_bubbles(col='rain.mm', palette='Blues')
```
