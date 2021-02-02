#### GISC 422 T1 2021
# Simple visualization and mapping
## Preliminaries
If you haven't worked through the other two sets of instructions for this week [go back there and do this now](00-overview.md).

Next, set the working directory to where you would like to work using the **Session - Set Working Directory - Choose Directory...** menu option. When you do that you should see a response something like
```
setwd("~/Documents/teaching/GISC-422/labs/scratch")
```
in the console. It will be a different location than above, depending on your machine.

## Meet the command line...
OK.

The key thing to understand about *R* is that it is a command line driven tool. That means you issue typed commands to tell *R* to do things (this was a normal way to interact with a computer and get work done before the early 1990s, and is making a comeback, like vinyl, but not cool). There are some menus and dialog boxes in *RStudio* to help you manage things, but mostly you interact with *R* by typing commands at the `>` prompt in the console window. To begin, we'll load up a dataset, just so you can see how things work and to help you get comfortable. As with most computer related stuff, you should experiment: you will learn a lot more that way.

## Reading data
We will do this using the `readr` package from the `tidyverse`, which means we first have to load it:
```{r}
library(readr)
```
Now we can use a command in `readr` to read the comma-separated-variable (CSV) data file:
```{r}
quakes <- read_csv('earthquakes.csv')
```
You should get a response something like
```
Parsed with column specification:
cols(
  CUSP_ID = col_double(),
  NZMGE = col_double(),
  NZMGN = col_double(),
  ELAPSED_DAYS = col_double(),
  MAG = col_double(),
  DEPTH = col_double(),
  YEAR = col_double(),
  MONTH = col_double(),
  DAY = col_double(),
  HOUR = col_double(),
  MINUTE = col_double(),
  SECOND = col_double()
)
```
If that doesn't happen make sure you have set the correct working directory, that the data file is in there, and that you typed everything correctly. Ask for help, if necessary.

The response tells you that the file has been opened successfully. You should see an entry for the dataset appear in the *Environment* part of the interface, called `quake` because that's the name of the variable we asked *R* to read the data into. You can look at the data in a more spreadsheet like way either by typing (the capital V is important)
```{r}
View(quakes)
```
or by clicking on the view icon at the right hand side of the entry for `quakes` in the environment list.

These are data concerning earthquakes recorded in the months after the 7.1 earthquake in Christchurch in September 2010.

In *R*, data tables are known as *dataframes* and each column is an attribute or variable. The various variables that appear in the table are
+ `CUSP_ID` a unique identifier for each earthquake or aftershock event
+ `NZMGE` and `NZMGN` are New Zealand Map Grid Easting and Northing coordinates
+ `ELAPSED_DAYS` is the number of days after September 3, 2010, when the big earthquake was recorded
+ `MAG` is the earthquake or aftershock magnitude
+ `DEPTH` is the estimate depth at which the earthquake or aftershock occurred
+ `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND` provide detailed time information

## Exploring data
Now, if we want to use *R* to do some statistics, these data are stored in a variable named `quakes` (in my example, you may have called it something different). I can refer to columns in the dataframe by calling them `quakes$MAG` (note the `$` sign). So for example, if I want to know the mean magnitude of the aftershocks in this dataset I type
```{r}
mean(quakes$MAG)
```
or the mean northing coordinate
```{r}
mean(quakes$NZMGN)
```
and *R* will return the value in response. Probably more informative is a boxplot or histogram, try:
```{r}
boxplot(quakes$MAG)
```
or
```{r}
hist(quakes$MAG)
```
and you should see statistical plots similar to those shown below.

<img src="images/quakes-MAG-boxplot.png"><img src="images/quakes-MAG-hist.png">

It gets tedious typing `quakes` all the time, so you can `attach` the dataframe so that the variable names are directly accessible without the `quakes$` prefix by typing
```{r}
attach(quakes)
```
and then
```{r}
hist(MAG)
```
will plot the specified variable. Be careful using attach as it may lead to ambiguity about what you are plotting if you are working with different datasets that include variables with the same names.

Try the above commands just to get a feel for things.

## A simple (crappy) map
You can make a simple map of all the data by plotting the `NZMGE` variable as the *x* (i.e. horizontal axis) and `NZMGN` as the *y* axis of a scatterplot:
```{r}
plot(NZMGE, NZMGN)
```
<img src="images/quakes-NZMGE-NZMGN-plot.png">

Because base *R* is not a GIS it doesn't know about things like projections, so this is a very crude map.

## **NOTE: from here on I am not going to show results of commands, just the commands!**

There are *R* packages to handle geographical data better than this (we will look at those in [a little later](04-simple-maps.md)) but for now don't worry about it too much. To see if there is a relationship between earthquake depth and magnitude, try this
```{r}
plot(DEPTH, MAG)
```
and because *R* is a statistics package, we can easily fit and plot a simple linear regression model to the data
```{r}
regmodel <- lm(MAG ~ DEPTH)
plot(DEPTH, MAG)
abline(regmodel, col='red')
```
Note here the use of `<-` to assign the model, made by the *linear model* `lm()` command to a new variable, called `regmodel`. You can get more details of this model by typing `regmodel` or `summary(regmodel)`. If you know anything about regression models, these may be of interest to you. Also note how, I've requested that the line be plotted in red `(col='red')`, so it can be seen more easily.

We can make more complex displays. For example
```{r}
plot(ELAPSED_DAYS, MAG)
```
Shows how the magnitude of the aftershocks changed in the days after the initial large earthquake, with the second large event happening around 6 months (180 days) later. A more complicated plot still would be
```{r}
boxplot(MAG ~ cut(ELAPSED_DAYS, seq(0,200,20)))
```
Give that a try and see what you get. To label the chart more informatively we need to add information for *x* and *y* axis labels
```{r}
boxplot(MAG ~ cut(ELAPSED_DAYS, seq(0, 200, 20)), xlab="Days after Sept 3, 2010", ylab="Magnitude")
```
Next up: [simple maps](04-simple-maps.md).
