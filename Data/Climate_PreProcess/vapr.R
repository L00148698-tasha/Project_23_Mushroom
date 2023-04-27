#water_vapor_pressure
getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/water_vapor_pressure")

library(terra)
library(dplyr)
head(mushroom_occurrences)
tail(mushroom_occurrences)
nrow(mushroom_occurrences)

#do not need the first column
mushroom_occurrences  <- mushroom_occurrences[,-1]

# Set the variable and months of interest
variable <- "vapr"
months <- sprintf("%02d", 1:12)

# Set the bounding box for the area of interest
bbox <- c(-14, 49, 4, 61.3)

# Read in the cropped data for each month
r_list <- list()
for (month in months) {
  r <- rast(paste0("wc2.1_30s_", variable,"_", month, ".tif"))
  r_cropped <- crop(r, bbox)
  r_list[[month]] <- r_cropped
}

r_list

# Stack the data for all 12 months
vapr_data <- rast(r_list)
vapr_data

# Extract tavg values for each observation point
vapr_values <- extract(vapr_data, mushroom_occurrences[, c("lon", "lat")])
View(vapr_values)
#do not need the first column
vapr_values  <- vapr_values[,-1]

View(vapr_values)
# Get layer index for each occurrence point
layer_index <- as.numeric(mushroom_occurrences$month)
print(layer_index[2])

# Create data frame with tavg and occurrence data
vapr_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  vapr = vapr_values[cbind(1:nrow(vapr_values), layer_index)]
)
head(vapr_occurrence)

# Check for NaN values
sum(is.na(vapr_occurrence))#439

summary(vapr_occurrence)

#I suspect these values are values that are not on land. I will until I add the other predictors and then remove

getwd()
write.csv(vapr_occurrence,"vapr.csv")