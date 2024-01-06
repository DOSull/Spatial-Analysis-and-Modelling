#### GISC 422 T2 2023
# A first look at data wrangling in *R*
Data wrangling is not something you will really learn in this course, but unavoidably we will doing some of it along the way. More so when we come to look at large messy multivariate datasets later in the course.

But it is appropriate to introduce a few key ideas up front so that you have an idea what is going on in some of the lab instructions.

First just make sure we have all the data and libraries loaded as before.

```{r}
library(sf)
library(tmap)

auckland <- st_read("ak-tb.geojson")
cases <- st_read('ak-tb-cases.geojson')
rds <- st_read("ak-rds.gpkg")
```

# Introducing the `tidyverse`
The [`tidyverse`](https://www.tidyverse.org/) is a large collection of packages for handling data in a 'tidy' way. This document can only look at these very quickly, but will hopefully begin to give you a flavour of what is possible, encourage you to explore further if you need to, and help you understand what is happening in some of the instructions where some data preparation is needed.

Like *R* itself the `tidyverse` is largely inspired by the work of another New Zealander, [Hadley Wickham](http://hadley.nz/)... Aotearoa represent!

We can't really get into the philosophy of it all here. Instead we focus on some key functionality provided by functions in the `dplyr` package. We will also look at processing pipelines using the `%>%` or 'pipe' operator.

So... load these libraries

```{r}
library(dplyr)
library(ggplot2)
library(tidyr)
```

If any of them aren't installed, then install them in the usual way, and load them again.

## Data tidying with `dplyr`
The core tidying operations in `dplyr` are

+ _selecting_ columns to keep or reject
+ _slicing_ rows to keep or reject
+ _filtering_ data based on attribute values
+ _mutating_ data values by combining them or operating on them in various ways

### `select`
A common requirement in data analysis is selecting only the data attributes you want, and getting rid of all the other junk. A function for looking at data tables is `as_tibble()` (provided by the `tidyr` package). Use it to take a look at the `rds` dataset

```{r}
as_tibble(rds)
```
Notice that the `suffix` and `other_name` attributes don't seem to contain any useful data. In base R we could get rid of them by noting the column numbers and doing something like `rds <- rds[, c(1:2, 5:19)]` which is not particularly nice to read or to deal with. The `select` is much easier to read:

```{r}
select(rds, -suffix, -other_name)
```
The minus signs on the names actually tell R to _drop_ the named columns.

Selecting only columns of interest is easy, using the `select` function, we simply list them
```{r}
select(rds, road_name, road_class)
```
This hasn't changed the data, we've just looked at a selection from it. But we can easily assign the result of the selection to a new variable

```{r}
rds_reduced <- select(rds, road_name, road_class)
```

What is nice about `select` is that it provides lots of different ways to make selections. We can list names, or column numbers, or use colons to include all the columns between two names or two numbers, or even use a minus sign to drop a column. And we can use these (mostly) in all kinds of combinations. For example

```{r}
select(rds, 1:2, road_class)
```

or
```{r}
select(rds, -(3:4))
```

Note that here I need to put `3:4` in parentheses so it knows to remove all the columns 1 to 10, and doesn't start by trying to remove a (non-existent) column number -3.

### Selecting rows
We look at filtering based on data in the next section. If you just want rows, then use `slice()`

```{r}
slice(rds, 2:10, 15:25)
```

## `filter`
Another common data tidying operation is filtering based on the attributes of the data. This is provided by the `dplyr::filter` function. Note that we use the fully qualified function name `dplyr::filter` because there is a base *R* function called `filter` which does something different (this is a common source of problems). We provide a filter specification, usually data based to perform such operations

```{r}
dplyr::filter(rds, road_class == 1)
```
Notice how this has reduced the size of the dataset. If we want data that satisfy more than one filter, we combine them filters with **and** `&` and **or** `|` operators

```{r}
dplyr::filter(rds, road_type == "ROAD" & road_class == 1)
```

Using select and filter in combination, we can usually quickly and easily reduce large complicated datasets down to the parts we really want to look at. We'll see a lit bit later how to chain operations together into processing pipelines. First, one more tool is really useful, `mutate`.

## `mutate`
Selecting and filtering data leaves things unchanged. Often we want to combine columns, in various ways. This option is provide by the `mutate` function

```{r}
mutate(rds, full_name = paste(road_name, road_type))
```

This has added a new column to the data by combining other columns using some function. In this case we use the base *R* `paste` function to combine text columns (there are better ways to do this but we won't worry about that for now).

## Combining operations into pipelines
Often we want to do several things one after another combined in a workflow or processing pipeline that can easily become fiddly and hard to read (not executable code, but you get the idea):

```
a <- select(y, ...)
b <- dplyr::filter(a, ...)
c <- mutate(b, ...)
```

and so on. To combine these operations into a single line you would do something like this

```
c <- mutate(dplyr::filter(select(y, ...), ...), ... )
```

but this can get very confusing very quickly. The order of operations is opposite to the order they are written, and keeping track of all those opening and closing parentheses is error-prone.

The tidyverse introduces a 'pipe' operator `%>%`, which, once you get used to it, simplifies things greatly. Instead of the above, we have

```
c <- y %>% select(...) %>%
           dplyr::filter(...) %>%
           mutate(...)
```

This reads "assign to c the result of passing y into select, then into filter, then into mutate". Here is an nonsensical example with the `rds` dataset, combining operations from the previous three sections

```{r}
rds %>%
  select(starts_with("road_")) %>%
  dplyr::filter(road_class <= 2) %>%
  mutate(full_name = paste(road_name, road_type))
```

This is introduced here not in the expectation that you will remember it, but so that you have some idea what's going on if the approach is used in later lab instructions. We may spend more time on these ideas later in the semester after all that lab assignment materials have been introduced.

### `sf` and pipelines
`sf` functions are pipeline aware and compliant. This means you can pass `sf` objects through tidy pipelines, and also that the various `st_` prefixed functions provided by `sf` for handling spatial data, can be included in such pipelines. So we can add on to the end of the above pipeline

```{r}
rds %>%
  select(starts_with("road_")) %>%
  dplyr::filter(road_class <= 2) %>%
  mutate(full_name = paste(road_name, road_type)) %>%
  st_transform(st_crs(auckland))
```

#### Finally: `sf` geometry is 'sticky'
Also worth noting is that the geometry column in an `sf` dataset isn't dropped if you use an operation like `select(data, -geometry)` on it. It wants to stick around. This is good, because it means you can't accidentally ditch the spatial part of a dataset. But sometimes you just want the data table (some analytical functions can't handle the spatial information, for example). In these cases use the `st_drop_geometry` function:

```{r}
rds_data <- rds %>%
  st_drop_geometry()
as_tibble(rds_data)
```
