# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs: 1) read macro regression data
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

regrespath <- 'Matlab_GetFEMRIOdata/regres/'

HOUS <- as.matrix(read.csv(file = paste0(regrespath,'HOUS.csv'),header=FALSE))
HOUS_eps <- as.matrix(read.csv(file = paste0(regrespath,'HOUS_eps.csv'),header=FALSE))
GFCF <- as.matrix(read.csv(file = paste0(regrespath,'GFCF.csv'),header=FALSE))
GFCF_eps <- as.matrix(read.csv(file = paste0(regrespath,'GFCF_eps.csv'),header=FALSE))
GOVE <- as.matrix(read.csv(file = paste0(regrespath,'GOVE.csv'),header=FALSE))
GOVE_eps <- as.matrix(read.csv(file = paste0(regrespath,'GOVE_eps.csv'),header=FALSE))
NPSH <- as.matrix(read.csv(file = paste0(regrespath,'NPSH.csv'),header=FALSE))
NPSH_eps <- as.matrix(read.csv(file = paste0(regrespath,'NPSH_eps.csv'),header=FALSE))




#MacroData.HOUS(:,t) = regres.HOUS(:,1) + regres.HOUS(:,2).*MacroData.GDPTRtemp(:,t) - regres.HOUS_eps(:);