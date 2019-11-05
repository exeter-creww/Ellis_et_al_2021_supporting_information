#================TUSSOCK EXTRACTION USING R========#
setwd("E:/Drone_R")
library(lidR)
library(PointCloudViewer)
library(rlas)
library(EBImage)
library(geometry)
library(ggplot2)
library(dplyr)
library(sf)


#========plot las file using c++========#
las <- readLAS("example.las")
plot(las, backend = "pcv")


#========classify ground points========#
las = lasground(las,csf (sloop_smooth = FALSE, class_threshold = 0.01,
                         cloth_resolution = 0.5, rigidness = 1L, iterations = 500L, time_step = 0.65))
plot(las, color = "Classification", backend = "pcv")


#========height normalise the data========#
#Sets ground to 0
las = lasnormalize(las, tin())
plot(las, backend = "pcv")

#Compute canopy height
algo = pitfree(thresholds = c(0,1,2,3,4,5), subcircle = 0)
chm = grid_canopy(las, 0.05, algo)
plot(chm, col = height.colors(100))


#============Raster============#
#tussock plot
crowns = lidR::watershed(chm, th = 0.008)()
plot(crowns, col = pastel.colors(100))

writeRaster(crowns, "tussocks3", format = "GTiff")
#end of classification sequence