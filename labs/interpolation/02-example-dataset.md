# Basics of working with raster data
First load some libraries

```{r}
library(sf)
library(tmap)
library(terra)
```
The new(ish) to us kid on the block here is `raster` for handling gridded raster datasets. One thing to be very aware of is that `raster` masks the `select` function from `dplyr` so you have to specify `dplyr::select` when using the `select` to tidy up datasets during data preparation.

## Read a raster dataset
We are using a simple example of the elevation of Maungawhau (Mt Eden) in Auckland to demonstrate the interpolation methods. There is a version of this dataset available as standard in *R* but I made raster version of it for us to work with. So load this with the raster package:

```{r}
volcano <- rast("data/maungawhau.tif")
```

Confusingly, when you read in a raster dataset it names the associated numerical data using the filename, so we rename that to `height` which is more appropriate for our purposes.

```{r}
names(volcano) <- "height"
```

We won't get into it for a bit, but you can actually have multiple values in a raster dataset (when it is often called a 'raster brick'), but this dataset just has one value per cell.

### Map it
`tmap` can handle raster data, so we can use it in the usual way, albeit with the `tm_raster` function to specify colouring and so on.

```{r}
tm_shape(volcano) + 
  tm_raster(pal = "-BrBG", style = "cont") +
  tm_legend(outside = TRUE)
```

### Using `persp`
It's also sometimes useful to get a 2.5D view of raster data. A base *R* function that allows us to do this is `persp`:

```{r}
persp(volcano, scale = FALSE, expand = 2, theta = 35, phi = 30, lwd = 0.5)
```

The parameters `theta` and `phi` control the viewing angle. `expand` controls scaling in the vertical direction, which it is often useful to exaggerate so we can see what's going on a bit better. Experiment with these settings a bit to get a feel for things.

### Using `rayshader`
Try not to get distracted by it (because it's very cool!) but we can also use a package `rayshader` to make really nice interactive 3D renderings of raster data. Here's how that works:

```{r}
library(rayshader)

# this package wants a matrix not a raster
# so make a matrix copy of the raster data
volcano_m <- raster_to_matrix(volcano)

volcano_m %>%
  sphere_shade(texture = 'bw') %>% # this does the shading
  plot_3d(heightmap = volcano_m, zscale = 5, theta = 35, phi = 30, fov = 5)
```

`theta` and `phi` are similar to the settings in `persp`. `fov` is the angular field of view and controls the perspective of the object. Here `zscale` tells the rendering the relationship between units in the vertical direction (metres) and the cells in the raster (which are at 10m spacing). To get a two-times exaggeration here, we use `zscale = 5`.

Back to [the overall framework](01-overview-of-the-approach.md) | On to [preparing for interpolation](03-preparing-for-interpolation.md)