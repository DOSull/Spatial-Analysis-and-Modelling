# Making maps in *R*
The data for this lab are in [this file](tb_bycau006.zip).

There are two versions of this file. The plain Markdown `.md` file can be viewed on github; the R Markdown `.Rmd` can be used in *RStudio*.

## Some quick map plotting
Something we'll need to do a lot is read a shape file. For those who haven't run into shape files before they are a popular file format for storing geographical data. First, we need to import an *R* package that will help us do that.

*R* packages are bundles of commands that enable us to do particular specialized things. They aren't part of the basic functionality of *R* because including commands for all the things that you might want to do in *R* would make it a very large and unwieldy platform. Here, we need `rgdal`.
```{r}
library(rgdal)
```
Now we can use functionality provided by that library, in the `readOGR` function to import a shapefile
```{r}
auckland <- readOGR("tb_bycau06.shp")
```
The result tells us that we successfully read a file that contains 103 features (i.e. geographical things), and that each of those features has 19 'fields' of information associated with it.

We can see a list of the field names using the `names` function.
```{r}
names(auckland)
```
We can see the first 5 rows of the data table with the `head` command.
```{r}
head(auckland)
```

Or, we can see the data nicely formatted by viewing it as a `data.frame`.
```{r}
ak <- data.frame(auckland)
ak
```
We can use the plot function to plot the data, and, since these data are geographical, we will get a map.
```{r}
plot(auckland, col='grey', lwd=0.25)
```
Note how we specify a color for the regions (`col='grey'`) and a line width (`lwd=0.25`). You don't have to specify these, or you can change them. Try making a different looking map.

## Chloropleth maps
We can also make simple chloropleth maps using plot. There's a column in our data called `TB_RATE`, or tuberculosis rate, so let's make a simple chloropleth map of that. Choropleth maps are those where regions are colored according to underlying data values.

### Exploring the data
Since choropleth maps are maps of data, it is worth first familiarizing ourselves with the data in question, independent of the geography.

Since we are concerned with the `TB_RATE` variable, let's see what it looks like in terms of the distribution across the 103 areas in the map.
```{r}
summary(auckland$TB_RATE)
```

- What's the lowest TB_RATE?
- What's the highest TB_RATE?

From this result, you can see that the date are skewed, with only a small number of higher values, since the median is 88, meaning that half the rates are that level or lower. More visually, we can make a histogram:
```{r}
hist(auckland$TB_RATE)
```

It gets tedious typing `auckland$TB_RATE`, so we can use the `attach` command to save us the trouble, and view the same data a different way.
```{r}
attach(ak)
boxplot(TB_RATE)
```

### Mapping the data
First, we will load a couple of libraries useful for this purpose. `RColorBrewer` gives us access to nice color schemes from [ColorBrewer](http://colorbrewer.org) and `classInt` helps with partitioning data into classes (or intervals or categories) using a number of popular methods.
```{r}
library(RColorBrewer)
library(classInt)
```

#### Colors and classes
We'll make a map with four shades of green. To do this, first we need a color palette.
```{r}
n <- 4
pal <- brewer.pal(n, "Greens")
pal
```
If you have done any graphical work you might recognize those numbers as a series of RGB color codes. If not, don't worry about it. The important thing is that the `RColorBrewer` command `brewer.pal` allows us to make nice sets of colors according to specifications as described in the [detailed documentation](https://www.rdocumentation.org/packages/RColorBrewer/versions/1.1-2/topics/RColorBrewer).

Note how we have put the number of colors in a variable `n` which will make it easier to change the code to make different maps later.

To accompany these colors we need a way to assign data to different classes, which will be colored differently. This is what the `classIntervals` function (from the `classInt` package) provides.
```{r}
classes <- classIntervals(TB_RATE, n, style="equal")
classes
```
The resulting table shows us that classes consists of 4 classes, with data ranges 0-112.5, 112.5-225, 225-337.5 and 337.5-450. The list of numbers below is how many of the 103 areas will be assigned to each class when we make a map using these classes.  It is no coincidence that each of these data ranges is the same size (112.5 units), because we specified `style="equal"` when we called `classIntervals`. Other **classification schemes** are possible, as described in the [documentation for `classInt`](https://www.rdocumentation.org/packages/classInt/versions/0.1-24).

### Putting it all together in a map
To make a map, we will want to call the `plot` function on the `auckland` dataset, but this time specify a list of colors for the regions. We use another function from the `classInt` package to do this
```{r}
colors <- findColours(classes, pal)
colors
```

And we are ready to make a map.
```{r}
plot(auckland, col=colors)
```

A map like this is not much use without a title and a legend to tell us what we are looking at, so a more complete recipe is below.
```{r}
plot(auckland, col=colors)
title(main="TB Rates in Auckland, per 100,000 population")
legend('topleft', legend=names(attr(colors, "table")), fill=attr(colors, "pal"), cex=0.8, bty="n")
```

## Explore some more
The above sequence of commands worth spending some time with. Experiment with what happens when you change `n` (the number of classes), the color palette, or the classification `style`. You may find it useful to copy commands from the history into a script to make it easier to do this.

## The power of programming
Now, we put all the operations required to make a map into a single function, which makes it easier to to make different maps. It is not necessary for you to understand everything going on here. Think of it as furthering your appreciation of what you can do in a mapping environment that is 'driven' using code.
```{r}
## Definition of a function to automate a series of commands and make a choropleth map
choro <- function(sf, varname, nclasses=5, pal='Reds', sty='equal', ttl='') {
  palette <- brewer.pal(nclasses, pal)
  classes <- classIntervals(sf[[varname]], nclasses, style=sty)
  colors <- findColours(classes, palette)
  plot(sf, col=colors, lwd=0.35)
  legend('top', ncol=3, legend=names(attr(colors, 'table')), fill=attr(colors, 'palette'), cex=0.8, bty='n')
  title(ttl)
}
```

With the `choro` function defined it becomes easier to make a variety of different maps. As usual, the best way to learn is to experiment.
```{r}
choro(auckland, 'TB_RATE', pal='YlOrRd', nclasses=5, sty='quantile', ttl='Auckland, TB rates, per 100,000')
```
