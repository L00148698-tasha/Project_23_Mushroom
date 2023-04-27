library(terra)

setwd("C:/Final_Project/project_2023_mushroom")
#read in the mushroom data
#mushroom_occurrence<-read.csv("mushroom_data.csv")
mushroom_occurrence<- read.csv("pres_abs.csv")

#setwd("D:/grassland")
setwd("E:/Project2023Data/grass_data")
library(terra)
grass_land<-rast("grassland_final.tif")
plot(grass_land)

#check the coordinate reference system
crs(grass_land)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)

all_grass_cropped<-crop(grass_land,ext)

plot(all_grass_cropped)
View(all_grass_cropped)

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
occurence_grassland_values<-extract(all_grass_cropped,points_spatvector)
points(points_spatvector)
View(occurence_grassland_values)

#remove the first column
occurence_grassland_values <- occurence_grassland_values[,-1]

grassland_occurrence <-data.frame(cbind(land_type=occurence_grassland_values,lat=mushroom_occurrence$lat,lon=mushroom_occurrence$lon))
sum(is.na(grassland_occurrence))

# Count the number of NA values
num_na <- sum(is.na(grassland_occurrence))

# Get the indices of the NA values
na_indices <- which(is.na(grassland_occurrence), arr.ind = TRUE)

na_indices
# Subset the original data frame to show the NA values
na_points <- grassland_occurrence[na_indices[,1], ]
na_points

#convert to spatvector
na_points_sp <- vect(na_points)

plot(all_grass_cropped)
points(na_points_sp)

#looks like they are all outside of the map and coordinates are wrong
#remove them when I join to the climate data for now change them to 255

# Replace the NA values with 255
grassland_occurrence[is.na(grassland_occurrence)] <- 0

grassland_occurrence

#merge with the occurence data
# Create data frame with prec and occurrence data
grassland_occurrence_data <- data.frame(
  species = mushroom_occurrence$species,
  day = mushroom_occurrence$day,
  month = mushroom_occurrence$month,
  year = mushroom_occurrence$year,
  lat = mushroom_occurrence$lat,
  lon = mushroom_occurrence$lon,
  grassland_type = occurence_grassland_values,
  present = mushroom_occurrence$present
)
head(grassland_occurrence_data)

View(grassland_occurrence_data)

unique_land <-unique(grassland_occurrence_data$landType)

num_unique_species <- length(unique_land)

species_counts <- table(grassland_occurrence_data$landType)
View(species_counts)

#can see that 128 is outside of the area will remove these values

setwd("C:/Final_Project/project_2023_mushroom")
write.csv(grassland_occurrence_data,"grassland_presabs_occurrence.csv")


clim_land_occurrence<-read.csv("clim_land_occurrence.csv")

#merge the forest data
clim_land_grass_occurence<-data.frame(clim_land_occurrence, grass = grassland_occurrence_data$grassland_type)
head(clim_land_grass_occurence)


setwd("C:/Final_Project/project_2023_mushroom")
write.csv(clim_land_grass_occurence,"clim_land_grass_occurrence.csv")

