# **Assignment 1: Point pattern analysis in `spatstat`**
<hr>

## THIS IS NOT THE 2020 EDITION OF THESE INSTRUCTIONS!
**Instructions need to be updated to use `sf` and `tmap` and friends.**

<hr>

As we've seen, there are many ways to describe, measure and analyze a point pattern. In this section, we will go through how these are performed in `spatstat`, before, in the lab assignment itself looking at the dataset you will analyze for this assignment.

We will use three datasets provided in spatstat to illustrate the explanations in the first part of these instructions because they exhibit clear patterns, and because they are easier to work with. In the second half of these instructions you will see how to get real spatial data into `spatstat` for the assignment. To load up the three datasets, ensure spatstat is installed and run:

```{r}
library(spatstat)
library(rgdal)
library(maptools)
library(sp)
library(RColorBrewer)
# also store the initial graphic options in a variable
# so we can reset them at any time
pardefaults <- par()
```
If any of these don't load, then install them in the usual way.

Now get the datasets built in to `spatstat`.
```{r}
data(cells)
data(japanesepines)
data(redwoodfull)
```

You can find out more about each dataset by typing

```{r}
?cells
```

Give the datasets shorter names, to save on typing:

```{r}
pine <- japanesepines
redw <- redwoodfull
```

It’s nice to see the patterns alongside one another, so set up the plot window for a row of three plots

```{r}
par(mfrow=c(1,3))
plot(cells)
plot(pine)
plot(redw)
```

Notice that the plot titles default to the same as the variable names, so you may want to use more descriptive titles. You do this using the `main=”My plot title”` option, like this:

```{r}
par(mfrow=c(1,1))
plot(cells, main="Cell centers")
```

## A tour of different point pattern analysis methods
The analysis methods we’ve looked at in class and in the readings are covered in each of the sections below.

### Quadrat counting
As discussed quadrat counting is a rather limited method, and the spatstat implementation is accordingly a bit limited, because the method is not much used. In any case, here it is below. Shown here for the cells data at three different resolutions.

```{r}
par(mfrow=c(1,3))

plot(quadratcount(cells))
plot(cells, add=T, col='red', cex=0.5)
plot(quadratcount(cells, nx=3))
plot(cells, add=T, col='red', cex=0.5)
plot(quadratcount(cells, nx=10))
plot(cells, add=T, col='red', cex=0.5)
```

There is also a statistical test associated with quadrat counting:


```{r}
quadrat.test(cells, method="MonteCarlo", nsim=999)
```

This can also take different `nx` and `ny` settings. The `method="MonteCarlo"` and `nsim=999` settings are worth noting. This method setting tests the data by simulation, rather than based on a precalculated Chi-square distribution. This makes the method more useful with small datasets.

The *p*-value tells us how probably the particular observed quadrat counts would be if the underlying process was one of complete spatial randomness.

Try running the same analysis on the `pine` data to see what you get:

### Density estimation
You have already seen this in the previous lab. To create a density surface from a pattern you use the density function. You can save the density to a variable, and examine how useful different surfaces appear as you vary the bandwidth using the `sigma` parameter.

For example, for the redwood data (the most interesting for density mapping)

```{r}
par(mfrow=c(1,3))

# bandwith 0.05
d05 <- density(redw, sigma=0.05)
plot(d05)
contour(d05, add=T)
plot(redw, add=T, cex=0.4)

# bandwidth 0.1
d10 <- density(redw, sigma=0.1)
plot(d10)
contour(d10, add=T)
plot(redw, add=T, cex=0.4)

# bandwidth 0.25
d25 <- density(redw, sigma=0.25)
plot(d25)
contour(d25, add=T)
plot(redw, add=T, cex=0.4)
```

As noted previously, the default color scheme is not great, and you might want to experiment with alternatives provided by `RColorBrewer` package (see the previous lab for reminders about how to do this).

When it comes to selecting a bandwidth, keep in mind that density estimation is most useful as an exploratory method, and that there is no 'correct' bandwidth. A function `bw.diggle`, or much slower, `bw.ppl` will recommend a bandwidth. `bw.diggle` seems to favor small bandwidths, while the `bw.ppl` function returns fairly plausible values (to my eye, but you may disagree). The default bandwidth used by the density function seems to be calculated using a function called `bw.scott` and seems to me a bit large most of the time.

### Mean nearest neighbor distance
You calculate all the nearest neighbor distances for events in a point pattern using the `nndist()` function. You can store the results in a new variable, which is useful for plotting them and can be helpful.

```{r}
nnd_cells <- nndist(cells)
nnd_pine <- nndist(pine)
nnd_redw <- nndist(redw)

par(mfrow=c(1,3))

hist(nnd_cells)
hist(nnd_pine)
hist(nnd_redw)
```

If you store the result as a variable, as we did above, then you can find the means

```{r}
mnnd_c <- mean(nnd_cells)
mnnd_p <- mean(nnd_pine)
mnnd_r <- mean(nnd_redw)
```

