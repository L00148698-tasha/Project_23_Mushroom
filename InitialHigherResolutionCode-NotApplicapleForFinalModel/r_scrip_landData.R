install.packages("raster")
install.packages(".tif")
install.packages("sf")
install.packages("rgdal")
install.packages("dplyr")
install.packages("ggplot2")

library(raster)
library(sf)
library(dplyr)
library(ggplot2)
getwd()
# Set the directory where the tif files are located
setwd("E:/Year4/Project/Version Control/projectR_Mushroom/land_raster/land_raster_100m/DATA")

# Load  tif files in the directory into a RasterStack
land_data <- raster("U2018_CLC2018_V2020_20u1.tif")
plot(land_data)
print(land_data)

pasture <- land_data == 231

broadleaf_forest <- mask(land_data, land_data == 311)

print(land_data(Label3))