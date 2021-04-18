#### GISC 422 T1 2021
# Assignment 3: Interpolation in R
Now you've seen how to do interpolation many different ways, here is the assignment.

Some libraries you'll need to make this file run
```{r}
library(sf)
library(tmap)
```

## The data we will work with
We will work with some old weather data for Pennsylvania on 1 April 1993. It is surprisingly hard to find well behaved data for interpolation, and these work. I tried some local Wellington weather data, but they were (maybe unsurprisingly), not very well-behaved...

```{r}
pa.counties <- st_read('data/pa-counties.gpkg')
pa.weather <- st_read('data/pa-weather-1993-04-01.gpkg')
```

## Inspect the data
Make some simple maps to get some idea of things. The code below will do the rainfall results. Change it to view other variables. I've added a scale bar so you have an idea of the scale. If you switch the map mode to `'view'` with `tmap_mode('view')` you can see it in context on a web map.

```{r}
tm_shape(pa.counties) +
  tm_polygons() +
  tm_shape(pa.weather) +
  tm_bubbles(col = 'rain_mm', palette = 'Blues', size = 0.5) +
  tm_legend(legend.outside = T) +
  tm_scale_bar(position = c('right', 'TOP')) +
  tm_layout(main.title = 'Pennsylvania weather, 1 April 1993',
            main.title.size = 1)
```

Now you have seen the data, here's the assignment...

## The assignment
Using any of the methods covered in these materials produce interpolated maps of rainfall and maximum and minimum temperatures from the provided data.

Write up a report on the process, providing the R code used to produce your final maps, and also discussing reasons for the choices of methods and parameters you made.

There are a number of choices to make, and consider in your write up:

+ interpolation method: Voronoi (Thiessen/proximity) polygons, IDW, trend surface, or kriging;
+ resolution of the output (this is controlled by the cellsize setting in the `st_make_grid` function for the examples in this session);
+ parameters associated with particular methods, such as power (for IDW), the trend surface degree for trend surfaces and kriging; and
+ variogram model if performing kriging.

Many of these are difficult to make well-informed choices about, so it is OK to explain what you did and discuss the effects of doing things differently in accounting for your choices. If you get stuck (I did writing these materials) be sure to call for help on the slack channel.

**Some advice**
As noted in the overview, some of the interfaces among the various packages used for interpolation can be finicky and it is easy to get frustrated (believe me, I have become frustrated when assembling these materials...). Your best option is to spend some time with the _RMarkdown_ versions of the material getting a feel for how things work. Then, I recommend you make a completely empty new file and start to assemble the materials you need, reusing code from the tutorial materials. A few things to look out for here:
+ The scales of the Pennsylvania data and the Maungawhau data are completely different. A cell size of 10m makes sense for the volcano, it won't for Pennsylvania. This may also affect any `maxdist` settings and also `cutoff` and `width` settings when estimating a variogram.
+ In my experiments, `gstat` doesn't do very well kriging these data. If you'd like to perform kriging, I **very much recommend** using the `fields` package which is introduced in the materials for spline-based interpolation. For whatever reason, it just does a much better job.
+ More than ever, ask questions if you get stuck!

Submit a PDF report to the dropbox provided in Blackboard by **10 May**.

I thoroughly recommend that you put your report together using the **Knit** functionality in *RStudio*. Please don't just submit a lightly modified version of the files I have provided&mdash;and *definitely* remove any tutorial materials! The explanatory linking text should be your own words, not mine!
