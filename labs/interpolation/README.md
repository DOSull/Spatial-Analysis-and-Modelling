#### GISC 422 T1 2021
# Interpolation overview
I am not going to lie... spatial interpolation, whatever tool you use, is complicated and messy. Not the least of the problems is that you are going back and forth between point data (the control points) and field data (the interpolated surface output).

The materials for interpolation extend across two weeks of lab sessions, with a single assignment asking you to perform interpolation on some data provided and comment on the results and process in the usual way. You'll find all the materials you need bundled in [this zip archive](interpolation.zip?raw=true) which you should unpack and set as your working folder in *RStudio*. I've provided `.Rmd` files this time, which you may find more useful even than usual.

The steps along the way are described in the instructions below. You'll get the most out of these working through them in order:

+ [The overall approach to interpolation](01-overview-of-the-approach.md) in *R* using `gstat`
+ [The example dataset](02-example-dataset.md)
+ [Preparing for interpolation](03-preparing-for-interpolation.md) by making an output layer, etc.
+ [Near neighbour and inverse-distance weighted interpolation](04-nn-and-idw.md)
+ [Trend surfaces and kriging](05-trend-surfaces-and-kriging.md)
+ [Splines](06-splines.md)
+ [Other *R* packages and platforms](07-other-r-packages.md)

And then of course...

+ [The assignment](08-assignment-interpolation.md)

## Videos
Coming soon...