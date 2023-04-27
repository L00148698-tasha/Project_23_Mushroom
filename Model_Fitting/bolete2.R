getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data")
alldata<-read.csv("sdmData.csv")

library(terra)


#tak in the raster stack for displaying plots
#split for just boletus edulis
head(alldata)
#remove index
alldata <- alldata[,-1]
head(alldata)
predictors<-rast("predictors.tif")

#remove index
#sdmData <- sdmData[,-1]
head(alldata)

#split the species to bolet
# Specify the desired species name
target_species <- "Boletus edulis"

# Create a new data frame with only the rows for the target species
boletus_ed <- alldata[alldata$species == target_species, ]

#split the data

present <- boletus_ed[boletus_ed$present == 1, ]
absent<-boletus_ed[boletus_ed$present == 0, ]

nrow(present)
nrow(absent)


# remove column b
presvals <- dplyr::select(present, -present,-month,-year,-species,-lat,-lon)

library(sp)
absent_xy <-terra::vect(absent[,c("lon", "lat")])
crs(absent_xy) <- crs("+init=EPSG:4326")
library(terra)
absvals <- terra::extract(predictors, absent_xy)


pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
head(presvals)
head(absvals)
absvals <- absvals[,-1]
sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))

plot(predictors[[1]])
library(geodata)
wrld <- world(path=".")
lines(wrld)


#split the present data
set.seed(0)
group <- kfold(present, 5)
pres_train <- present[group != 1, ]
pres_test <- present[group == 1, ]
nrow(pres_train)#2801
nrow(pres_test)#700

#split the bacg data
group <- kfold(absent, 5)
backg_train <- absent[group != 1, ]
backg_test <- absent[group == 1, ]
nrow(backg_train)
nrow(backg_test)


envtrain <- rbind(pres_train,backg_train)
envtrain<-dplyr::select(envtrain, -species,-month,-year,-lat,-lon)

testpres<-dplyr::select(pres_test, -species,-month,-year)

testbackg<-dplyr::select(backg_test, -species,-month,-year)




library(randomForest)
## randomForest 4.6-14
## Type rfNews() to see new features/changes/bug fixes.
model <- present ~ tavg + prec + bare + tree + grass + cropland + elev + wetland
rf1 <- randomForest(model, data=envtrain)
## Warning in randomForest.default(m, y, ...): The response has five or fewer
## unique values. Are you sure you want to do regression?
model2 <- factor(present) ~ tavg + prec + bare + tree + grass + cropland + elev + wetland
rf2 <- randomForest(model2, data=envtrain)
#rf3 <- randomForest(envtrain[,1:8], factor(pb_train))
erf <- evaluate(testpres, testbackg, rf1)
erf

erf2 <- evaluate(testpres, testbackg, rf2)

#getting the AUC plot over .9 represents a model with good predictive power
plot(erf, 'ROC')

pr <- predict(predictors, rf1, ext=ext)

pr2<- predict(predictors, rf2, ext=ext)

library(geodata)
wrld <- world(path=".")

lines(wrld)


pres_train_sp <-terra::vect(pres_train[,c("lon", "lat")])
backg_train_sp <-terra::vect(backg_train[,c("lon", "lat")])

par(mfrow=c(1,2))
plot(pr, main='Random Forest, regression')
plot(wrld, add=TRUE, border='dark grey')
tr <- threshold(erf, 'spec_sens')
plot(pr > tr, main='presence/absence')
plot(wrld, add=TRUE, border='dark grey')
points(pres_train_sp, pch='+',col="blue")
points(backg_train_sp, pch='-', cex=1)


par(mfrow=c(1,2))
plot(pr2, main='Random Forest, classification')
plot(wrld, add=TRUE, border='dark grey')

getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/PredictionData")
writeRaster(pr,"predictBolete.tif")


















