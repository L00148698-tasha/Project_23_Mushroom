library(geodata)
library(terra)
library(dplyr)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
getwd()
# Download fractional wetland cover at 30-sec resolution:
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
# Please note that you have to set download=T if you haven't downloaded the data before:
wetland_30sec <- landcover(var='wetland', path='wetland', download=F)

# map the wetland cover
plot(wetland_30sec)
# change the extent
#check the coordinate reference system
crs(wetland_30sec)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)
wetland<-crop(wetland_30sec,ext)
ext(wetland)
plot(wetland)
# Extract elev values for each observation point
wetland_vals <- extract(wetland, mushroom_occurrences[, c("lon", "lat")])
nrow(wetland_vals)
wetland_vals  <- wetland_vals[,-1]

# Create data frame with wetland and occurrence data

wetland_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  wetland = wetland_vals
)
head(wetland_occurrence)

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Wetland")
write.csv(wetland_occurrence,"wetland.csv")
writeRaster(wetland,"wetland.tif")