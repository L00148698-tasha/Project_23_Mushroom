library(geodata)
library(terra)
library(dplyr)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
getwd()
# Download fractional tree cover at 30-sec resolution:
# Please note that you have to set download=T if you haven't downloaded the data before:
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
trees_30sec <- landcover(var='trees', path='Tree', download=F)

# map the tree cover
plot(trees_30sec)
# change the extent
#check the coordinate reference system
crs(trees_30sec)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)
trees<-crop(trees_30sec,ext)
ext(trees)
# Extract elev values for each observation point
tree_vals <- extract(trees, mushroom_occurrences[, c("lon", "lat")])
nrow(tree_vals)
tree_vals  <- tree_vals[,-1]

# Create data frame with tree and occurrence data

tree_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  tree = tree_vals
)
head(tree_occurrence)

getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Tree")
write.csv(tree_occurrence,"tree.csv")
writeRaster(trees,"trees.tif")

