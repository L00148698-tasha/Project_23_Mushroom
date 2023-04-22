getwd()
setwd("E:/Project_23_Mushroom_git/Mushroom_Suitability_Research/Project_23_Mushroom/Data/Background_Data")
sdmData<-read.csv("sdmData.csv")

library(dplyr)
library(terra)

head(sdmData)

# Filter only the "present" data
present_data <- sdmData %>%
  filter(present == 1)

# Filter only the "absent" data
absent_data <- sdmData %>%
  filter(present == 0)

present_data
nrow(present_data)#20052

present_unique <- present_data[!duplicated(present_data[, c("species", "lat", "lon","month")]), ] 
nrow(present_unique)#13461

#count the number in the list
count(present_unique,species)

#species    n
#1             Boletus edulis 2022
#2           Calocybe gambosa 1012
#3          Calvatia gigantea 1169
#4      Cantharellus cibarius 1904
#5           Coprinus comatus 4387
#6 Craterellus cornucopioides  300
#7    Craterellus tubaeformis  578
#8        Pleurotus ostreatus 2089


#count the number in the list
count(absent_data,species)

#species    n
#1             Boletus edulis 3569
#2           Calocybe gambosa 1702
#3          Calvatia gigantea 1513
#4      Cantharellus cibarius 3156
#5           Coprinus comatus 6202
#6 Craterellus cornucopioides  462
#7    Craterellus tubaeformis  978
#8        Pleurotus ostreatus 2909


library(dplyr)

bol_absences <- present_unique %>% filter(species == "Boletus edulis" )
num1<-as.numeric(count(bol_absences))
# Reduce the number of pseudo absent points to num1
bol_reduced <- bol_absences %>% sample_n(num1)
count(bol_reduced)

cal_absences <- present_unique %>% filter(species == "Calocybe gambosa" )
num1<-as.numeric(count(cal_absences))
# Reduce the number of pseudo absent points to num1
cal_raduced <- cal_absences %>% sample_n(num1)
count(cal_raduced)

calv_absences <- present_unique %>% filter(species == "Calvatia gigantea" )
num1<-as.numeric(count(calv_absences))
# Reduce the number of pseudo absent points to num1
calv_raduced <- calv_absences %>% sample_n(num1)
count(calv_raduced)

cant_absences <- present_unique %>% filter(species == "Cantharellus cibarius" )
num1<-as.numeric(count(cant_absences))
# Reduce the number of pseudo absent points to num1
cant_raduced <- cant_absences %>% sample_n(num1)
count(cant_raduced)

cop_absences <- present_unique %>% filter(species == "Coprinus comatus" )
num1<-as.numeric(count(cop_absences))
# Reduce the number of pseudo absent points to num1 
cop_raduced <- cop_absences %>% sample_n(num1)
count(cop_raduced)

cra_absences <- present_unique %>% filter(species == "Craterellus cornucopioides" )
num1<-as.numeric(count(cra_absences))
# Reduce the number of pseudo absent points to num1
cra_raduced <- cra_absences %>% sample_n(num1)
count(cra_raduced)

tub_absences <- present_unique %>% filter(species == "Craterellus tubaeformis" )
num1<-as.numeric(count(tub_absences))
# Reduce the number of pseudo absent points to num1
tub_raduced <- tub_absences %>% sample_n(num1)
count(tub_raduced)

plu_absences <- present_unique %>% filter(species == "Pleurotus ostreatus" )
num1<-as.numeric(count(plu_absences))
# Reduce the number of pseudo absent points to num1
plu_raduced <- plu_absences %>% sample_n(num1)
count(plu_raduced)


#now join together
absent_data_red <- rbind(bol_reduced,cal_raduced,calv_raduced,cant_raduced,cop_raduced,cra_raduced,tub_raduced,plu_raduced)
count(absent_data_red,species)
head(absent_data_red)
tail(absent_data_red)
#and join back with the presnt data

sdmUniqueData <-rbind(absent_data_red,present_unique)

View(sdmUniqueData)
count(sdmUniqueData,species)

getwd()
write.csv(sdmUniqueData,"sdmUniqueData.csv")




