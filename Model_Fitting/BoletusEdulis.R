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

# Specify the desired species name
target_species <- "Boletus edulis"

# Create a new data frame with only the rows for the target species
target_species_data <- sdmData[sdmData$species == target_species, ]
head(target_species_data)
tail(target_species_data)

# Load the dplyr package
library(dplyr)
#remove the species name
boletus_ed <- target_species_data %>% select(-species,-lat,-lon,-month,-year)


library(corrplot)
cor_mat <- cor(boletus_ed[,-c(1:1)], method='spearman')

# We can visualise this correlation matrix. For better visibility, 
# we plot the correlation coefficients as percentages.
corrplot.mixed(cor_mat, tl.pos='lt', tl.cex=1, number.cex=1.5, addCoefasPercent=T)
boletus_ed[,'present'] = as.factor(boletus_ed[,'present']) # set column 'present' as factor, otherwise it'll do Regression
library(predicts)
set.seed(123)
group <- folds(boletus_ed, 5)
train <- boletus_ed[group != 1, ]
test <- boletus_ed[group == 1, ]

nrow(train)
nrow(test)

library(randomForest)
set.seed(123) 
myForest<- randomForest(present ~., data=train, importance=TRUE, mtry=3, ntree=200, replace=TRUE, do.trace=TRUE, keep.forest=TRUE, na.action=na.roughfix)

myForest
summary(myForest)

getTree(myForest, k=47, labelVar=TRUE)

myForest$oob.times
mean(myForest$oob.times)

myForest$err.rate

plot(myForest$err.rate[,1], type="l")


#'''''******PREDICTIONS*******'''''
class_train <- train$present

prediction_train <- predict(myForest, newdata=train) 

table_train <- table(class_train, prediction_train) # saving matrix in a table

table_train

class_test <- test$present

prediction_test <- predict(myForest, newdata=test)

table_test <- table(class_test, prediction_test)
table_test #now not perfect 

imp <- varImpPlot(myForest)
imp

varUsed(myForest, by.tree=FALSE, count=TRUE)
head(test)

library(terra)
predictors<-rast("predictors.tif")
plot(predictors)

# Print the original names
print(names(predictors))

library(geodata)
wrld <- world(path=".")

lines(wrld)

library(predicts)
p <- predict(predictors, myForest)
plot(p)
lines(wrld)


