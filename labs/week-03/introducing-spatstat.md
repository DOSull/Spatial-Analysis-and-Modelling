#### GISC 422 T1 2019
# Introducing `spatstat` and experimenting with (spatial) point processes
This lab introduces the `spatstat` library and its capabilities, and asks you to explore the variation we observe in spatial point processes. This is essential preparation for next week's assessed lab assignment on point pattern analysis, and also should develop your understanding of the concept of a 'process' in spatial analysis.

## Getting started
`spatstat` should already be installed on the lab machines. You should be able to load it with

```{r}
library(spatstat)
```

If there is a problem then install the package with

```
install.packages("spatstat", dependencies=TRUE)
```

We will also need `RColorBrewer` for nice colour schemes:

```{r}
library(RColorBrewer)
```

Finally one mysterious command, which we might need later (but run this now).

```{r}
pardefaults <- par()
```

## What is `spatstat`
A user guide for **`spatstat`** is [available here](http://spatstat.org/resources/spatstatJSSpaper.pdf)

For our purposes, what you really need to know is that `spatstat` is the most powerful tool around for doing point pattern analysis.

Consequently you can use `spatstat` to generate a wide variety of point patterns using a range of point processes. Among these are the following *R* commands

+ `rpoint()` generates a specified number of random uniform distributed points
+ `rpoispp()` generates random points distributed according to some specified intensity pattern (which can be uniform or not)
+ `rThomas()` generates clustered points via a 'parent-child'' process
+ `rSSI()` generates points that exclude one another from being within some specified distance of each other

There are several others also available. You can see the full list in the general help page for the package in the subsection entitled **To simulate a random point pattern**.

## Making a point pattern
Before we dive into this more fully, you can make a point pattern by invoking one of the above commands, and assigning the result to a variable. A simple example is to use a simple random point pattern with 100 events, assigning the result to a variable called `point_pattern`.

```{r}
point_pattern <- rpoint(100)
```

That makes the point pattern. To get information about the pattern we use

```{r}
point_pattern
```

and to plot it we use

```{r}
plot(point_pattern)
```

An important thing to notice here is that the `window` in which the pattern has been generated is a *unit square* with coordinates from (0, 0) to (1, 1). This indicates that `spatstat` is not concerned with real world geographical coordinates as such, and is an issued we have to deal with when we come to work with real world data. For now it doesn't matter because we are more interested in understanding point processes, not point pattern analysis *per se*.

Anyway, we will be using the above basic sequence of commands a lot in this lab (and probably the next one also, so make sure you understand it. Try changing the number of events in the pattern. Or try using one of the other point processes. For any process more complicated than `rpoint()` or `rpoispp()` you will need to specify more than one parameter. Take a look at the documentation (using `?rpoispp()` or similar, to see if you can figure out what parameters to provide.

### Pre-cooked built in point patterns
`spatstat` provides some simple point pattern datasets, which we'll use to explore ways to visualize point patterns (particularly density estimation). The built in datasets are `redwoodfull`, `japanesepines` and `cells`. We access them by using the `data` command

```{r}
data(redwoodfull)
data(japanesepines)
data(cells)
```

Those names are annoying to type so we can assign them to different variables for convenience

```{R}
rw <- redwoodfull
jp <- japanesepines
ce <- cells
```

We can plot any of these individually or request more information by typing its name, or using `summary()`. Give it a try. In particular, plot the patterns and think about the ways in which they differ from one another.

It is often useful in R to see a number of plots side-by-side, which we can do by issuing a `par()` command to change the *graphics parameters*. If we want one row of three plots side by side, we get this using

```{R}
par(mfrow=c(1,3)) # this means, 1 row, 3 columns
plot(rw)
plot(ce)
plot(jp)
```

This can look a bit weird because of the margins that *R* chooses automatically and how those interact with plotting window dimensions. Experiment with changing the size of your plot area in $RStudio$, or alternatively you can fiddle with the plotting parameters (although this gets messy fast). For example setting the `mai` plot parameter, changes the margins around each plot.

```{R}
par(mfrow=c(1,3), mai=c(0.1, 0.1, 0.1, 0.1))
plot(rw)
plot(ce)
plot(jp)
```

### Restoring order to the plot window
There are a *lot* of plot parameters available in *R* (check the help with `?par`, and it is easy to get in a tangle with them. To restore some order you can do

```{R}
par(pardefaults)
```

which will reset things to the values that we saved at the start of the session using that mystery command.

## Visualizing the intensity (density) of a point pattern
An important way to improve our sense of a point pattern is to create density map of it. We can do this with the `density()` command. The sequence of commands below shows how to do this and overlay the point pattern itself.


```{R}
plot(density(rw))
plot(rw, add=T)
```

The density surface bandwidth (the larger this is the smoother the surface produced) is automatically chosen by $R$, but we can opt instead to set a bandwidth

```{R}
par(mfrow=c(1,3))
d05 <- density(rw, sigma=0.05)
plot(d05, main='bw=0.05')
plot(rw, add=T)
d10 <- density(rw, sigma=0.1)
plot(d10, main='bw=0.1')
plot(rw, add=T)
d25 <- density(rw, sigma=0.25)
plot(d25, main='bw=0.25')
plot(rw, add=T, main='bw=0.25')
```

The `sigma` parameter controls the bandwidth used. Note that the dimensions of the region covered by the built in point patterns are a 1 by 1 square, and the bandwidth is expressed in the same units.  In cases where you are working with datasets that extend over 100s or 1000s or meters or miles (or whatever) you have to express the bandwidth required appropriately.

Experiment with settings in the previous cells until you feel confident with plotting density maps of point patterns.

### Nicer colors
The color scheme used by default for density maps is ... not great. We can change it out for a Color Brewer palette which may be preferable.

```{R}
par(mfrow=c(1,3))
plot(density(rw), col=brewer.pal(9, 'Reds'))
plot(rw, add=T)
plot(density(rw), col=brewer.pal(9, 'YlGnBu'))
plot(rw, add=T)
plot(density(rw), col=brewer.pal(9, 'Greys'))
plot(rw, add=T)

```

A final tweak to the appearance, is to make the events smaller, which can sometimes make things easier to see.

```{R}
par(mfrow=c(1,3), cex=0.5)
plot(density(rw), col=brewer.pal(9, 'Blues'))
plot(rw, add=T)
plot(density(rw), col=brewer.pal(9, 'RdBu'))
plot(rw, add=T)
plot(density(rw), col=brewer.pal(9, 'PRGn'))
plot(rw, add=T)
```

Make sure you have a good idea of how all these options work before proceeding to the next section.

## The lab proper: exploring point processes
The point (ahem) of this lab is to experiment with making point patterns using `spatstat` commands, to examine them, and to comment on them.  To support this aim, you might find it useful to plot densities, with the points superimposed on top, as in the previous section.  To make the point patterns use the commands mentioned above and further explained below.

The next sections explain some of the point process commands available in a bit more detail.

### The independent random process (or 'complete spatial randomness')
The `rpoint()` or `rpoispp()` commands will generate patterns with no first or second order effects such that there is no bias in where events occur and no interaction between events. `rpoint()` is simpler and will produce exactly the number of events requested. `rpoispp` is a *Poisson process* and produces events at the requested *intensity* per unit area. Since the default region for a point pattern in `spatstat` is a 1 by 1 unit square, this will seem very similar to `rpoint()` except that the number of events produced in a particular realization of `rpoispp()` will vary each time you run it.

```{R}
par(mfrow=c(1,2))
p1 <- rpoint(100)
p2 <- rpoispp(100)
plot(p1)
plot(p2)
```

You can confirm these patterns have different numbers of events using the `summary()` command.

### Patterns with first order effects: the inhomogeneous Poisson process
If this was all you could do with `rpoispp()` it probably wouldn't justify it being a completely different point process than `rpoint()`. In fact, it can do a lot more. If instead of specifying a number, which produces a uniform intensity, you provide a function, then you can introduce spatial trends across the area occupied by the pattern.

```{R}
par(mfrow=c(1,3))
p1 <- rpoispp(function(x,y){200*x^2 + 200*y^2})
p2 <- rpoispp(function(x,y){200*(1-x)^2 + 200*y^2})
p3 <- rpoispp(function(x,y){400*(x-0.5)^2 + 400*(y-0.5)^2})
plot(p1, main='SW-NE trend')
plot(p2, main='NW-SE trend')
plot(p3, main='Increasing from the center')
```

In these patterns a fixed value for the process intensity is replaced with a function that converts an `x` and `y` value into a number according to some formula. For `p1` the function is defined by the code `function(x,y){200*x^2 + 200*y^2}` in other words, 200*x*<sup>2</sup>+200*y*<sup>2</sup>. Since the default coordinates that the pattern is generating are in the unit square from (0, 0) to (1, 1) the pattern intensity ranges from 0 to 400 events per unit area with increasing intensity from low coordinates at the lower left to higher coordinates at the upper right.

#### Try this
To convince yourself that the trends in the titles of those plots are real, try mapping the density of the point pattern in each case, i.e. for patterns `p1`, `p2` and `p3`.

It's worth noting that you can also define the function for the intensity outside of the commande to make the point pattern&mdash;this is especially more convenient if the function is complex.  For example

```{R}
# I have no idea why you would have a slope like this but it shows the idea
complicated_slope <- function(x,y) {
    return(200 * (x * sin((y+0.5) * 2*pi/3) + y * cos((x-0.5) * 2*pi/3)))
}
```

And here it is in action

```{R}
p <- rpoispp(complicated_slope)
plot(density(p))
plot(p, add=T)
```

### Introducing second order effects
There are a number of point processes that will introduce second order (interaction) effects into a pattern. I will not explain them in detail, but suggest that you consult help (or ask during lab time) for full details. First is a *simple sequential inhibition* process provided by the `rSSI()` command, which can simulate competition for space between point events and yields evenly spaced patterns.  Second is a 'parent-child' clustering process known as the *Thomas process* which the `rThomas()` command simulates.

The gist of it is:

+ *SSI* has two parameters. The first is an inhibition distance within which new events are not placed closer to existing events, and the second is the number of events that the process will attempt to randomly place given the inhibition constraint.
+ The *Thomas process* takes three parameters.  The first specifies the intensity of a Poisson process that generates 'parent' events, the second specifies a distance that 'child' events will be scattered away from their parents, and the third specifies the average number of children that each parent will produce.

Here are some example plots:

```{R}
par(mfrow=c(2,2), cex=0.5)
plot(rSSI(0.01, 100))
plot(rSSI(0.08, 100))
plot(rThomas(10, 0.1, 10))
plot(rThomas(25, 0.8, 4))
```

## Things to try
Try making point patterns that exhibit
1. no first and second order effects
2. clear first order effects, and
3. clear second order effects

Try to get such patterns not just the obvious way (e.g., using `rpoispp` to make a pattern with no first or second order effects), but using a process that might not be expected to produce a pattern with those properties.

What I mean is this: make plots of patterns that **you know** to have first or second order effects in operation, but where how those effects act produces patterns that don’t obviously exhibit those effects.

For example, see if you can make the Thomas process produce patterns that don`t *appear* clustered, or if you can get realizations of a simple random process that appear to include clusters, or a trend.  
