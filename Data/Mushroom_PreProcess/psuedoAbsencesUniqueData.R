library(terra)
library(sp)
library(dismo)

setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Climate_Data/temperature_avg")

#need to use the raster file to plot and for the study area bounding extent 
study_area <- rast("wc2.1_30s_tavg_01.tif")

#check the coordinate reference system
crs(study_area)

#use variables to set the extent
ext <-ext(-14,4,49,61.3)

study_area<-crop(study_area,ext)

#get the presence data so that we can create random points that are outside of this area
getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")

# removed duplicate data 
presence_dup_data <- read.csv("data_unique.csv")

# Get unique species names from presence_dup_data
unique_species <- unique(presence_dup_data$species)

# Create a list to store the data frames
species_dfs <- list()

# Loop through unique species names and create data frames
for (species_name in unique_species) {
  species_df <- presence_dup_data[presence_dup_data$species == species_name, ]
  species_dfs[[species_name]] <- species_df
}

# Create an empty dataframe to store the resulting data
result_df <- data.frame()
head(presence_dup_data)
sum(is.na(presence_dup_data))
# Loop through each species name
for (species_name in unique_species) {
  # Access individual data frames by species name
  one_df <- species_dfs[[species_name]]
  
  # Count the number of present values for the current species
  n_present <- nrow(one_df)
  
  # Create random points for the current species
  species_lat_lon <- one_df[c("lon", "lat")] 
  species_rand_excl <- dismo::randomPoints(raster(study_area), n_present, p=species_lat_lon)
  
  # Create a data frame with species name and random lat/lon values
  species_rand_df <- data.frame(species = species_name,
                                lon = species_rand_excl[, "x"],
                                lat = species_rand_excl[, "y"])
  
  # Generate a vector of random months
  months <- sample(1:12, n_present, replace = TRUE)
  
  # Add the "month" column to the dataframe
  species_rand_df <- mutate(species_rand_df, month = months)
  
  # Add the "day" column to the dataframe
  species_rand_df <- mutate(species_rand_df, day = 10)
  
  # Generate a vector of random years
  years <- sample(1980:2020, n_present, replace = TRUE)
  
  # Add the "year" column to the dataframe
  species_rand_df <- mutate(species_rand_df, year = years)
  
  # Concatenate the resulting dataframe to the result_df
  result_df <- bind_rows(result_df, species_rand_df)
}

library(dplyr)
# Add a column "present" with all values set to 0
result_df <- result_df %>%
  mutate(present = 0)
# Print the resulting dataframe
head(result_df)
tail(result_df)
#remove the day 
# remove columns y and z
result_df <- dplyr::select(result_df,-day)

result_df_lat_lon<- result_df[c("lon", "lat")] 
presence_dup_data_lat_lon<- presence_dup_data[c("lon", "lat")] 

plot(study_area)
points(result_df_lat_lon,cex=0.1,col='red')
points(presence_dup_data_lat_lon,cex=0.2,col='black')

nrow(result_df) #13989

#add a present column to the presnt data and set all values to 1
presence_dup_data
presence_dup_data <- presence_dup_data %>%
  mutate(present = 1)
head(presence_dup_data)
#do not need the first column
presence_dup_data  <- presence_dup_data[,-1]

# bind the two dat frames together the present and absent
pres_abs_unique<- rbind(result_df, presence_dup_data)
head(pres_abs_unique)
tail(pres_abs_unique)
#View(pres_abs_unique)
summary(pres_abs_unique)

getwd
write.csv(pres_abs_unique, "pres_abs_unique.csv")


