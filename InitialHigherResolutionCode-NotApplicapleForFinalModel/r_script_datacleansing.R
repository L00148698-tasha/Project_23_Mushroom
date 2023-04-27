setwd("E:\Year4\Project\Version Control\projectR")
completed_data_pre_cleanse <-read.csv("CompleteData/complete_mushroom_data_preCleanse.csv", fileEncoding = "latin1" )
completed_data_pre_cleanse <- completed_data_pre_cleanse[,c("gbifID","scientificName","decimalLatitude","decimalLongitude", "day", "month","year")]
#remove null values
completed_data_pre_cleanse <-na.omit(completed_data_pre_cleanse)
#view 
View(completed_data_pre_cleanse)
#remove dates that are older than 1980
completed_data_pre_cleanse <- subset(completed_data_pre_cleanse, year >= "1980")

#install packages
install.packages("dplyr")
install.packages("tidyverse")
install.packages("CoordinateCleaner")

# variables to filter the coordinates
ymin<- -14
ymax<-4
xmin<-50
xmax<-61.3

#create new frame remove data outside these coordinates

filtered_mushroom_data <- completed_data_pre_cleanse
  filter(decimalLatitude >= xmin, decimalLatitude <= xmax,
         decimalLongitude >= ymin, decimalLongitude <= ymax)

#View
View(filtered_mushroom_data)
#install ggplot2
install.packages("ggplot2")
library(ggplot2)
# Create a map using ggplot2
ggplot(data = filtered_mushroom_data, aes(x = decimalLongitude, y = decimalLatitude))+
  geom_point(aes(color = scientificName))

#add the outline of the map
ggplot() +
  geom_polygon(data = map_data("world", "British Isles"), aes(x = long, y = lat, group = scientificName), fill = "white", color = "black", alpha = 0) +
  geom_point(data = filtered_mushroom_data, aes(x = decimalLongitude, y = decimalLatitude))

# Create a world map outline
world_map <- map_data("world")

ggplot() +
  # Add the map outline
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), 
               fill = NA, color = "gray50", linewidth = 0.2) +
  # Add the data points
  geom_point(data = filtered_mushroom_data, aes(x = decimalLongitude, y = decimalLatitude, 
                                 color = scientificName), size = 3) +
  # Set the axis labels and title
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Map Outline with Data Points")
coord_cartesian(xlim = c(xmin, xmax), ylim = c(ymin, ymax))



library(ggplot2)
library(maps)
# Get the world map data within the specified coordinates
world_map <- map_data("world")
world_map <- subset(world_map, lat >= ymin & lat <= ymax & long >= xmin & long <= xmax)

# Create a plot with the map outline and data points
ggplot() +
  # Add the country outline
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), 
               fill = NA, color = "gray50", linewidth = 0.2) +
  # Add the data points
  geom_point(data = filtered_mushroom_data, aes(x = decimalLongitude, y = decimalLatitude, 
                                 color = scientificName), size = 3) +
  # Set the axis labels and title
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Map with country outline and data points") +
  # Set the limits of the x and y axis
  xlim(c(xmin, xmax)) +
  ylim(c(ymin, ymax))






