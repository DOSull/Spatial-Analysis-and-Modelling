#### GISC 422 T1 2021
# Making simple maps
To mentally prepare you for what's coming, the next few paragraphs walk you through making a map of some data, using the `sf` and `tmap` packages. I think it is helpful to do this just to get a feeling for what is going on before we dive into details in the coming weeks.

First, we need to load the libraries
```{r}
library(sf)
library(tmap)
```
We us the `sf` pacakge to read data in spatial formats like shape files, with the `st_read` function:
```{r}
nz <- st_read('nz.shp')
```
To make a map with this, we use the `tmap` package. We'll learn more about this package in the next couple of weeks. Basically it lets you make a map by progressively adding layers of data. To start a map you tell it the dataset to use
```{r}
map <- tm_shape(nz)
```
At this point nothing happens, we're just setting things up. We need to layer on or add additional information so `tmap` knows what to do with it. In this case, we are mapping polygons, so the `tm_polygons` function provides the needed information (to find out more about the available options, type `?tm_polygons` at the command prompt.
```{r}
map + tm_polygons(col = 'green', border.col = 'black')
```
If we want to add a few more cartographic frills like a compass rose and scale bar, we can do that too:
```{r}
map + tm_polygons(col = 'darkseagreen2', border.col = 'skyblue', lwd = 0.5) +
  tm_layout(main.title = 'Aotearoa New Zealand',
            main.title.position = 'center',
            main.title.size = 1,
            bg.color = 'powderblue') +
  tm_compass() +
  tm_scale_bar()
```

For a list of named colours in *R* see [this document](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf). Try experimenting with changing a few things in the above map. Consult the help on `tm_layout` using `?tm_layout` to see what options are available.

## Adding another layer
The `quakes` dataset is not in a spatial format, although it include spatial information (the easting and northing coordinates). Before continuing, make sure it is still loaded, and if not, reload it
```{r}
library(readr)
quakes <- read_csv('earthquakes.csv')
```

This is just a dataframe. The `sf` package provides the required functions to convert the dataframe to a *simple features* dataset, which *is* a spatial data format. The following command will do the necessary conversion (you need to be careful to type it exactly as shown).
```{r}
qmap <- st_as_sf(quakes, coords = c('NZMGE', 'NZMGN'), crs = 27200) %>%
  st_transform(st_crs(nz))
```
What's happening here? Quite a lot it turns out.

`st_as_sf` is the function that does the conversion. The *parameters* in parentheses tell the function what to work on. First is the input dataframe `quakes`. Next the `coords` parameter tells the function which variables in the dataframe are the *x* and *y* coordinates in the dataframe. the `c()` structure concatenates the two variable names into a single *vector* which is required by `st_as_sf`. Finally, we also specify the *coordinate reference system* or map projection of the data. These data are in New Zealand Map Grid, which has an [EPSG code 27200](https://epsg.io/27200).

Unfortunately, this is a different projection than the `nz` dataset. But I can *pipe* the data into the `st_transform` function to convert its projection to match that of the `nz` dataset using `st_crs(nz)` to retrieve this information from the `nz` dataset and apply it to the new spatial `qmap` layer we are making.

Now we have two datasets we can make a layered map including both of them.
```{r}
tm_shape(nz) +
  tm_polygons(col = 'darkseagreen2') +
  tm_shape(qmap) +
  tm_dots()
```

That's OK, although not very useful, we really need to zoom in on the extent or *bounding box* of the earthquake data:
```{r}
tm_shape(nz, bbox = st_bbox(qmap)) +
  tm_polygons(col = 'white', lwd = 0) +
  tm_layout(bg.color = 'powderblue') +
  tm_shape(qmap) +
  tm_dots() +
  tm_scale_bar()
```

This still not very useful, because the `nz` dataset includes no actual reference data of interest other than the coastline. We can fix that by making a web map instead (see a little bit below.) Still... it's a pretty map.

For now, an alternative to `tm_dots` is `tm_bubbles` which allows us to scale the symbols by some variable
```{r}
tm_shape(nz, bbox = st_bbox(qmap)) +
  tm_polygons(col = 'white', lwd = 0) +
  tm_layout(bg.color = 'powderblue') +
  tm_shape(qmap) +
  tm_bubbles(size = 'MAG', perceptual = TRUE, alpha = 0.5) +
  tm_scale_bar()
```

This isn't a great map. It might be easier to see if we only showed the larger aftershocks. We use another tidyverse tool in the `dplyr` package.

```{r}
library(dplyr)
bigq <- qmap %>%
  filter(MAG >= 4)
```

Try again, this time also making the bubbles transparent:

```{r}
tm_shape(nz, bbox = st_bbox(qmap)) +
  tm_polygons(col = 'white', lwd = 0) +
  tm_layout(bg.color = 'powderblue') +
  tm_shape(bigq) +
  tm_bubbles(size = 'MAG', perceptual = T, alpha = 0) +
  tm_scale_bar()
```

Alternatively, we might use colour to show the different magnitudes:

```{r}
tm_shape(nz, bbox = st_bbox(qmap)) +
  tm_polygons(col = 'white', lwd = 0) +
  tm_layout(bg.color = 'powderblue') +
  tm_shape(bigq) +
  tm_bubbles(size = 'MAG', col = 'MAG', palette = 'Reds', alpha = 0.5) +
  tm_scale_bar()
```

That's probably enough experimenting to give you the general idea.

## A web basemap
One other thing we can do with the `tmap` package is make it a web map instead. We no longer need the `nz` layer, we just have to switch modes
```{r}
tmap_mode('view')
```

[To switch back use `tmap_mode('plot')`]

Then make a map as before, but no need for the `nz` layer

```{r}
tm_shape(qmap) +
  tm_dots(col = 'MAG', palette = 'Reds')
```
OK. Before we wrap up a quick look at [_R Markdown_](05-r-markdown.md).
