getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")
mushroom_occurrences<- read.csv("pres_abs.csv")
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/solar_radiation")

library(terra)
library(dplyr)
head(mushroom_occurrences)
tail(mushroom_occurrences)
nrow(mushroom_occurrences)

#do not need the first column
mushroom_occurrences  <- mushroom_occurrences[,-1]

# Set the variable and months of interest
variable <- "srad"
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
srad_data <- rast(r_list)
srad_data

# Extract tavg values for each observation point
srad_values <- extract(srad_data, mushroom_occurrences[, c("lon", "lat")])
View(srad_values)
#do not need the first column
srad_values  <- srad_values[,-1]

View(srad_values)
# Get layer index for each occurrence point
layer_index <- as.numeric(mushroom_occurrences$month)
print(layer_index[2])

# Create data frame with tavg and occurrence data
srad_occurrence <- data.frame(
  species = mushroom_occurrences$species,
  month = mushroom_occurrences$month,
  year = mushroom_occurrences$year,
  lat = mushroom_occurrences$lat,
  lon = mushroom_occurrences$lon,
  present = mushroom_occurrences$present,
  srad = srad_values[cbind(1:nrow(srad_values), layer_index)]
)
head(srad_occurrence)

# Check for NaN values
sum(is.na(srad_occurrence))#439

summary(srad_occurrence)

#I suspect these values are values that are not on land. I will until I add the other predictors and then remove

getwd()
write.csv(srad_occurrence,"srad.csv")