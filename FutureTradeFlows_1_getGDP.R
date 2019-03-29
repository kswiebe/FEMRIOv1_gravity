# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Calculating future trade flows for IEAETP2015
# 1) get GDP data
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


# 1A) get FEMRIO/EXIOBASE GDPT data
# 1B) Get OECD scenarios GDP data

################################################
# 1A) get FEMRIO/EXIOBASE GDPT data
################################################

# need to load the MacroData from FEMRIOv1IEAETP
# it is the same for the 2 degree and the 6 degree scenario


load('GLM_R/predicted/FEMRIOGDPTR.Rdata')
load('GLM_R/predicted/FEMRIOPOPU.Rdata')

year <- "2014"
EXIO2014GDPTR <- FEMRIOGDPTR[,year]
EXIO2014POPU <- FEMRIOPOPU[,year]
names(EXIO2014GDPTR) <- CountryNamesCodes[,2]
names(EXIO2014POPU) <- CountryNamesCodes[,2]
#save(file='GLM_R/predicted/EXIO2014GDPTR.Rdata',EXIO2014GDPTR)
#save(file='GLM_R/predicted/EXIO2014POPU.Rdata',EXIO2014POPU)
EXIO2014GDPTRpc <- EXIO2014GDPTR/EXIO2014POPU

year <- "2030"
IEAETP2030GDPTR <- FEMRIOGDPTR[,year]
IEAETP2030POPU <- FEMRIOPOPU[,year]
names(IEAETP2030GDPTR) <- CountryNamesCodes[,2]
names(IEAETP2030POPU) <- CountryNamesCodes[,2]
#save(file='GLM_R/predicted/IEAETP2030GDPTR.Rdata',IEAETP2030GDPTR)
#save(file='GLM_R/predicted/IEAETP2030POPU.Rdata',IEAETP2030POPU)


GDPTRpc2030 <- IEAETP2030GDPTR/IEAETP2030POPU

POPU2030 <- IEAETP2030POPU

################################################
# 1B) Get OECD scenarios GDP data
################################################
library(openxlsx)
GDPpcfactors <- as.data.frame(read.xlsx("OECDdata/OECD_data.xlsx", sheet="PotentialGDPperCap",
                        colNames=TRUE, cols=c(39:43), rows=c(4:53)))
#mode(GDPfactors)
#names(GDPfactors)
dimnames(GDPpcfactors)[[1]] <- CountryNamesCodes[,2]
head(GDPpcfactors)

GDPTRpc2030 <- cbind(GDPTRpc2030,GDPTRpc2030,EXIO2014GDPTRpc*GDPpcfactors)
dimnames(GDPTRpc2030)[[2]][1:2] <- c('cons_shares','IEAETP')
head(GDPTRpc2030)

GDPTR2030 <- GDPTRpc2030*POPU2030
head(GDPTR2030)

save(file='GLM_R/predicted/GDPTR2030.Rdata',GDPTR2030)
save(file='GLM_R/predicted/GDPTRpc2030.Rdata',GDPTRpc2030)
save(file='GLM_R/predicted/POPU2030.Rdata',POPU2030)
