getwd()

setwd("C:/Final_Project/project_2023_mushroom")
#read in the mushroom data
#mushroom_occurrence<-read.csv("mushroom_data.csv")
mushroom_occurrence<- read.csv("pres_abs.csv")

setwd("E:/Year4/Project/Datasets")
#install.packages("sf")

library(terra)
all_land<-rast("warped_landcover.tif")
plot(all_land)

#check the coordinate reference system
crs(all_land)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)

all_cropped<-crop(all_land,ext)

plot(all_cropped)
View(all_cropped)

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
occurence_land_values<-extract(all_cropped,points_spatvector)
points(points_spatvector)
View(occurence_land_values)

#remove the first column
occurence_land_values <- occurence_land_values[,-1]

land_occurrence <-data.frame(cbind(land_type=occurence_land_values,lat=mushroom_occurrence$lat,lon=mushroom_occurrence$lon))
sum(is.na(land_occurrence))

# Count the number of NA values
num_na <- sum(is.na(land_occurrence))

# Get the indices of the NA values
na_indices <- which(is.na(land_occurrence), arr.ind = TRUE)

na_indices
# Subset the original data frame to show the NA values
na_points <- land_occurrence[na_indices[,1], ]
na_points

#convert to spatvector
na_points_sp <- vect(na_points)

plot(all_cropped)
points(na_points_sp)

#looks like they are all outside of the map and coordinates are wrong
#remove them when I join to the climate data for now change them to 255

# Replace the NA values with 255
land_occurrence[is.na(land_occurrence)] <- 255

land_occurrence

#merge with the occurence data
# Create data frame with prec and occurrence data
land_occurrence_data <- data.frame(
  species = mushroom_occurrence$species,
  day = mushroom_occurrence$day,
  month = mushroom_occurrence$month,
  year = mushroom_occurrence$year,
  lat = mushroom_occurrence$lat,
  lon = mushroom_occurrence$lon,
  landType = occurence_land_values,
  present = mushroom_occurrence$present
)
head(land_occurrence_data)

View(land_occurrence_data)

unique_land <-unique(land_occurrence_data$landType)

num_unique_species <- length(unique_land)

species_counts <- table(land_occurrence_data$landType)
View(species_counts)

#can see that 128 is outside of the area will remove these values

setwd("C:/Final_Project/project_2023_mushroom")
write.csv(land_occurrence_data,"land_pres_absoccurrence.csv")


climate_occurrence<-read.csv("climate_occurrence.csv")

#merge the forest data
clim_land_occurence<-data.frame(climate_occurrence, landType = land_occurrence_data$landType)
head(clim_land_occurence)

setwd("C:/Final_Project/project_2023_mushroom")
write.csv(clim_land_occurence,"clim_land_occurrence.csv")



