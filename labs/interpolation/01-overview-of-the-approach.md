
# The overall approach to interpolation
The *R* ecosystem's approach to spatial interpolation seems pretty complicated at first. It's not exactly simple, although the overall concept is straightforward enough and some of the apparent complexity has more to do with making different data types interact with one another successfully.

But the basic steps are
1. Get a set of control points
2. Define a target set of 'sites' to interpolate at
3. Build a spatial statistical model from the control points
4. Apply the model to the target sites

In a bit more detail these involve:

## 1. Get a set of control points
The control points are the empirical data from the field or other source telling you known measurements at known locations.

So... usually you will be supplied with these. In the instruction pages which follow we make a fake set of control points because in the instructional example we already know the answer. In 'real life' (and in the assignment) the control points will be provided.

## 2. Define a target set of 'sites' to interpolate at
We also need to specify where and at what resolution (or degree of detail) we want to perform estimates (i.e. interpolation).

Generally this will be across the area covered by the control points. We'll assume that a bounding box (i.e. a rectangular region) is 'good enough' but in specific cases, you might want to mask out regions, when it may get more complicated.

The most straightforward way to make use of the sites to interpolate at is as an 'empty' raster dataset with the required resolution.

Surprisingly there is no simple way to make this from a set of control points, instead we have to go via `st_make_grid` to get a grid of points, then turn this into an 'xyz' data table, then use the `rasterFromXYZ` function to get a suitable 'target' raster layer. That's way more complicated than I'd like, but it seems to be the most robust approach. How it's done is shown in the instructions.

## 3. Build a spatial statistical model from the control points
The 'crunchy' part is where we use `gstat::gstat` to fit a model to the control points data. This makes an *R* model object which can then be applied by other *R* tools to run interpolations. For the simple methods like IDW there isn't much to this. For kriging making the model gets more complicated.

## 4. Apply the model to the target sites
The last step is to apply the model. This ends up looking like

```
interpolated_sf <- predict(model, target_sites_sf)
interpolated_raster <- rasterize(as(interpolated_sf, "Spatial"), target_raster, "var1.pred")
```

where `predict` applies a model at a set of locations as specified in the sites `sf`. This can be viewed as is or converted to a raster with the `rasterize` function. The final result is a raster layer whose geometric properties (extent, cell size, CRS) match the target sites raster we made in step 2. The values in the raster are calculated based on the information contained in the model made in step 3.

Sometimes you get lucky and you can interpolate straight to raster with

```
interpolated_raster <- interpolate(target_raster, model)
```

But it doesn't work for all models for reasons that are hard to work out (believe me I've tried). For the sake of a consistent approach at least to near neighbour, IDW, trend surfaces, and kriging, we will use the first approach.

# Onward!
So... those are the steps. It's useful to keep this overall framework in mind before getting too lost in the details!

[Back to the overview](README.md) | On to [the example dataset](02-example-dataset.md)