No direct way to test these is provided in `spatstat`, so you need to calculate your own expected value for the result, using the result given in the reading that the expected mean nearest neighbor distance for a point pattern is 1 / (2&sqrt;&lambda;) where &lambda; is the density or intensity of the pattern.

This is easy enough, for example:

```{r}
emnnd_c <- 1 / (2 * sqrt(intensity(cells)))
emnnd_c
```

You can then compare expected and actual mean NND values. You can put them on the histogram to compare them visually. You do this using the `abline` function, which can draw arbitrary lines on the most recent plot you made.

```{r}
hist(nnd_cells)
abline(v=mnnd_c, col='red', lwd=2)
abline(v=emnnd_c, col='red', lwd=2, lty='dashed')
```

As you can see, in the histogram, the expected mean NND (dashed line as set by the line type parameter `lty`) is very much less than the actual, which shown as a solid red line.

### The *G*, *F*, *K* and *g* (or PCF) functions
Nearest neighbor distances on their own aren’t very useful. An array of functions using either nearest neighbor distances (*G* and *F*) or all the inter-event distances (*K* and *g*, also known as the *pair correlation function*, PCF) are more useful and informative. These are easy to calculate and plot:

```{r}
par(mfrow=c(2,2))

plot(Gest(redw), main="G function Redwoods")
plot(Fest(redw), main="F function Redwoods")
plot(Kest(redw), main="K function Redwoods")
plot(pcf(redw), main="PCF function Redwoods")
```

The `est` part of these function names indicates that these are 'estimated' functions. Note that I've included more readable names for the plots shown, using the `main` option (for *main title*). Each plot shows the function itself calculated from the pattern as a solid black line, and dotted lines showing slight variations depending on how we correct for edge effects (check the help if you want more on the details of this).

The solid black line and the dotted blue line are the most relevant. The dotted blue line is the expected line for a pattern produced by complete spatial randomness, and is the baseline for comparison that you should consider when evaluating such plots.

You will find that it’s hard to see what is going on with the *K* function because the shape of the curve and how far it deviates from the expected line may be difficult to see. The PCF is more useful, but does have a problem that the range of values at short distances can be very large. This is a result of details of how it is calculated. You can limit this by setting y-limits on the plot with the `ylim` parameter.

```{r}
plot(pcf(redw), ylim=c(0, 2))
```

While these basic plots are helpful, they don't allow us to statistically assess the deviation of patterns from randomness (or potentially from other point process models). To do this we make use of the envelope function to calculate many random values for the function and compare it with the actual data. In its simplest form, this is very easy:

```{r}
plot(envelope(redw, pcf), ylim=c(0,4))
```

I’ve shown this for PCF, but it can easily be changed for any of the other functions `Fest`, `Gest` or `Kest`. When this runs, *R* tells you that it is running 99 simulations of complete spatial randomness (CSR) for the data, and it is using these to construct the envelope of results shown in gray in the plot.

The black line shows the function as calculated from the data, and the idea is to compare the two. Anywhere that the data (the black line) is inside the envelope from the simulation results, we can say that it is consistent with what we would expect from the simulated process, but when it is outside the range, it indicates some kind of departure from the simulated process. Here, you will see when you run the envelope for PCF on the redwood dataset that at distances below about 0.06 the PCF is unexpectedly high, indicating clustering at these distances. There is a small departure below the envelope around 0.23, but this appears minor and may not be very important, although it may relate to the scale of the gaps in the redwood pattern.

Note that the envelope is very high at very short distances, but this is an artifact of how PCF is calculated and can be safely ignored in interpretation.

You can also use this method to compare your pattern to any pattern produced by any process, given that complete spatial randomness is unlikely in practice (redwoods don’t just fall out of the sky). So it may be more interesting to see how a pattern compares to one that is more likely given your observed data.

An example might be to use the intensity derived from the data, as a basis for an inhomogeneous Poisson process. This allows you to partially separate first and second order effects. Here's an example

```{r}
# calculate density surface for the cells data
dc <- density(cells, sigma=0.2)
# use it to simulate an inhomogeneous Poisson process
env <- envelope(cells, pcf, simulate=expression(rpoispp(dc)), nsim=99)
plot(env, ylim=c(0,4), main='Envelope for 499 simulations PCF, cells')
```

And now make the plots.

```{r}
plot(dc, main="Density of cells, sigma=0.2")
plot(cells, add=TRUE)
```

The code `simulate=expression(rpoispp(dc)), nsim=499` in the envelope function tells spatstat *not* to use complete spatial randomness for the simulated patterns that determine the envelope, but instead to use the function provided in the expression statement.

Here I have specified that `rpoispp(dc)` should be used, which is an inhomogeneous Poisson process based on the density calculated from the pattern. That means that the simulated patterns include first order effects from the original pattern, so remaining departures from expectations should reflect second order effects only.

The plot confirms this: there is evidence for a lack of inter-event distances up to around 0.1, and also evidence of ‘too many’ inter-event distances around 0.15 (which is the near-uniform spacing of the events in this pattern).

