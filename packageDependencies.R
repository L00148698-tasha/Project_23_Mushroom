# Package names
packages <- c("ggplot2","dplyr", "maps","terra","raster","dismo","tidyverse","CoordinateCleaner",
              "sp","corrplot","randomForest","predicts","geodata","maptools")

#ref for code https://statsandr.com/blog/an-efficient-way-to-install-and-load-r-packages/
# if packages are not installed then they will be installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

search()