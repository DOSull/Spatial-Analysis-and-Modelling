# Functions to make Moran map plots


# Determines Moran cluster quadrants of results
# from localmoran function applied to the specified variable
# under the specified set of weights as specified significance level
# 1 = High - High
# 2 = Low - Low
# 3 = High - Low
# 4 = Low - High
# 5 = Non-sigificant
# result is returned as vector in order of data supplied
moran_quadrant <- function(layer, variable, w, sig = 0.01) {
  var <- layer[[variable]]
  v <- as.vector(scale(var))

  locm <- localmoran(v, w, alternative = 'two.sided', zero.policy = T)
  lv <- locm[,1]
  p <- locm[,5]
  quad <- rep(5, length(v))
  significant <- p < sig | p > (1-sig)
  quad[v > 0 & lv > 0 & significant] = 1
  quad[v <= 0 & lv > 0 & significant] = 2
  quad[v > 0 & lv <= 0 & significant] = 3
  quad[v <= 0 & lv <= 0 & significant] = 4
  return (quad)
}

# Produces and returns a map coloured as follows, at significance level provided
# Red: High - High
# Blue: Low - Low
# Pink: High - Low
# Light blue: Low - High
# White: Non-significant
moran_cluster_map <- function(layer, variable, w, sig = 0.01) {
  layer['q'] <- moran_quadrant(layer, variable, w, sig = sig)
  m <- tm_shape(layer) +
    tm_layout(title = "Moran cluster map", legend.position = c(.45,.75)) +
    tm_fill(col = 'q', breaks = 0:5 + 0.5, palette = c('red', 'blue', 'pink', 'lightblue', 'white'),
            labels = c('High - High', 'Low - Low', 'High - Low', 'Low - Ligh', 'Non-significant'),
            title = paste("Moran quadrant, p<", sig, " level", sep = "")) +
    tm_borders(lwd = 0.5)
  return (m)
}


# Produces a map showing signifcance levels of local Moran's index
moran_significance_map <- function(layer, variable, w) {
  localm <- localmoran(layer[[variable]], w, alternative = 'two.sided', zero.policy = T)
  layer['pr'] <- as.vector(localm[,5])
  layer$pr <- pmin(layer$pr, 1-layer$pr)
  m <- tm_shape(layer) +
    tm_layout(title = "LISA Significance map", legend.position = c(.45,.72)) +
    tm_fill(col = 'pr', breaks = c(0, 0.001, 0.01, 0.05, 1), palette = "-Greens",
            title = "Significance level") +
    tm_borders(col = 'gray', lwd = 0.5)
  return (m)
}
