getwd()
library(terra)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
occ_preds<- read.csv("occ_pred.csv")

head(occ_preds)
#do not need the first column
occ_preds  <- occ_preds[,-1]

spatRaster<-rast("predictors.tif")

#only need the first one for plotting
map <- spatRaster[[1]]


library(geodata)
wrld <- world(path=".")

plot(map)
lines(wrld)

#check for nas
num_na <- sum(is.na(occ_preds))
# Get the indices of the NA values
na_indices <- which(is.na(occ_preds), arr.ind = TRUE)

na_indices

head(occ_preds)
# Subset the original data frame to show the NA values
na_points <- occ_preds[na_indices[,1], ]

na_points

#convert to spatvector
na_points_sp <- vect(na_points)
#and plot
points(na_points_sp)

#looks like most of them are on coastal areas, maybe in teh water will remove them 
#omit the points that are nas
occ_preds <- na.omit(occ_preds)
summary(occ_preds)
num_na <- sum(is.na(occ_preds))
num_na

# plot the final data set to check for any issues

plot(map)
lines(wrld)

occ_points <- vect(occ_preds)
points(occ_points)


#get the spatial point from the occurrence data
library(sp)

# Create a logical vector indicating which rows have 'present' value equal to 1
present <- occ_preds$present == 1

# Create a SpatialPoints object from the x and y columns
coords <- cbind(occ_preds$lon[present], occ_preds$lat[present])
#use the same coordinate reference system
sp <- SpatialPoints(coords,proj4string = CRS("+proj=longlat"))

# Convert to a SpatVector object
points_spatvector <- vect(sp)

plot(map)
lines(wrld)

points(points_spatvector)

#points are all within land now to check the values of the predictors
summary(occ_preds)

getwd()
write.csv(occ_preds,"occ_pred.csv")

#no value is out of the ordinary but we will plot just to make sure
#create bx plots
# create box plots for each predictor variable
par(mfrow = c(2, 2)) # set the layout of the plots
boxplot(occ_preds$tavg, main = "Temperature (Celsius)")
boxplot(occ_preds$prec, main = "Precipitation (mm)")
boxplot(occ_preds$srad, main = "Solar Radiation (W/m^2)")
boxplot(occ_preds$vapr, main = "Water Vapor Pressure (kPa)")
boxplot(occ_preds$bare, main = "Bare Ground Cover (%)")
boxplot(occ_preds$tree, main = "Tree Cover (%)")
boxplot(occ_preds$grass, main = "Grassland Cover (%)")
boxplot(occ_preds$cropland, main = "Cropland Cover (%)")
boxplot(occ_preds$elev, main = "Elevation (m)")
boxplot(occ_preds$wetland, main = "Wetland Cover (%)")

