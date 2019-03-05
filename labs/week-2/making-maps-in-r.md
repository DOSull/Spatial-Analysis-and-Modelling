# Making maps in *R*
The data for this lab are available as follows:

+ the [Auckland census area units](https://raw.githubusercontent.com/DOSull/GISC-422/master/labs/week-2/ak-tb.geojson).
+ [Auckland TB cases 2006](https://raw.githubusercontent.com/DOSull/GISC-422/master/labs/week-2/ak-tb-cases.geojson) (jittered to anonymise locations)
+ [Auckland roads](https://raw.githubusercontent.com/DOSull/GISC-422/master/labs/week-2/ak-rds.zip)

Also, before we start there are a couple of packages that we need to install. Run the following command

```{r}
install.packages(c("classInt", "mapview"), dependencies = TRUE)
```

This should install copies of the two packages listed locally. It might take a little time to complete. While it is running, read ahead so that you understand what you will be working on today.

There are two versions of this file. The plain Markdown `.md` file can be viewed on github; the R Markdown `.Rmd` can be used directly in *RStudio*. For now, I recommend following the instructions in the `.md` version.

## Some quick map plotting
Something we'll need to do a lot is read spatial data files. So first, we need to import an *R* package that will help us do that.

*R* packages are bundles of commands that enable us to do particular specialized things. They aren't part of the basic functionality of *R* because including commands for all the things that you might want to do in *R* would make it a very large and unwieldy platform. Here, we need `rgdal`. This should already be installed on the lab machines. To check, try loading it:

```{r}
library(rgdal)
```

which will run OK if it is installed (in which case, skip the next step).

If `rgdal` is not installed, then install it with the following:

```{r}
install.packages("rgdal")
```

and then load the package.

```{r}
library(rgdal)
```

Now we can use functionality provided by the `rgdal` library by the `readOGR` function to import a spatial data file and store it in the variable `auckland`. Before doing this make sure you are in the correct working directory by using **Session - Set Working Directory - Choose Directory...** to point to the folder where you downloaded the data file.

```{r}
auckland <- readOGR("ak-tb.geojson")
```

The result tells us that we successfully read a file that contains 103 features (i.e. geographical things), and that each of those features has 9 'fields' of information associated with it. Note that to find out more about `readOGR()` and how it works you can type `?readOGR` at any time&mdash;the `?` immediately before a function name provides help information. For help on a package type `??` before the package name, i.e., `??rgdal`.

Back to the data we just loaded. We can see a list of the field names using the `names` function.

```{r}
names(auckland)
```

We can see the first six rows of the data table with the `head` command.

```{r}
head(auckland@data)
```

We can also use the plot function to plot the data, and, since these data are geographical, we will get a map. It's important to realise that what is happening here is that because we read the data in with the `readOGR` function, *R* knows that these data are spatial and produces a map rather than a statistical plot (so for example, the aspect ratio won't change when you resize the plot area).

```{r}
plot(auckland, col='grey', lwd=0.25)
```

Note how we specify a color for the regions (`col='grey'`) and a line width (`lwd=0.25`). You don't have to specify these, or you can change them. Try making a different looking map, by changing the colour (`col`) or the line width (`lwd`) settings.

## Chloropleth maps
We can also make simple chloropleth maps using plot. There's a column in our data called `TB_RATE`, or tuberculosis rate, expressed in number of cases per 100,000 population, so let's make a simple chloropleth map of that. Choropleth maps are those where regions are colored according to underlying data values.

### Exploring the data
Since choropleth maps are maps of data, it is worth first familiarizing ourselves with the data in question, independent of the geography. Since we are concerned with the `TB_RATE` variable, let's see what it looks like in terms of the distribution across the 103 areas in the map.

```{r}
summary(auckland$TB_RATE)
```

- What's the lowest TB_RATE?
- What's the highest TB_RATE?

Since the *median* is 88, meaning that half the rates are that level or lower, while the average or *mean* value is higher at 106.8, you can see that the date are skewed. More visually, we can make a histogram:

```{r}
hist(auckland$TB_RATE, xlab='TB rate per 100,000 population', main='')
```

It gets tedious typing `auckland$TB_RATE`, so use the `attach` command to save us the trouble.

```{r}
attach(auckland@data)
```

Note that we `attach` a variable called `auckland@data` this is because the dataset is an *R* list object with a number of elements, one called `data` where the polygon attributes are stored. The `@` marker 'unpacks' named items in the list.

Inspecting the histogram above, think about how a map might look using different classification schemes. Say we used 9 $equal interval$ classes, how many would be in the lowest class? How many in the highest? Would any class have no members? Keep these questions in mind as we assemble the map in the next few steps.

### Mapping the data
First, we will load a couple of libraries useful for this purpose. `RColorBrewer` gives us access to nice color schemes from [ColorBrewer](http://colorbrewer.org) and `classInt` helps with partitioning data into classes (or intervals or categories) using a number of popular methods.

```{r}
library(RColorBrewer)
library(classInt)
```

#### Colors and classes
We'll make a map with nine shades of green (it's close to St Patrick's Day, right?). To do this, first we need a color palette.

```{r}
n <- 9
pal <- brewer.pal(n, "Greens")
pal
```

If you have done any graphical work you might recognize those numbers as a series of RGB color codes. If not, don't worry about it. The important thing is that the `RColorBrewer` command `brewer.pal` allows us to make nice sets of colors according to specifications as described in the [detailed documentation](https://www.rdocumentation.org/packages/RColorBrewer/versions/1.1-2/topics/RColorBrewer). You can see the various colour palettes available with the following command:

```{r}
display.brewer.all()
```

The palettes are shown with the maximum number of available colours in that scheme. Versions with smaller numbers of colours are available by specifying the number desired when we invoke the `brewer.pal()` function. Note how we put the number of colors in a variable `n` which will make it easier to change the code to make different maps later.

To accompany these colors we need a way to assign data to different classes, which will be colored differently. In other words, we need a *classification scheme*. This is what the `classIntervals` function (from the `classInt` package) provides.

```{r}
classes <- classIntervals(TB_RATE, n, style="equal")
classes
```

Note how we reuse the variable `n` so our palette and our class intervals match.

The resulting table shows us that classes consists of 9 classes, with data ranges 0-50, 50-100 and so on up to 400-450. The list of numbers  provided is how many of the 103 areas will be assigned to each class when we make a map using these classes (compare with the histogram we made before).  It is no coincidence that each of these data ranges is the same size (50 units), because we specified `style="equal"` when we called `classIntervals`. Other classification schemes are possible, as described in the [documentation for `classInt`](https://www.rdocumentation.org/packages/classInt/versions/0.1-24). (Or type `??classInt`)

### Putting it all together in a map
To make a map, we will want to call the `plot` function on the `auckland` dataset, but this time specify a list of colors for the regions. We use another function from the `classInt` package to do this

```{r}
mapcolors <- findColours(classes, pal)
mapcolors
```

And we are ready to make a map.

```{r}
plot(auckland, col=mapcolors)
```

A map like this is not much use without a title and a legend to tell us what we are looking at, so a more complete recipe is below.

```{r}
plot(auckland, col=mapcolors)
title(main="TB Rates in Auckland, per 100,000 population")
legend('right', legend=names(attr(mapcolors, "table")), fill=attr(mapcolors, "pal"), cex=0.8, bty="n", lwd=0.5)
```

## Explore some more
The above sequence of commands worth spending some time with. Experiment with what happens when you change `n` (the number of classes), the color palette, or the classification `style`. You may find it useful to copy commands from the history into a script to make it easier to do this.

## The power of programming
Now, we put all the operations required to make a map into a single function, which makes it easier to to make different maps. It is not necessary for you to understand everything going on here. Think of it as furthering your appreciation of what you can do in a mapping environment that is 'driven' using code.

```{r}
## Definition of a function to automate a series of commands and make a choropleth map
mychoro <- function(sf, varname, nclasses=5, pal='Reds', sty='equal', ttl='') {
  palette <- brewer.pal(nclasses, pal)
  classes <- classIntervals(sf[[varname]], nclasses, style=sty)
  colors <- findColours(classes, palette)
  plot(sf, col=colors, lwd=0.35)
  legend('bottom', ncol=3, legend=names(attr(colors, 'table')), fill=attr(colors, 'palette'), cex=0.8, bty='n')
  title(ttl)
}
```

With the `mychoro` function defined it becomes easier to make a variety of different maps. As usual, the best way to learn is to experiment.

```{r}
mychoro(auckland, 'TB_RATE', pal='YlOrRd', nclasses=7, sty='quantile', ttl='Auckland, TB rates, per 100,000')
```

You might also find it helpful to put the code that defines the function in a new .R script file, which makes it easier to make changes and rerun it to change the definition of the function.

## Adding other layers
We can load other datasets such as [tuberculosis cases](https://raw.githubusercontent.com/DOSull/GISC-422/master/labs/week-2/ak-tb-cases.geojson) and [roads](https://raw.githubusercontent.com/DOSull/GISC-422/master/labs/week-2/ak-rds.zip). Note that the roads data are in a `.zip` file, for convenience because it is a shape file (which is actually a bundle of files). You will need to extract the contents of the `.zip` archive to the working directory.

Now read in the TB cases file.

```{r}
cases <- readOGR("ak-tb-cases.geojson")
```

and add it to the map:

```{r}
plot(auckland, col='grey', lwd=0.25)
plot(cases, add=TRUE, col='red', cex=0.5, pch=19)
```

Note here the `add=TRUE` option, which tells the plot function not to make a new plot but to add the data to the current one. There are some other options set in the code, which you can look up in the help for `plot()` (and also experiment with).

Now read the roads dataset

```{r}
rds <- readOGR("ak-rds.shp")
```

and add it to the map:

```{r}
plot(auckland)
plot(rds, add=T)
```

Why did this not work? If you said because we put `add=T` that is a possible answer, but is not correct&mdash;*R* can interpret `T` as shorthand for `TRUE`. The answer lies in that bugbear of spatial data, map projections. You can check the map projection of each data set.

```{r}
auckland@proj4string
rds@proj4string
```

They are clearly different. To reproject the roads to match the polygon layer, we can use `spTransform` which is provided by `rgdal`.

```{r}
rds_wgs84 <- spTransform(rds, auckland@proj4string)
```

and then we can layer all three datasets.

```{r}
plot(auckland, col='grey', lwd=0.1)
plot(rds_wgs84, col='black', lwd=0.25, add=TRUE)
plot(cases, col='red', cex=0.5, pch=19, add=TRUE)
```

## Using a web basemap for context
These days people like to use web mapping services to provide a background map and we can do that as well. It is cartographically a bit suspect, but who are we to stand in the way of progress. There are many ways to do this. We're going to use `mapview` which makes it easy. Load the package (we installed it back at the start of the lab):

```{r}
library(mapview)
```

What's nice about this package is that it pretty much handles all the complexities seamlessly. To make a web map of the polygon data run the following:

```{r}
mapview(auckland, zcol="TB_RATE") + mapview(cases, cex=1, color='red') + mapview(rds, color='orange')
```

## Things to Try
