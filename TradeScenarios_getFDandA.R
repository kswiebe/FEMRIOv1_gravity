# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


stressorpath <- 'Matlab_GetFEMRIOdata/2degrees/'
Anat2DS <- as.matrix(read.csv(file = paste0(stressorpath,'A.csv'),header=FALSE,sep=','))
FDnat2DS <- as.matrix(read.csv(file = paste0(stressorpath,'FD.csv'),header=FALSE,sep=','))
stressorpath <- 'Matlab_GetFEMRIOdata/6degrees/'
Anat6DS <- as.matrix(read.csv(file = paste0(stressorpath,'A.csv'),header=FALSE,sep=','))
FDnat6DS <- as.matrix(read.csv(file = paste0(stressorpath,'FD.csv'),header=FALSE,sep=','))
#dim(Anat6DS)


FDshares2DS <- FDnat2DS/rep(colSums(FDnat2DS),each=dim(FDnat2DS)[1])
FDshares2DS[is.nan(FDshares2DS)] = 0
FDshares6DS <- FDnat6DS/rep(colSums(FDnat6DS),each=dim(FDnat6DS)[1])
FDshares6DS[is.nan(FDshares6DS)] = 0
