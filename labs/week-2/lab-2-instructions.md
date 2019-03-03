
# Making maps in *R*
## Some quick map plotting
Let's try reading a simple shape file. For those who haven't run into shape files before they are a popular file format for storing geographical data. First, we need to import an *R* package that will help us do that.

*R* packages are bundles of commands that enable us to do particular specialized things. They aren't part of the basic functionality of *R* because including commands for all the things that you might want to do in *R* would make it a very large and unwieldy platform. Here, we need `rgdal`.

    > library(rgdal)

Now we can use functionality provided by that library, in the `readOGR` function to import a shapefile

    > auckland <- readOGR("tb_bycau06.shp")

The result tells us that we successfully read a file that contains 103 features (i.e. geographical things), and that each of those features has 19 'fields' of information associated with it.

We can see a list of the field names using the `names` function.

    > names(auckland)

We can see the first 5 rows of the data table with the `head` command.

    > head(auckland)

Or, we can see the data nicely formatted by viewing it as a `data.frame`.

    > ak <- data.frame(auckland)
    > ak

We can use the plot function to plot the data, and, since these data are geographical, we will get a map.

    > plot(auckland, col='grey', lwd=0.25)

Note how we specify a color for the regions (`col='grey'`) and a line width (`lwd=0.25`). You don't have to specify these, or you can change them. Try making a different looking map.

## Chloropleth maps

We can also make simple chloropleth maps using plot. There's a column in our data called `TB_RATE`, or tuberculosis rate, so let's make a simple chloropleth map of that. Choropleth maps are those where regions are colored according to underlying data values.

### Exploring the data
Since choropleth maps are maps of data, it is worth first familiarizing ourselves with the data in question, independent of the geography.

Since we are concerned with the `TB_RATE` variable, let's see what it looks like in terms of the distribution across the 103 areas in the map.

    > summary(auckland$TB_RATE)

- What's the lowest TB_RATE?
- What's the highest TB_RATE?

From this result, you can see that the date are skewed, with only a small number of higher values, since the median is 88, meaning that half the rates are that level or lower. More visually, we can make a histogram:

    > hist(auckland$TB_RATE)

It gets tedious typing `auckland$TB_RATE`, so we can use the `attach` command to save us the trouble, and view the same data a different way.

    > attach(auckland_df)
    > boxplot(TB_RATE)

### Mapping the data
First, we will load a couple of libraries useful for this purpose. `RColorBrewer` gives us access to nice color schemes from [ColorBrewer](http://colorbrewer.org) and `classInt` helps with partitioning data into classes (or intervals or categories) using a number of popular methods.

    > library(RColorBrewer)
    > library(classInt)

#### Colors and classes
We'll make a map with four shades of green. To do this, first we need a color palette.

    > n <- 4
    > palette <- brewer.pal(n, "Greens")
    > palette

If you have done any graphical work you might recognize those numbers as a series of RGB color codes. If not, don't worry about it. The important thing is that the `RColorBrewer` command `brewer.pal` allows us to make nice sets of colors according to specifications as described in the [detailed documentation](https://www.rdocumentation.org/packages/RColorBrewer/versions/1.1-2/topics/RColorBrewer).

Note how we have put the number of colors in a variable `n` which will make it easier to change the code to make different maps later.

To accompany these colors we need a way to assign data to different classes, which will be colored differently. This is what the `classIntervals` function (from the `classInt` package) provides.


    > classes <- classIntervals(TB_RATE, n, style="equal")
    > classes

The resulting table shows us that classes consists of 4 classes, with data ranges 0-112.5, 112.5-225, 225-337.5 and 337.5-450. The list of numbers below is how many of the 103 areas will be assigned to each class when we make a map using these classes.  It is no coincidence that each of these data ranges is the same size (112.5 units), because we specified `style="equal"` when we called `classIntervals`. Other **classification schemes** are possible, as described in the [documentation for `classInt`](https://www.rdocumentation.org/packages/classInt/versions/0.1-24).

### Putting it all together in a map
To make a map, we will want to call the `plot` function on the `auckland` dataset, but this time specify a list of colors for the regions. We use another function from the `classInt` package to do this:


```R
colors <- findColours(classes, palette)
colors
```

And we are ready to make a map.


```R
plot(auckland, col=colors)
```

A map like this is not much use without a title and a legend to tell us what we are looking at, so a more complete recipe is below.


```R
plot(auckland, col=colors)
title(main="TB Rates in Auckland, per 100,000 population")
legend('topleft', legend=names(attr(colors, "table")),
    fill=attr(colors, "palette"), cex=0.8, bty="n")
```

## Explore some more
The above sequence of cells (starting from **Colors and classes**) is worth spending some time with. Experiment with what happens when you change `n` (the number of classes), the color palette, or the classification `style`. To do this, keep in mind that you will need to run the series of cells in order from the one where `n` and the color paletter are defined on down.

## The power of programming
In case you are interested, in the next cell, we put all the operations required to make a map into a single function, which makes it easier to to make different maps. It is not necessary for you to understand everything going on here. Think of it as furthering your appreciation of what you can do in a mapping environment that is 'driven' using code.


```R
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

With the `choro` function defined it becomes easier to make a variety of different maps. Experiment by changing the cell below.


```R
choro(auckland, 'TB_RATE', pal='YlOrRd', nclasses=5, sty='quantile', ttl='Auckland, TB rates, per 100,000')
```

### Keyboard shortcuts in jupyter

Keyboard shortcuts in jupyter are helpful so that you don't have to click on the top menu all the time. A short list of helpful keyboard shortcuts are located here:

http://maxmelnick.com/2016/04/19/python-beginner-tips-and-tricks.html

Some of the most helpful ones for us will be in `Command` Mode. You can tell when a cell is in command mode by the vertical color bar on the side of the cell -- it will be blue when it's in command mode.

- `shift` + `enter` run cell, select below
- `ctrl` + `enter` run cell
- `option` + `enter` run cell, insert below
- `d` , `d` delete selected cell
- the `?` before a function will give you helpful information about it


```R
#Try running this cell.
?plot
```

**Question**:
- What's the `Usage` of plot?

**Try deleting this cell using the `d`,`d` shortcut!**
