library(terra)
library(dplyr)
getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Elevation")
elevation<-rast("wc2.1_30s_elev.tif")
plot(elevation)

# change the extent
#check the coordinate reference system
crs(elevation)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)

elev<-crop(elevation,ext)

plot(elev)

# Extract elev values for each observation point
elev_values <- extract(elev, mushroom_occurrences[, c("lon", "lat")])
View(elev_values)

#remove the first col
elev_values  <- elev_values[,-1]

# Create data frame with elev and occurrence data
elev_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  elev = elev_values
)
head(elev_occurrence)

write.csv(elev_occurrence, "elev.csv")