**This is a fairly advanced concept, but it is worth trying to get your head around it, as it is the basis on which the most sophisticated point pattern analysis work in research settings is performed.**  See if you can run a similar analysis for the Redwood dataset (or indeed for the assignment dataset).

# Point pattern analysis with real data
Now we need to read two data files, one with the point events and one with the study area. These are [here](ak-tb-cases.geojson?raw=true) and [here](ak-tb.geojson?raw=true).

```{r}
ak <- readOGR("ak-tb.geojson")
tb <- readOGR("ak-tb-cases.geojson")
```

Check that things line up OK.

```{r}
plot(ak)
plot(tb, add=T)
```

## Reprojecting the data
For PPA we really need to be working in a projected coordinate system that uses real spatial units (like metres, even better kilometres), not latitude-longitude.

```{r}
ak@proj4string
tb@proj4string
```

By now you should recognise these as 'unprojected' lat-lon, which is no good to us. We should instead use the New Zealand Transverse Mercator. We get the proj4 string for this from an appropriate source, and then make a CRS object and use it to transform the two layers. I have modified the projection to centre it on Auckland (the `lat_0` and `lon_0` settings), and also to make the units km (the `units` setting) rather than metres as this has a dramatic effect on how well `spatstat` runs. It also makes it easier to interpret results meaningfully.

```{r}
nztm <- CRS('+proj=tmerc +lat_0=-36.83 +lon_0=174.75 +k_0=0.996 +x_0=1600 +y_0=10000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=km +no_defs')

ak <- spTransform(ak, nztm)
tb <- spTransform(tb, nztm)
```

Now we should check that things still line up OK.

```{r}
plot(ak)
plot(tb, add=T)
```

## Converting spatial data to `spatstat` data
OK. So much for the spatial data. `spatstat` works in its own little world and performs PPA on `ppp` objects, which have two components, a set of (x,y) points, and a study area or 'window'.

This is quite a fiddly business, which never seems to get any easier (every time I do it, I have to look it up in help).

Here is a series of steps that will work.

First we can make a `ppp` object from the points data

```{r}
tbpp <- as(tb, 'ppp')
plot(density(tbpp))
plot(tbpp, add=T)
```

This would be fine except that the study area has defaulted to a rectangular bounding box determined by the most extreme points in the data. What we actually need is a meaningful study area. For that we have to use the `ak` polygon data, but we need to dissolve all the census area units in the dataset into a single polygon. To do this we need to make a new attribute identical across all polygons on which to base the dissolve operation.

```{r}
ak$dissolve <- 1
```

Then we can run a function `unionSpatialPolygons` from the `maptools` package:

```{r}
ak_all <- unionSpatialPolygons(ak, IDs=ak$dissolve)
plot(ak_all)
```

We use this to make an `owin` object

```{r}
w <- as(ak_all, 'owin')
```


and then make this the analysis window for the point pattern object.

```{r}
tbpp$window <- w
plot(density(tbpp))
plot(tbpp, add=T)
```

Finally, it turns out we have made a `marked point pattern` which is one where several attribute values (the marks) are associated with each point. This is because we started with data that had a number of attributes associated with each location. This is surplus to requirements in a simple point pattern analysis exercise, so we can throw this information away

```{r}
tbpp$marks <- NULL
plot(density(tbpp))
plot(tbpp, cex=0.5, add=T)
```

If we were doing a lot of this kind of analysis starting with lat-lon datasets, then we would most likely build a function from some of the elements above to automate all these steps. In this case, since we are only running the analysis once for this lab, I will leave that as an exercise for the reader...

# **The assignment: A point pattern analysis of the Auckland TB data**
Now you have a point pattern dataset to work with (`tbpp`), you can perform point pattern analysis with it.

## Assignment deliverables
The submission deadline is **8 April at 9:30AM**. A dropbox will be provided on Blackboard. You should assemble materials in a word processor (export images from RStudio to PNG format) and produce a PDF report. Include your name in the filename for ease of identification. You should not read to write more than about 500 words, although your report should include a number of figures. Note that quality of cartography is not an important aspect of this assignment.

You need to do two things:

### First (25%)
Present kernel density surfaces of the tuberculosis data.

**You should present three different density surfaces, and explain which are likely to be the most useful in different contexts.**

Explain what bandwidths you have selected, and the basis for your choice. (Remember that the distance units are km.)  Keep in mind that there is no absolute right answer, and that the various suggestions you can get from functions available (see the section about kernel density) are only suggestions. You might want to make selections close to these but rounded to more readily understood values, for example.

You will need to present maps of the density surfaces.

### Second (50%)
Conduct a point pattern analysis of the data and report the results.

You may use whatever methods from those available (quadrats, mean nearest neighbors, *G*, *F*, Ripley’s *K*, the pair correlation function) that you find useful, and that you feel comfortable explaining and interpreting. You should use at least one of the simulation envelope based methods.

You will need to present graphs or other output on which your analysis is based.

### Third (25%)
Comment on what the principle drivers of the tuberculosis incidents might be. Consider how you might run point pattern analysis to take account of such factors. What might a better null model for the occurrence of incidents be in this case than the default of complete spatial randomness?
