library(ggplot2)
library(dplyr)
library(CoordinateCleaner)
library(tidyverse)

getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Mushroom_data")

mushroom_all <-read.csv("mushroom_all.csv")
head(mushroom_all)
tail(mushroom_all)

mushroom_all <- mushroom_all[,c("species","scientificName","verbatimScientificName","decimalLatitude","decimalLongitude", "day", "month","year")]


nrow(mushroom_all) #26696

#remove dates that are older than 1970
mushroom_all <- subset(mushroom_all, year >= "1970")
nrow(mushroom_all) #23985

#the climate data only is recorded from 1970 to 2000 but we will lose a lot of the data if i remove records from 2000 onwards. 
#these temperatures are averages so for brevity it will be easier just to use the same data

# variables to filter the coordinates for the study area
xmin<- -14
xmax<-4
ymin<-49
ymax<-61.3

#create new frame remove data outside these coordinates
filtered_data <- mushroom_all %>%
  filter(decimalLongitude>xmin,decimalLongitude<xmax, decimalLatitude>ymin,decimalLatitude<ymax)

nrow(filtered_data) #23985

#list this names to check if any are different
unique(filtered_data$scientificName)
#list this names to check if any are different
unique(filtered_data$verbatimScientificName)

## research the names maybe the have different scientific names
#count the number in the list
count(filtered_data,scientificName)



# Cantharellus pallens Pilǭt is not the yellow traditional chanterelle this must be removed
#Boletus persoonii Bon not the Edulis- remove
#Cantharellus cibarius var. salmoneus L.Corb. uknown remove
#Pleurotus salignus (Pers.) P.Kumm.    remove


#remove the wrong values
filtered_data <- filtered_data[!(filtered_data$scientificName %in% c("Cantharellus pallens Pilǭt",
                                                                     "Boletus persoonii Bon",
                                                                     "Cantharellus cibarius var. salmoneus L.Corb.",
                                                                     "Pleurotus salignus (Pers.) P.Kumm.")), ]

## research the names maybe the have different scientific names
#count the number in the list
count(filtered_data,scientificName)

#now that the species have been filtered the column species can be used
count(filtered_data,species)

nrow(filtered_data) #23973

#check for duplicated rows
#remove any duplicated rows in the data
duplicated_rows <- duplicated(filtered_data)
duplicated_rows

# Subset the data frame to remove duplicates
filtered_data <- filtered_data[!duplicated(filtered_data), ]
print(filtered_data)

nrow(filtered_data) #20491

# Use duplicated() to check for duplicates based on scientificName and coordinates to remove the same data point
duplicated_rows_name_coord <- duplicated(filtered_data[, c("scientificName", "decimalLatitude", "decimalLongitude")])

duplicated_rows_name_coord
data_unique <- filtered_data[!duplicated(filtered_data[, c("scientificName", "decimalLatitude", "decimalLongitude")]), ] 

nrow(data_unique)#10543

count(data_unique,species) 

write.csv(data_unique,"data_unique.csv")

#species    n
#1             Boletus edulis 1515
#2           Calocybe gambosa  790
#3          Calvatia gigantea  955
#4      Cantharellus cibarius 1447
#5           Coprinus comatus 3774
#6 Craterellus cornucopioides  231
#7    Craterellus tubaeformis  470
#8        Pleurotus ostreatus 1361


#remove the data that has the same name and coordinates halves the data set. This is problematic. But I will create 2 datasets so I can test at a later stage

#check the coordinates
library(CoordinateCleaner)

test<-clean_coordinates(
  filtered_data,
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  species = "species")

summary(test)

#I will test these myself when plotting 

# Get a map of the region for the british isles 
map <- map_data("world",regions = c("IRELAND","UK"),)

# Create a ggplot object and add the map outline layer
plotMap <- ggplot() +
  geom_polygon(data = map, aes(x = long, y = lat, group = group), fill = "white", color = "black")

#add the layer for the data points
plotMap <- plotMap +
  geom_point(data = data_unique, aes(x = decimalLongitude, y = decimalLatitude,color = species),size =1)+
  scale_fill_manual(values = c("#ff6961", "#ffb480", "#f8f38d", "#42d6a4", "#08cad1","#59adf6","#9d94ff","#c780e8"))
#show the plot
plotMap

##definitetly a few outliers that will need to be removed but will achieved this when plotting against the land maps as they are more accurate
getwd()
write.csv(filtered_data,"filtered.csv")
