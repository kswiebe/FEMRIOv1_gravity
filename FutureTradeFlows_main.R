# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Calculating future trade flows for IEAETP2015
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
source('GLM_R/DataPrep_1.R')

# 1) Get GDP data for all scenarios
# 1A) get FEMRIO/EXIOBASE GDPT data
# 1B) Get OECD scenarios GDP data

# 2) Load gravity data and estimates
# 2A) load the gravity data
# 2B) load coefficient estimates

# 3) Make trade cube for all scenarios
# use gravdataIEAETP, and then fill it with the new data
# 3A) i.e. replace gdp_o, gdp_d, gdpcap_o, gdpcap_d, pop_o, pop_d
#     with the IEA ETP data
# 3B) then overwrite the trade flows with the new estimates 
#     for 2030 using the estimated coefficients
# 3C) make and save trade cubes


# 4) Plot trade shares for all scenarios




#######################################
# 1) Get GDP data for all scenarios
#######################################
source('GLM_R/FutureTradeFlows_1_getGDP.R')
# makes GDPTR2030.Rdata GDPTRpc2030.Rdata and POPU2030.Rdata

#######################################
# 2) Load gravity data and estimates
#######################################
source('GLM_R/FutureTradeFlows_2_loadgravdata.R')
# and it makes TradeCubeEXIO2014

#######################################
# 3) Make trade cube for all scenarios
# use gravdata, and then fill it with the new data
# 3A) i.e. replace gdp_o, gdp_d, gdpcap_o, gdpcap_d, pop_o, pop_d
#     with the IEA ETP data
# 3B) then overwrite the trade flows with the new estimates 
#     for 2030 using the estimated coefficients
# 3C) make and save Trade cubes
#######################################
source('GLM_R/FutureTradeFlows_3_makeTradeCube.R')
names(GDPTR2030)
names(GDPTR2030)[4] <- "lessTrade"
names(GDPTR2030)[5] <- "lesserTrade"

#IEAETP
GDP <- GDPTR2030$IEAETP
names(GDP) <- dimnames(GDPTR2030)[[1]]
TradeCubeIEAETP <- makeTradeCube(gravdataEXIOfinal,GDP,POPU2030,'IEAETP',tidylist,fittedlist,error,AggrInd)

#OECDbase
GDP <- GDPTR2030$OECDbase
names(GDP) <- dimnames(GDPTR2030)[[1]]
TradeCubeOECDbase <- makeTradeCube(gravdataEXIOfinal,GDP,POPU2030,'OECDbase',tidylist,fittedlist,error,AggrInd)

#OECDreforms
GDP <- GDPTR2030$OECDreforms
names(GDP) <- dimnames(GDPTR2030)[[1]]
TradeCubeOECDreforms <- makeTradeCube(gravdataEXIOfinal,GDP,POPU2030,'OECDreforms',tidylist,fittedlist,error,AggrInd)

#BRIICScatchup
GDP <- GDPTR2030$BRIICScatchup
names(GDP) <- dimnames(GDPTR2030)[[1]]
TradeCubeBRIICScatchup <- makeTradeCube(gravdataEXIOfinal,GDP,POPU2030,'BRIICScatchup',tidylist,fittedlist,error,AggrInd)

#lessTrade
#lesserTrade
GDP <- GDPTR2030$lesserTrade
names(GDP) <- dimnames(GDPTR2030)[[1]]
TradeCubelesserTrade <- makeTradeCube(gravdataEXIOfinal,GDP,POPU2030,'lesserTrade',tidylist,fittedlist,error,AggrInd)


save(file='GLM_R/predicted/TradeCube_EXIO2014.Rdata',TradeCubeEXIO2014)
save(file='GLM_R/predicted/TradeCube_IEAETP.Rdata',TradeCubeIEAETP)
#OECDbase
save(file='GLM_R/predicted/TradeCube_OECDbase.Rdata',TradeCubeOECDbase)
#OECDreforms
save(file='GLM_R/predicted/TradeCube_OECDreforms.Rdata',TradeCubeOECDreforms)
#BRIICScatchup
save(file='GLM_R/predicted/TradeCube_BRIICScatchup.Rdata',TradeCubeBRIICScatchup)
#lessTrade
#lesserTrade
save(file='GLM_R/predicted/TradeCube_lesserTrade.Rdata',TradeCubelesserTrade)


