# Network analysis
In this session we explore some of the tools offered by the `igraph` package in R for network analysis. These treat networks from a network science perspective, rather than from a more transportation-oriented perspective.

## Libraries
As usual, we need some libraries

```{r}
library(tmap)
library(sf)
library(igraph) # you'll need to install this
library(tidygraph) # you'll need to install this
library(ggraph) # you'll need to install this
```

## Data
Also, some data. You'll find what follows in [this zip file](week-11.zip?raw=true).

I've made both a 'geospatial' and a 'network-oriented' version of the data.

Here are the geospatial layers.

```{r}
intersections <- read_sf('network/nodes/nodes.shp')
road_segments <- read_sf('network/edges/edges.shp')
```

It is important to look at the nodes and edges in their geographical context.

```{r}
tmap_mode('view')
tm_shape(road_segments) +
  tm_lines(col='orange') +
  tm_shape(intersections) +
  tm_dots(col='red', size=0.005)
```

Here you see how the network representation treats is concerned both with nodes (or vertices) and the connections (or edges) between them.

The graph version of these data is in a single `graphml` file, which we load using the `igraph` function `read_graph`.

```{r}
G <- read_graph('network/network.graphml', format='graphml')
```

This file (which you can examine in a text editor) is in the `graphML` format, and includes information about both nodes and edges in a single combined file. This is a relatively commonly used format for exchanging network data among programs that perform graph analysis, such as [*Gephi*](https://gephi.org/).

I built all three of these datasets using the [excellent `osmnx`
package](https://github.com/gboeing/osmnx) developed by Geoff Boeing.

## Examining the graph
Now... graphs are rather complicated things. They effectively consist of two sets of entities, the nodes and the edges. Further, each edge consists of two nodes that it connects. To see this do

```{r}
G
```

What you are looking at is a rather concise summary of the graph object. It has 1114 nodes and 2471 edges. There are a number of vertex attributes (tagged v/c) such as lat, lon, y, x, and also edge attributes (tagged e/c) including a geometry. Unfortunately, the `igraph` package is not very intuitive to work with.

A recently released packages helps us out here by allowing us to see the `igraph` object in a more 'tabular' way.

```{r}
G <- as_tbl_graph(G)
G
```

This is a bit more readable, and helps us to see what we are dealing with.

Better yet would be a drawing! This turns out to be somewhat fiddly also. But here is an example.

```{r}
ggraph(G, layout='igraph', algorithm='nicely') +
  geom_node_point(colour='red', size=0.5) +
  geom_edge_link(colour='grey', width=0.5) +
  coord_equal() +
  theme_graph()
```

What the heck is that?! It's actually the same network that we saw in the map view above, but with the road segments joining nodes represented now as straight lines. This is the essence of the street network connectivity, without the complication of all the twists and turns of the roads themselves. This may not impress you very much, but once we allow ourselves to ignore the geographical detail, we can start to see the structure of the network more clearly. One way to do this is with different *graph drawing algorithms*.

One example is the multidimensional scaling algorithm, which attempts to place nodes so that their positions relate to their distances from one another in network space.

```{r}
ggraph(G, layout='igraph', algorithm='mds') +
  geom_edge_link(colour='grey', width=0.5) +
  geom_node_point(colour='red', size=0.5) +
  coord_equal() +
  theme_graph()
```

## Analysing aspects of network structure
Redrawing the graph is not very useful unless you really understand its structure. There are a number of categories of graph analysis method that can help us with this.

### Centrality measures
The centrality of a node or edge in a graph is a measure of its importance in the network sructure in some sense. This can be as simple as how many nodes a node is connected to (more is more central), although this tends not to be very interesting in a road network.

```{r}
intersections$centrality <- degree(G, mode='in')
tm_shape(road_segments) +
  tm_lines() +
  tm_shape(intersections) +
  tm_dots(col='centrality', style='cat')
```

A more interesting option is *betweenness centrality*. This determines the centrality of nodes based on how often they are found on the shortest paths in the network from every location to every other location. This approach often highlights choke points in a network.

```{r}
intersections$centrality <- betweenness(G)
tm_shape(road_segments) +
  tm_lines() +
  tm_shape(intersections) +
  tm_dots(col='centrality')
```

Additional methods are `closeness` which determines on average which nodes are closest to all others, and `page_rank` which uses a complex matrix analysis method, identical to Google's pagerank algorithm, based on random walks on the network (for this one, you have to use `centrality <- page_rank(G)$vector` to extract the values.

Give those two a try (there are many more!) to get a feel for things.

### Community detection
The connectivity structure of a network may mean that there are distinct regions within it that are relatively cut off from one another while being well connected internally. In network science these regions are known as *communities* and many algorithms have been developed to perform community detection (this is analagous to cluster detection in multivariate data). Many of these only work on *undirected* graphs, so before trying them we will open an undirected version of the graph we have been looking at.

```{r}
UG <- read_graph('network/network_.graphml', format='graphml')
intersections$community <- as.factor(membership(cluster_louvain(UG)))
tm_shape(road_segments) +
  tm_lines() +
  tm_shape(intersections) +
  tm_dots(col='community', style='cat')
```

In a relatively well connected network, it is surprising that community detection can work at all (since everywhere is pretty much connected to everywhere else!) but even so the groupings identified by this method are interesting to explore and relate to our understanding of the geography of central Wellington. There are quite a few other methods available, but my experiments suggest that for these data only `cluster_louvain`, `cluster_spinglass` and `cluster_edge_betweenness` have much luck. Give each a try, and see what you think. Is there any way to determine which partition is the most 'correct'?

## Putting the communities back into 'network space'
Having determined some communities of possible interest, it may be instructive to visualize these in the network space, determined by network structure.

```{r}
ggraph(G, layout='igraph', algorithm='mds') +
  geom_edge_link(colour='grey', width=0.5) +
  geom_node_point(aes(colour=intersections$community)) +
  coord_equal() +
  theme_graph()
```

### Conclusion
Hopefully this has given you a taste of how different the world can look when we start to consider not just simple Euclidean distances among things, but to consider their connectivity in other ways. It is worth emphasizing that a street network (even in Wellington!) is not very different to an open space in terms of the connection it affords between places. When we consider much less geographically coherent networks (such as airlines, Internet, etc.) then the 'space' opened up for exploration can be very different indeed.
