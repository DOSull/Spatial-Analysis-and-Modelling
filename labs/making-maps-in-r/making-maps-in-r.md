#### GISC 422 T2 2021

# Making maps in *R*

The data for this lab are available in [this zip file](making-maps-in-r.zip).

You can see previews of two of the data layers at the links below:

-   the [Auckland census area units](https://github.com/DOSull/GISC-422/blob/master/labs/week-02/ak-tb.geojson).
-   [Auckland TB cases 2006](https://github.com/DOSull/GISC-422/blob/master/labs/week-02/ak-tb-cases.geojson) (jittered to anonymise locations)

Before we start we need to load the `sf` package to handle spatial data

```{r}
library(sf)
```

## Some quick map plotting

First we need to read in the spatial data. We do this with the `st_read` function provided by the `sf` package (most functions in `sf` start with `st_`)

```{r}
auckland <- st_read("ak-tb.geojson")
```

The result tells us that we successfully read a file that contains 103 features (i.e. geographical things), and that each of those features has 5 'fields' of information associated with it. Note that to find out more about `st_read` and how it works you can type `?st_read` at any time---the `?` immediately before a function name provides help information. For help on a package type `??` before the package name, i.e., `??sf`.

Back to the data we just loaded. We can get a feel for the data using the `as_tibble` function from the `tidyr` package. This is a generic function for examining datasets, and shows us the first few rows and columns of the data in a convenient format.

```{r}
library(tidyr)
as_tibble(auckland)
```

Alternatively, use `View`

```{r}
View(auckland)
```

to see a view of the data in the *RStudio* viewer.

We can also use the `plot` function to plot the data, and, since these data are geographical, we will get an array of small maps one for each data attribute. It's important to realise that what is happening here is that because we read the data in with the `sf::st_read` function, *R* knows that these data are spatial and produces maps rather than statistical plots.

```{r}
plot(auckland)
```

## Chloropleth maps

The array of maps produced by `plot` is useful for a quick look-see, but we can also make chloropleth maps of specific attributes using functions provided by `tmap` as we started to see last week. There's a column in our data called `TB_RATE`, or tuberculosis rate, expressed in number of cases per 100,000 population, so let's make a simple chloropleth map of that. Choropleth maps are those where regions are colored according to underlying data values.

### Exploring the data

Since choropleth maps are maps of data, it is worth first familiarizing ourselves with the data in question, independent of the geography. Since we are concerned with the `TB_RATE` variable, let's see what it looks like in terms of the distribution across the 103 areas in the map. The base *R* function `summary` will provide summary information on any attributes it meaningfully can.

```{r}
summary(auckland)
```

-   What's the lowest TB_RATE?
-   What's the highest TB_RATE?

Since the *median* is 26.3, meaning that half the rates are that level or lower, while the average or *mean* value is higher at 30.4, you can see that the date are skewed. More visually, we can make a histogram. We can do this either with the base *R* function `hist` by using the `$` symbol to select only that variable as input:

```{r}
hist(auckland$TB_RATE, xlab='TB rate per 100,000 population', main='')
```

or with the `ggplot2` approach, where we define the data we are using and the aesthetics to apply to it. The latter is quite an involved topic, which we *might* get into later in the semester, for now it may be easier to stick with the base *R* `hist` function. Many people much prefer the `ggplot2` approach, although for relatively simply plots like these it may not be very obvious why! I am happy to discuss this in more detail, if you find yourself creating complicated visualisations with *R*.

```{r}
library(ggplot2)
ggplot(auckland) +
  geom_histogram(aes(x=TB_RATE), binwidth=20)
```

Inspecting the histograms, think about how a map might look using different classification schemes. Say we used 9 *equal interval* classes, how many would be in the lowest class? How many in the highest? Would any class have no members? Keep these questions in mind as we experiment with maps in the next section.

### Mapping the data

The most convenient tool for making maps is the `tmap` package, so let's load that.

```{r}
library(tmap)
```

`tmap` maps are made in a similar way to `ggplot2` visualizations. First we make a map object and store it in a variable, telling it where we are getting the data using the `tm_shape` function.

```{r}
m <- tm_shape(auckland)
```

This makes a map object called `m` based on the `auckland` dataset. We now say how we want to symbolize it by adding layers. Since the `auckland` data are polygons we use the `tm_polygons` function

```{r}
m + tm_polygons()
```

Here, we just get polygons. For a choropleth map, we have to say what variable we want the polygon colours to be based on, so do this:

```{r}
# note the 'col' here means colour, not column
m + tm_polygons(col='TB_RATE')
```

There are a number of options for changing the look of this. We can change colours (`palette`), the number of classes (`n`), and the classification scheme (`style`)

```{r}
m + tm_polygons(col='TB_RATE', palette='Greens', n=9, style='quantile')
```

To find out what options are available check the help with `?tm_polygons`. Before going any further experiment with these options, until you are comfortable making such maps easily.

## Adding other layers

We can add layers of other data pretty easily using the same approach. We need to read an additional layer of data first, of course

```{r}
cases <- st_read('ak-tb-cases.geojson')
```

This time, we make a map without saving the basemap to a variable

```{r}
tm_shape(auckland) +
  tm_polygons() +
  tm_shape(cases) +
  tm_dots()
```

Again, check the help for this new function `tm_dots` to see what the options are.

Now read the roads dataset

```{r}
rds <- st_read("ak-rds.shp")
```

and add it to the map:

```{r}
tm_shape(auckland) +
  tm_polygons() +
  tm_shape(rds) +
  tm_lines() +
  tm_shape(cases) +
  tm_dots(col='red', scale=2)
```

It is worth noting here that `tmap` is smart enough to reproject the roads layer to the same projection as the base layers. Check the projections

```{r}
st_crs(auckland)
st_crs(rds)
```

They are clearly different. To reproject the roads to match the polygon layer, we can use `st_transform`, but there is no need, if all we want to do is have a quick look-see. Here's how it would work if we did want to reproject the data:

```{r}
rds_wgs84 <- rds %>%
  st_transform(st_crs(auckland))
```

But again, this isn't necessary unless we are planning on more detailed analytical work, when the internal storage of the map coordinates may matter greatly.

## Using a web basemap for context

`tmap` provides a simple way to make web maps.

```{r}
tmap_mode('view')
```

You then make a map in the usual way.

Switch back to 'static' map mode using `tmap_mode(plot)`.

## Things to Try

Nothing specific... but you should go back over the instructions and experiment with things like the colour palettes used, and the classification scheme specificed by the `style` setting in the `tm_polygons` function call. Make use of the *RStudio* help to assist in these explorations.

You can also try adding map decorations using the `tm_layout` function.

## Maps using only `ggplot2`

Finally, it is worth knowing that there is a way to make maps like these with pure `ggplot2` commands. It goes something like this

```{r}
ggplot(auckland) +
  geom_sf(aes(fill = TB_RATE), lwd = 0.0) +
  scale_fill_distiller(palette = 'Reds', direction = 1) +
  geom_sf(data = cases, size = 1) +
  geom_sf(data = rds, lwd = 0.15, colour = 'darkgrey')
```

If you are an afficionado of the `ggplot` libraries this can be very helpful, although it is generally easier to work with `tmap` at least to begin with. A significant advantage of `tmap` is the ease with which we can make web map outputs.
