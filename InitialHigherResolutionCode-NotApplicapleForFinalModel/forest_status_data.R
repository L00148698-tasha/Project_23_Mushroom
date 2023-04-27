getwd()

setwd("C:/Final_Project/project_2023_mushroom/mushroom_data/data_all")
#read in the mushroom data
#mushroom_occurrence<-read.csv("mushroom_data.csv")
mushroom_occurrence<- read.csv("pres_abs.csv")


#setwd("C:/Final_Project/project_2023_mushroom/forest_data")
#install.packages("sf")

setwd("E:/Project2023Data/forest_data")


library(terra)
all_forest<-rast("all_forest_02_03_2257.tif")
plot(all_forest)

#check the coordinate reference system
crs(all_forest)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)

forest_cropped<-crop(all_forest,ext)

plot(forest_cropped)
View(forest_cropped)

#get the spatial point from the occurrence data
library(sp)

# Create a SpatialPoints object from the x and y columns
coords <- cbind(mushroom_occurrence$lon, mushroom_occurrence$lat)
#use the same coordinate reference system
sp <- SpatialPoints(coords,proj4string = CRS("+proj=longlat"))

# Convert to a SpatVector object
points_spatvector <- vect(sp)

plot(points_spatvector)

#extract the values
occurence_forest_values<-extract(forest_cropped,points_spatvector)
points(points_spatvector)
View(occurence_forest_values)

#remove the first column
occurence_forest_values <- occurence_forest_values[,-1]

forest_occurrence <-data.frame(cbind(forestType=occurence_forest_values,lat=mushroom_occurrence$lat,lon=mushroom_occurrence$lon))
sum(is.na(forest_occurrence))

# Count the number of NA values
num_na <- sum(is.na(forest_occurrence))

# Get the indices of the NA values
na_indices <- which(is.na(forest_occurrence), arr.ind = TRUE)

na_indices
# Subset the original data frame to show the NA values
na_points <- forest_occurrence[na_indices[,1], ]
na_points

#convert to spatvector
na_points_sp <- vect(na_points)

plot(forest_cropped)
points(na_points_sp)

#looks like they are all outside of the map and coordinates are wrong
#remove them when I join to the climate data for now change them to 255

# Replace the NA values with 255
forest_occurrence[is.na(forest_occurrence)] <- 0

forest_occurrence

#merge with the occurence data
# Create data frame with prec and occurrence data
forest_occurrence_data <- data.frame(
  species = mushroom_occurrence$species,
  day = mushroom_occurrence$day,
  month = mushroom_occurrence$month,
  year = mushroom_occurrence$year,
  lat = mushroom_occurrence$lat,
  lon = mushroom_occurrence$lon,
  forest = occurence_forest_values,
  present = mushroom_occurrence$present
)
head(forest_occurrence_data)


setwd("C:/Final_Project/project_2023_mushroom")
write.csv(forest_occurrence_data,"forest_pres_abs_occurrence.csv")

#get the climate occurence data
setwd("C:/Final_Project/project_2023_mushroom/climate_data")

climate_occurrence<-read.csv("climate_occurrence.csv")

#merge the forest data
clim_for_occurence<-data.frame(climate_occurrence, forest = forest_occurrence_data$forest)
head(clim_for_occurence)

setwd("C:/Final_Project/project_2023_mushroom")
write.csv(clim_for_occurence,"clim_for_occurence.csv")

climateLand <-read.csv("clim_for_occurrence.csv")
#remove 255's
climateLand <- climateLand[climateLand$forest != 255, ]



  


