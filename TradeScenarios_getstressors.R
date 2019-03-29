# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs: 2) read stressor data
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

# read hist stressors
stressorpath <- 'Matlab_GetFEMRIOdata/EXIOhist/'
CO2hist <- as.numeric(read.csv(file = paste0(stressorpath,'CO2.csv'),header=FALSE))
EMPLdetailhist <- as.matrix(read.csv(file = paste0(stressorpath,'EMPL.csv'),header=FALSE))
EMPLhist <- colSums(EMPLdetailhist)
DEfoshist <- as.matrix(read.csv(file = paste0(stressorpath,'DEfos.csv'),header=FALSE))
DEmethist <- as.matrix(read.csv(file = paste0(stressorpath,'DEmet.csv'),header=FALSE))
DEnmmhist <- as.matrix(read.csv(file = paste0(stressorpath,'DEnmm.csv'),header=FALSE))
DEforhist <- as.matrix(read.csv(file = paste0(stressorpath,'DEfor.csv'),header=FALSE))

foresthist <- colSums(DEforhist)
fossilhist <- colSums(DEfoshist)
metalshist <- colSums(DEmethist)
nmmshist <- colSums(DEnmmhist)

# read scenario stressors: only CO2 emissions intensities change
stressorpath <- 'Matlab_GetFEMRIOdata/2degrees/'
CO22DS <- as.numeric(read.csv(file = paste0(stressorpath,'CO2.csv'),header=FALSE))
stressorpath <- 'Matlab_GetFEMRIOdata/6degrees/'
CO26DS <- as.numeric(read.csv(file = paste0(stressorpath,'CO2.csv'),header=FALSE))
#dim(CO22DS)
