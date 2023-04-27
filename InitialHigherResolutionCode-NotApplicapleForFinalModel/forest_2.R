install.packages("terra")
install.packages("geodata")
install.packages("dismo")
install.packages("raster")
install.packages("sp")
install.packages("leaflet")
install.packages("ggplot2")
install.packages("ggcorrplot")

getwd()
setwd("D:/sdm_23/project_2023/project_23")
mushroom <-read.csv("unique_mushroom_data.csv")
head(mushroom)
tail(mushroom)

#change the column names
names(mushroom) <- c("ID", "species", "lat","lon","day","month","year")
View(mushroom)
#switch the lat lons
mushroom[, c("lon", "lat")] <- mushroom[, c("lat", "lon")]
head(mushroom)

# create a list of data frames, with one data frame per species
mushroom_data_list <- split(mushroom, mushroom$species)

# access a specific data frame by its name trimming any whitespace
mushroom_data_boletus <- mushroom_data_list[trimws("Boletus edulis Bull.")]
View(mushroom_data_boletus)

class(mushroom_data_boletus)

# convert the list to a data frame
boletus_edulis <- data.frame(mushroom_data_boletus)
View(boletus_edulis)

#change the column names
names(boletus_edulis) <- c("ID", "species", "lat","lon","day","month","year")
head(boletus_edulis)


library(terra)
library(geodata)
setwd("D:/sdm_23/project_2023/project_23/total_ld_cover/ld_cover/DATA")
r <- rast("U2018_CLC2018_V2020_20u1.tif")
r
levels(r)
head(cats(r)[[1]])
lat <- c(51.105, 51.195, 51.188, 51.239)
lon <- c(4.392, 4.395, 4.896, 4.468)
xy <- cbind(lon, lat) 
v <- vect(xy, crs="+proj=longlat")
vv <- project(v, crs(r))

extract(r, vv)
activeCat(r) <- "CODE_18"
print(activeCat(r))
extract(r, vv)

# Create a mask layer that identifies forest areas
forest_mask <- r == 312

forest_cover <- mask(r, forest_mask)

plot(forest_cover)

x <- values(forest_cover)
memory.limit()

# Check the unique values in the raster
unique_values <- unique(values(forest_cover))
print(forest_cover)
