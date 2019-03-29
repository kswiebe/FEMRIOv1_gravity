# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Calculating future trade flows for IEAETP2015
# 2) load gravdata
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

# 2A) load the gravity data
load('gravdataEXIO/gravdataEXIOfinal.rdata')

# 2B) load coefficient estimates
load('GLM_R/TidyRegressionResults_exio.rdata')
#tidylist[["Agriculture"]]
#tidylist[["Agriculture"]]$estimate
#tidylist[["Agriculture"]]$estimate[which(tidylist[["Agriculture"]]$term == "factor(iso3_o)AUT")]

# 2B) load fitted to calculate errors
load('GLM_R/FittedRegressionResults_exio.rdata')
AggrInd <- dimnames(fittedlist)[[2]]

# 2D) make trade cube EXIO
TradeCubeEXIO2014 <- array(0,dim=c(length(EXIOcoureg),length(EXIOcoureg),length(AggrInd)))
dimnames(TradeCubeEXIO2014) <- list(EXIOcoureg,EXIOcoureg,AggrInd)
for ( ind in AggrInd[2:length(AggrInd)]){
  for (i in 1:dim(gravdataEXIOfinal)[1]){
    TradeCubeEXIO2014[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i],ind] <- gravdataEXIOfinal[i,ind]

  }
}
