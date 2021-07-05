#================TUSSOCK EXTRACTION USING R==========#
#Ellis et al., (2021) 'Comparing fine-scale structural and hydrologic connectivity within unimproved and improved grassland', Ecohydrology
#DEM available in supplementary information, furhter information available upon request

#Input: .las file
#Output: .tiff file of tussock tops
setwd("Location")
library(lidR)
library(PointCloudViewer)
library(rlas)
library(EBImage)
library(geometry)
library(ggplot2)
library(dplyr)
library(sf)
#Note: C++ also required for interactive plotting


#========plot las file using c++========#
las <- readLAS("molinia_dc_subet.las")
#Plot data
plot(las, backend = "pcv")


#========classify ground points========#
las = lasground(las,csf (sloop_smooth = FALSE, class_threshold = 0.01,
                         cloth_resolution = 0.5, rigidness = 1L, iterations = 500L, time_step = 0.65))
#Plot data
plot(las, color = "Classification", backend = "pcv")


#========height normalise the data========#
#Sets ground to 0
las = lasnormalize(las, tin())
#Plot data
plot(las, backend = "pcv")

#Compute canopy height
algo = pitfree(thresholds = c(0,1,2,3,4,5), subcircle = 0)
#Change grid_canopy value as needed
chm = grid_canopy(las, 0.05, algo)
#PLot data
plot(chm, col = height.colors(100))


#============Raster============#
#tussock plot
crowns = lidR::watershed(chm, th = 0.008)()
#Plot raster
plot(crowns, col = pastel.colors(100))

writeRaster(crowns, "tussocks3", format = "GTiff")
#end of classification sequence
print('End of classification sequence')
