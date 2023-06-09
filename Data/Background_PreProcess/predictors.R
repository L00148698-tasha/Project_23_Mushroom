library(terra)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Bare")
bare<-rast("bare.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Cropland")
cropland<-rast("cropland.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Elevation")
elev<-rast("elev.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Grass")
grass<-rast("grass.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Tree")
tree<-rast("trees.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Wetland")
wetland<-rast("wetland.tif")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/precipitation_avg")
prec<-rast("wc2.1_30s_prec_09.tif")

# change the extent
#check the coordinate reference system
crs(prec)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)
prec<-crop(prec,ext)
plot(prec)

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/temperature_avg")
tavg<-rast("wc2.1_30s_tavg_09.tif")
tavg<-crop(tavg,ext)
plot(tavg)


predictors<-c(bare,cropland,elev,grass,prec,tavg,tree,wetland)
summary(predictors)

# Define new names        lat        lon tavg prec elev  trees  grass present
new_names <- c("bare","cropland","elev","grass","prec","tavg","tree","wetland")
# Change the names in the raster stack
names(predictors) <- new_names
plot(predictors)

getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
writeRaster(predictors,"predictors.tif", overwrite=T)
