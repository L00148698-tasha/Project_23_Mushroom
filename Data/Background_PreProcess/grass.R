library(geodata)
library(terra)
library(dplyr)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
# Download fractional grass cover at 30-sec resolution:
# Please note that you have to set download=T if you haven't downloaded the data before:
grass_30sec <- landcover(var='grassland', path='Grass', download=T)

# map the grass cover
plot(grass_30sec)
# change the extent
#check the coordinate reference system
crs(grass_30sec)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)
grass<-crop(grass_30sec,ext)
ext(grass)
# Extract elev values for each observation point
grass_vals <- extract(grass, mushroom_occurrences[, c("lon", "lat")])
nrow(grass_vals)
grass_vals  <- grass_vals[,-1]

# Create data frame with grass and occurrence data

grass_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  grass = grass_vals
)
head(grass_occurrence)

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Grass")
write.csv(grass_occurrence,"grass.csv")
writeRaster(grass,"grass.tif")