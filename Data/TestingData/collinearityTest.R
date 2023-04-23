getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data")
occ_preds<-read.csv("occ_pred.csv")


# We first estimate a correlation matrix from the predictors. 
# We use Spearman rank correlation coefficient, as we do not know 
# whether all variables are normally distributed.
#remove the species and lat lon data[,-c(1:3)
head(occ_preds)
#do not need the first column
occ_preds  <- occ_preds[,-1]

#need to split the data to only perform the correlation on the present data and not the psuedo absent

library(dplyr)

# Filter only the "present" data
present_data <- occ_preds %>%
  filter(present == 1)

#subset the data to only include the predictors
present_data <- dplyr::select(present_data, -species, -month,-year,-lat,-lon,-present)

library(corrplot)
#check if the data is all numeric for using the corrplot
str(present_data)
present_data$present<- as.numeric(present_data$present)
present_data$tavg <- as.numeric(present_data$tavg)
present_data$prec <- as.numeric(present_data$prec)
present_data$srad <- as.numeric(present_data$srad)
present_data$elev <- as.numeric(present_data$elev)

cor_mat <- cor(present_data, method='spearman')

# We can visualise this correlation matrix. For better visibility, 
# we plot the correlation coefficients as percentages.
corrplot.mixed(cor_mat, tl.pos='lt', tl.cex=1, number.cex=1.5, addCoefasPercent=T)

corrplot(cor_mat, method='circle',order = 'AOE', addCoef.col = 'black', tl.pos = 'lt',
         cl.pos = 'n')



#temperature average, srad and vapr are all correlated will remove them fromthe data set

#remove the vapr from the data
preds_collin <- present_data[, !(colnames(present_data) == "vapr")]

preds_collin <- preds_collin[, !(colnames(preds_collin) == "srad")]

cor_mat2 <- cor(preds_collin, method='spearman')
corrplot.mixed(cor_mat2, tl.pos='lt', tl.cex=1, number.cex=1.5, addCoefasPercent=T)


#remove the from the occ to create the final data set
library(dplyr)
sdmData <- occ_preds[, !(colnames(occ_preds) %in% c("vapr", "srad"))]

head(sdmData)

getwd()
write.csv(sdmData,"sdmData.csv")
