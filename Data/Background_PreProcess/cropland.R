library(geodata)
library(terra)
library(dplyr)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
# Download fractional cropland cover at 30-sec resolution:
# Please note that you have to set download=T if you haven't downloaded the data before:
cropland_30sec <- landcover(var='cropland', path='Cropland', download=T)

# map the cropland cover
plot(cropland_30sec)
# change the extent
#check the coordinate reference system
crs(cropland_30sec)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)
cropland<-crop(cropland_30sec,ext)
ext(cropland)
plot(cropland)
# Extract elev values for each observation point
cropland_vals <- extract(cropland, mushroom_occurrences[, c("lon", "lat")])
nrow(cropland_vals)
cropland_vals  <- cropland_vals[,-1]

# Create data frame with cropland and occurrence data

cropland_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  cropland = cropland_vals
)
head(cropland_occurrence)

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Cropland")
write.csv(cropland_occurrence,"cropland.csv")
writeRaster(cropland,"cropland.tif")