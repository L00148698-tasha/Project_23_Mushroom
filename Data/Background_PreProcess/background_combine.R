library(terra)
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Bare")
bare<-read.csv("bare.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Cropland")
cropland<-read.csv("cropland.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Elevation")
elev<-read.csv("elev.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Grass")
grass<-read.csv("grass.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Tree")
tree<-read.csv("tree.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/Wetland")
wetland<-read.csv("wetland.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/precipitation_avg")
prec<-read.csv("prec.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/temperature_avg")
tavg<-read.csv("tavg.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/solar_radiation")
srad<-read.csv("srad.csv")

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/water_vapor_pressure")
vapr<-read.csv("vapr.csv")


# Create data frame with all data
occ_pred <- data.frame(
  tavg,
  prec =prec$prec,
  srad =srad$srad,
  vapr=vapr$vapr,
  bare = bare$bare,
  tree = tree$tree,
  grass = grass$grass,
  cropland = cropland$cropland,
  elev = elev$elev,
  wetland =wetland$wetland
)
head(occ_pred)
#do not need the first column
occ_pred  <- occ_pred[,-1]

getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data/")
write.csv(occ_pred,"occ_pred.csv")