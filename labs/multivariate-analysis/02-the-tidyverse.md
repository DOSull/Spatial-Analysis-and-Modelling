First just make sure we have all the data and libraries we need set up.
```{r message = FALSE}
library(sf)
library(ggplot2)
library(tidyr)
library(dplyr)

sfd <- st_read('sf_demo.geojson')
sfd <- drop_na(sfd)
sfd.d <- st_drop_geometry(sfd)
```
# Introducing the `tidyverse`
It is really helpful to have a more systematic way of dealing with large, complicated and messy datasets. Base *R* does OK at this, but can get messy very quickly. 

An alternative approach is provided by the [`tidyverse`](https://www.tidyverse.org/) a large collection of packages for handling data in a 'tidy' way, and with an associated powerful set of plotting libraries (`ggplot2`). We already looked quickly at this [back in week 2](https://github.com/DOSull/GISC-422/blob/master/labs/making-maps-in-r/02-data-wrangling-in-r.md). This page is a re-run of what we learned then. Here we again only look at these very quickly, but hopefully give you enough flavour of what is possible, and encourage you to explore further as needed.
 
We focus on some key functionality provided by functions in the `dplyr` package. We will also look quickly at processing pipelines using the `%>%` or 'pipe' operator. We'll round things off with a quick look at `ggplot2`. If you take (or have already taken) [DATA 471](https://www.wgtn.ac.nz/courses/data/471/2021/offering?crn=33154), you'll learn more about both.

## `dplyr::select` 
A common requirement in data analysis is selecting only the data attributes you want, and getting rid of all the other junk. The `sfd` dataset has a lot going on. A nice tidy tool for looking at data is `as_tibble()`
```{r}
as_tibble(sfd)
```

This shows us that we have 25 columns in our dataset (one of them is the geometry). We can get a list of the names with `names()`
```{r}
names(sfd)
```

Selecting only columns of interest is easy, using the `dplyr::select` function, we simply list them
```{r}
dplyr::select(sfd, density, Pdoctorate, perCapitaIncome)
```

Note that we specify `dplyr::select` to avoid name clashes with other package functions also called `select` which are likely to do entirely different things! 

The select operation hasn't changed the data, we've just looked at a selection from it. But we can easily assign the result of the selection to a new variable
```{r}
sfd.3 <- dplyr::select(sfd, density, Pdoctorate, perCapitaIncome)
```

What is nice about `dplyr::select` is that it provides lots of different ways to make selections. We can list names, or column numbers, or use colons to include all the columns between two names or two numbers, or even use a minus sign to drop a column. And we can use these (mostly) in all kinds of combinations. For example
```{r}
dplyr::select(sfd, 1:2, PlessHighSchool, PraceBlackAlone:PforeignBorn)
```

or
```{r}
dplyr::select(sfd, -(1:10))
```

Note that here I need to put `1:10` in parentheses so it knows to remove all the columns 1 to 10, and doesn't start by trying to remove a (non-existent) column number -1.

There are also helper functions like `starts_with()`, `ends_with()` and `contains()` to let you do selections based on variable names (this can be particularly useful with big datasets from sources like the census: take note!). For example:
```{r}
dplyr::select(sfd, contains("race"))
```

### Selecting rows
We look at filtering based on data values in the next section. If you just want specific known rows, use `slice()`
```{r}
slice(sfd, 2:10, 15:25)
```

## `dplyr::filter`
Another common data tidying operation is filtering based on attributes of the data. We provide a filter specification, usually data-based to perform such operations (again `filter` is a function name in other packages, hence the use of `dplyr::filter` to disambiguate).
```{r}
dplyr::filter(sfd, density > 0.3)
```

If we want data that satisfy more than one filter, we simply include combine the filters with **and** `&` and **or** `|` operators
```{r}
dplyr::filter(sfd, (density > 0.1 & perCapitaIncome > 0.1) | PlessHighSchool > 0.5)
```

Using select and filter in combination, we can usually quickly and easily reduce large complicated datasets down to the parts we really want to look at. What's left might still be big and complicated, but at least it will be only what we want to look at!  We'll see a lit bit later how to chain operations together into processing pipelines. First, one more tool is really useful, `mutate`.

## `mutate`
Selecting and filtering data leaves things unchanged. Often we want to combine columns, in various ways. This option is provide by the `mutate` function
```{r}
mutate(sfd, x = density + PwithKids)
```

This has added a new column to the data by adding together the values of two other columns (in this case, it's a meaningless calculation, but you should easily be able to imagine other examples that would make sense!)

`mutate` can also use `dplyr::select` selection semantics to allow you to perform the same calculation on several columns at once:
```{r}
mutate(sfd, across(starts_with("P"), ~ . * 100))
```
will convert all those proportions to percentages. This is quite a complicated topic&mdash;I'm just letting you know this is a possibility. I often have to look up applying mutate operations to multiple columns on stackechange or wherever before using it although I am getting better at it. The key idea is to use `across(<variables>, <function>)` where the variables can be specified `dplyr::select` style and the function can be specified either by name (e.g. `sqrt` or `log`) or using an expression as shown above with the `.` standing in for the value of the variable itself.

## Combining operations into pipelines
Something that can easily become tedious is this kind of thing (not executable code, but you get the idea)

    A <- dplyr::select(Y, ...)
    B <- dplyr::filter(A, ...)
    C <- mutate(B, ...)
    
and so on. Normally to combine these operations into a single line you would do something like this

    C <- mutate(dplyr::filter(dplyr::select(Y, ...), ...), ... )
    
but this can get very confusing very quickly, because the order of operations is opposite to the order they are written, and keeping track of all those opening and closing parentheses is error-prone. The `tidyverse` introduces a 'pipe' operator `%>%` which (once you get used to it) simplifies things greatly. Instead of the above, we have

    C <- Y %>% 
      dplyr::select(...) %>% 
      dplyr::filter(...) %>% 
      mutate(...)
    
This reads "assign to `C` the result of passing `Y` into `select`, then into `filter`, then into `mutate`". Here is a nonsensical example with the `sfd` dataset, combining operations from each of the previous sections
```{r}
sfd %>%
  dplyr::select(1:10) %>%
  slice(10:50) %>%
  dplyr::filter(density > 0.1) %>%
  mutate(x = density + PcommutingNotCar)
```

## Tidying up plotting with `ggplot2`
Not part of the tidyverse, exactly, but certainly adjacent to it, is a more consistent approach to plotting, particularly if you are making complicated figures. We've already seen an example of this in the previous document. Here it is again
```{r}
ggplot(sfd) +
  geom_point(aes(x = density,
                 y = medianYearBuilt,
                 colour = PoneUnit,
                 size = PownerOccUnits), alpha = 0.5) +
  scale_colour_distiller(palette = "Spectral")
```

What's going on here?! 

The idea behind `ggplot2` functions is that there should be an *aesthetic mapping* between each data attribute and some graphical aspect. The idea is discussed in [this paper about a layered grammar of graphics](http://vita.had.co.nz/papers/layered-grammar.pdf) (that's what the `gg` stands for). We've already seen an implementation of it in `tmap` when we specify `col = ` for a map variable. `ggplot2` is a more complete complete implementation of the idea. The `ggplot` function specifies the dataset, an additional layer is specified by a geometry function, in the example above `geom_point`, for which we must specify the aesthetic mapping using `aes()` telling which graphical parameters, x and y location, colour and size are linked to which data attributes.

It is worth knowing that `ggplot` knows about `sf` geospatial data, and so can be used as an alternative to `tmap` by applying the `geom_sf` function. This is a big topic, and I only touch on it here so I can used `ggplot` functions from time to time without freaking you out! I am happy to discuss further if this is a topic that interests or excites you.
```{r}
ggplot(sfd) +
  geom_sf(aes(fill = density)) + 
  scale_fill_distiller(palette = 'Reds', direction = 1)
```

Now let's get back to multivariate data. Go to [this document](03-dimensional-reduction.md).