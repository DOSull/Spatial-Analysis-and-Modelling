# Statistical models

```{r message = FALSE}
library(raster)
library(sf)
library(tmap)
library(dplyr)
library(tidyr)
library(ggplot2)
# setwd("~/Documents/geodata/plants")
```

## Preamble
Statistical modelling is a huge area and we are just going to look at a single example of one application in a spatial context, that of logistic regression as a stand in for classic GIS binary overlay operations. I have slides on this topic here:
+ [From overlay to regression](https://southosullivan.com/geog315/from-overlay-to-regression/)
+ [Introduction to regression](https://southosullivan.com/geog315/regression/)
+ [More on regression](https://southosullivan.com/geog315/more-on-regression/)

In class I will speak briefly to these before diving into the material below.

## Environment layers
There are a bunch of raster data sets in a folder called `layers`. We can read them all into a raster `stack` by listing the directory as follows

```{r message = FALSE, warning = FALSE}
layer_sources <- file.path("layers", dir(path = "layers"))
layers <- stack(layer_sources)
```

There might be some complaining about projections (this is to do with recent changes in how projections are handled by the `proj` tools see [this post](https://cran.r-project.org/web/packages/rgdal/vignettes/CRS_projections_transformations.html) but you can ignore it for now).

The layers in the stack were assembled from [LENZ](https://www.landcareresearch.co.nz/tools-and-resources/mapping/lenz/) data developed by Manaaki Whenua Landcare Research, and available [here](https://lris.scinfo.org.nz/). Their interpretations are roughly as follows (this information from the `disdat` package).

Layer name | Explanation | Units
-- | -- | --
age	| Soil age | 3 classes (0 to 2): <2000, 2000-postglacial (app. 30,000), and pre-glacial
deficit	| Annual water deficit | mm (higher is greater deficit)
dem |	Elevation |	metres
mas |	Mean annual solar radiation |	MJ/m2/day
mat |	Mean annual temperature |	degrees C * 10
r2pet	| Average monthly ratio of rainfall and potential evapotranspiration | (ratio)
rain |	annual precipitation | mm
slope | Slope	| degrees
sseas |	Solar radiation seasonality |	dimensionless
tseas	| Temperature seasonality |	degrees C
vpd	| Mean October vapor pressure deficit at 9 AM |	kPa

We can map any particular layer of interest as follows:

```{r}
tmap_mode("view")
tm_shape(layers$dem) +
  tm_raster(palette = "Oranges", style = "cont", alpha = 0.8)
```

An entire stack of layers like this can be mapped in one go with a simple `plot` command:

```{r}
plot(layers)
```

or if you like a bit more cartographic polish use `tmap` (but do this in plot mode, and it might be slow anyway...):

```{r warning = FALSE, message = FALSE}
tmap_mode('plot')  # best to do this in plot mode
tm_shape(layers) +
  tm_raster(title = names(layers)) +
  tm_layout(legend.position = c("RIGHT", "BOTTOM")) +
  tm_facets(free.scales = TRUE) # this allows a different scale for each layer
```

(Note that we shoudln't have to supply the `title = ...` setting, but [there seems to be a bug](https://github.com/mtennekes/tmap/issues/166) and this seems to work around it.)

## Plant presence-absence data
I obtained presence-absence data for the mysterious 'nz35' species from the [`disdat` package]() with some more details but not plant identities, unfortunately in [this paper](https://dx.doi.org/10.17161/bi.v15i2.13384).

```{r}
plants <- st_read("nz35-pa.gpkg")
plants.d <- plants %>%
  dplyr::select(-siteid) %>%
  st_drop_geometry()
```

In this dataset the attribute `nz35` is 1 where the plant has been observed and 0 where it has not (or where synthetic absence data has been generated).

Map these on any chosen environment layer like this

```{r}
tmap_mode("view")
tm_shape(layers$dem) +
  tm_raster(palette = "Oranges", style = "cont", alpha = 0.8) +
  tm_shape(plants) +
  tm_dots(col = "nz35", palette = "Set1", style = "cat")
```

## Making a statistical model
### An overlay approach
If we are interested in the distribution of this species (whether because it is invasive, or because it is endangered!) then this is a classic GIS setting for doing some kind of overlay analysis.

We might for example based on inspection, or expert knowledge, or on some other basis choose cutoff values in each environmental layer and make binary maps for each. For example

```{r}
dem_bin <- layers$dem < 800
tm_shape(dem_bin) +
  tm_raster(palette = "Greys")
```

We could apply this approach to every layer, and then combine layers by summation or logical combination of the various inputs.

This is what is happening in classical GIS overlay. Unfortunately it assumes that each factor operates independently of all others, and has the same effect regardless of location (so, for example 800m elevation is always the critical elevation in all cases.)

To make the approach a bit more principled or 'evidence-based', we might examine plots of the distribution of each environmental factor relative to the presence-absence data. To do this we need to extract the values at each point in the presence-absence data so we can contrast them. This is easily done with the `raster::extract` function

```{r}
df <- as.data.frame(raster::extract(layers, plants))
plants.d <- plants.d %>%
  bind_cols(df)
```

We can then do things like

```{r}
ggplot(plants.d) +
  geom_boxplot(aes(x = nz35, y = dem, group = nz35))
```

If we wanted the 'full picture' in this way, we can also do that

```{r}
plants.d.long <- plants.d %>%
  pivot_longer(-nz35)

ggplot(plants.d.long) +
  geom_point(aes(x = nz35, y = value)) +
  facet_wrap(~ name, scales = "free")
```

However, this is getting us quite deep in the weeds of more advanced data exploration in *R*. It also doesn't seem to be very illuminating, so... carrying out an overlay analysis is left as an exercise for the reader...

Instead...

### A statistical approach
In the final analysis, overlay is really about considering how different factors make locations more or less suitable, or more or less likely, to sustain (or inhibit) the presence of some phenomenon of interest, be it a plant, an animal, a mineral, a facility, a hazard, or whatever.

This is exactly the business of statistical modelling.

A regression model, the most common type of statistical model tells us for some given combination of inputs (the *independent variables*) what the expected mean value of the output (the *dependent variable*) will be, based on the observed combinations of the variables in the empirical data.

Different types of model are appropriate in different contexts. Here, because the dependent variable of interest is binary, true/false, presence/absence, the most appropriate model form is *logistic*. We can make this kind of model like this

```{r}
logistic_model <- glm(nz35 ~ dem + mas, data = plants.d, family = "binomial")
summary(logistic_model)
```

This is a very simple model for the probability of presence of the plant, based only on the elevation and the mean annual solar radiation (the `dem` and `mas` attributes in our data.) There are various kinds of statistical tests we can run on it, but we'll not worry too much about those here, instead we can map the predictions, and focus on that. To map the predictions, we need to calculate for locations across the whole study area, so this takes a while, but just as with interpolation we can 'predict' values into a raster layer, this time though it is drawing on the layers in the raster stack, and the information contained in the model to make the prediction outputs.

```{r}
predicted_presence <- predict(layers, logistic_model, type = "response")
```

And we can map this result in the usual way

```{r}
tm_shape(predicted_presence) +
  tm_raster(palette = "YlOrRd")
```

Fitting models and chooseing which of the many possible ones we could is a complex process, based on expertise, on the data and on measures of model quality, In the summary above the results suggest that `mas` is more important to the result, than `dem`. Building on this, we might drop `dem` and try again adding in some other factor, or several other factors.

We could also use automated approaches. A base R function for this is `step` which given a base model will try dropping variables to find a best model:

```{r}
step(logistic_model)
```

This approach uses a measure of model quality (AIC, Akaike's Information Criterion *smaller is better*) and in the above example, when the stepping process tries dropping either variable AIC gets worse (AIC gets higher), so it suggests that working with those two variables only, the best model is one that includes both.

This makes it tempting to go all in:

```{r}
logistic_model <- glm(nz35 ~ age + deficit + dem + mas + mat + r2pet + rain + slope + sseas + tseas + vpd, data = plants.d, family = "binomial")
step(logistic_model)
```

There are good reasons not to do this, but just to see what we end up with the resulting model is

```{r}
logistic_model <- glm(formula = nz35 ~ deficit + dem + mat + rain + sseas + tseas,
    family = "binomial", data = plants.d)
predicted_presence <- predict(layers, logistic_model, type = "response")
```

And map as before

```{r}
tm_shape(predicted_presence) +
  tm_raster(palette = "Greys") +
  tm_shape(plants) +
  tm_dots(col = "nz35", palette = "Set1")
```

Measures of how good a model this is in its ability to predict accurately depend on how well, as we change the decision threshold (i.e. what probability value of the predicted result we use to predict 'presence') we do in predicting true positives and false positives. This can be summarised using an 'area under the curve' statistic available in the `pROC` package:

```{r message = FALSE}
library(pROC)
x <- roc(plants.d$nz35, fitted(logistic_model))
plot(x)
auc(x)
```