#######################################
# 4) Plot trade shares for all scenarios
#######################################

TradeSharesCubeEXIO2014 <- array(0,dim=c(length(EXIOcoureg),length(EXIOcoureg),length(AggrInd)))
dimnames(TradeSharesCubeEXIO2014) <- list(EXIOcoureg,EXIOcoureg,AggrInd)
TradeSharesCubeIEAETP <- TradeSharesCubeEXIO2014
#OECDbase
TradeSharesCubeOECDbase <- TradeSharesCubeEXIO2014
#OECDreforms
TradeSharesCubeOECDreforms <- TradeSharesCubeEXIO2014
#BRIICScatchup
TradeSharesCubeBRIICScatchup <- TradeSharesCubeEXIO2014
#lessTrade
#lesserTrade
TradeSharesCubelesserTrade <- TradeSharesCubeEXIO2014
for ( ind in AggrInd[2:length(AggrInd)]){
  TradeSharesCubeEXIO2014[,,ind] <- TradeCubeEXIO2014[,,ind]/t(matrix(rep(colSums(TradeCubeEXIO2014[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  TradeSharesCubeIEAETP[,,ind] <- TradeCubeIEAETP[,,ind]/t(matrix(rep(colSums(TradeCubeIEAETP[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  #OECDbase
  TradeSharesCubeOECDbase[,,ind] <- TradeCubeOECDbase[,,ind]/t(matrix(rep(colSums(TradeCubeOECDbase[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  TradeSharesCubeOECDreforms[,,ind] <- TradeCubeOECDreforms[,,ind]/t(matrix(rep(colSums(TradeCubeOECDreforms[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  #OECDreforms
  #BRIICScatchup
  TradeSharesCubeBRIICScatchup[,,ind] <- TradeCubeBRIICScatchup[,,ind]/t(matrix(rep(colSums(TradeCubeBRIICScatchup[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  TradeSharesCubelesserTrade[,,ind] <- TradeCubelesserTrade[,,ind]/t(matrix(rep(colSums(TradeCubelesserTrade[,,ind]),length(EXIOcoureg)),nrow=length(EXIOcoureg),ncol=length(EXIOcoureg)))
  #lessTrade
  #lesserTrade
}



for ( ind in AggrInd[2:length(AggrInd)]){
  jpeg(paste0('GLM_R/TradeSharePlots/',ind,'_comp.jpg'),
       #width = 1440, height = 480)
       width = 2160, height = 360)
  par(mfrow = c(1,6))
  image(t(TradeSharesCubeEXIO2014[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," EXIO2014"))
  image(t(TradeSharesCubeIEAETP[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," IEAETP2030"))
  #OECDbase
  #OECDreforms
  image(t(TradeSharesCubeOECDbase[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," OECDbase"))
  image(t(TradeSharesCubeOECDreforms[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," OECDreforms"))
  #BRIICScatchup
  image(t(TradeSharesCubeBRIICScatchup[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," BRIICScatchup"))
  image(t(TradeSharesCubelesserTrade[,,ind]),col = heat.colors(20)[20:1], axes=F)
  mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," lesserTrade"))
  #lessTrade
  #lesserTrade
  #image(t(TradeSharesCubeIEAETP[,,ind])-t(TradeSharesCubeEXIO2014[,,ind]),
  #      col = c("darkred","red","orange","yellow","green","darkgreen","blue"), axes=F)
  #mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  #mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  #title(paste0(ind," difference"))
  dev.off()
}

#save(file='GLM_R/predicted/TradeSharesCubeEXIO2014.Rdata',TradeSharesCubeEXIO2014)
#save(file='GLM_R/predicted/TradeSharesCubeIEAETP.Rdata',TradeSharesCubeIEAETP)





