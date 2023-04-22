getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data")
sdmData<-read.csv("sdmData.csv")

library(terra)

#tak in the raster stack for displaying plots
#split for just boletus edulis
head(sdmData)
#remove index
sdmData <- sdmData[,-1]
head(sdmData)
predictors<-rast("predictors.tif")

#remove index
sdmData <- sdmData[,-1]
head(sdmData)

# Specify the desired species name
target_species <- "Boletus edulis"

# Create a new data frame with only the rows for the target species
target_species_data <- sdmData[sdmData$species == target_species, ]
head(target_species_data)
tail(target_species_data)

boletus_ed<-target_species_data

#remove the lat lons and the name
# Load the dplyr package
library(dplyr)

head(boletus_ed)
# Remove the species column from the target_species_data data frame
boletus_ed <- target_species_data %>% select(-species,-lat,-lon,-month,-year)


# Print the updated data frame
print(boletus_ed)
str(boletus_ed)

boletus_ed$present <- as.numeric(boletus_ed$present)
boletus_ed$prec <- as.numeric(boletus_ed$prec)
boletus_ed$elev <- as.numeric(boletus_ed$elev)

#Random forest as per Robert J hilmans
library(dismo)
library(randomForest)
#split the data using k fold

set.seed(123)
group <- kfold(boletus_ed, 5)
envtrain <- boletus_ed[group != 1, ]
envtest <- boletus_ed[group == 1, ]

str(envtrain)
##create 2 data frames for the test present where present ==1  and background present ==0
# Subset test presence points where present == 1
pres_train <- envtrain[envtrain$present == 1, ]

# Subset test background points where present == 0
backg_train<- envtrain[envtrain$present == 0, ]
str(backg_train)

##create 2 data frames for the test present where present ==1  and background present ==0
# Subset test presence points where present == 1
testpres <- envtest[envtest$present == 1, ]

# Subset test background points where present == 0
testbackg <- envtest[envtest$present == 0, ]


#create the model
model <- factor(present) ~ bare + cropland +elev +tree +grass + prec +tavg +wetland

rf1 <- randomForest(model, data=envtrain,mtry=3)

# Convert the factor variables to numeric in the test datasets
testpres$present <- as.numeric(testpres$present)
testbackg$present <- as.numeric(testbackg$present)
library(predicts)
erf <- evaluate(testpres,testbackg, rf1)

erf
#shows the AUC is .92 showing a good model

pr <- predict(predictors, rf1, ext=ext)

map<-predictors[[1]]

install.packages("maptools")
par(mfrow=c(1,2))
library(geodata)
wrld <- world(path=".")
library(maptools)
data(wrld_simpl)

par(mfrow=c(1,2))
plot(pr, main='Random Forest, regression')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(erf, 'spec_sens')
plot(pr > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)















