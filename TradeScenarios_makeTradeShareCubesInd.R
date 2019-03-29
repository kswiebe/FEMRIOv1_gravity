# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs: makeTradeShareCubesInd
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


# get industry groupings
IndAgg <- read.csv2('metadata/IndustryAggregates.csv',sep=";")
dimnames(IndAgg)[[1]] <- IndAgg[,1]
IndAgg <- IndAgg[,-1]


# load historic trade cubes
load('gravdataEXIO/TradeSharesCubeIndEXIO2014.rdata')
load('gravdataEXIO/TradeCubeIndEXIO2014.rdata')

# load predicted trade cubes
futtradepath = 'GLM_R/predicted/'
load(paste0(futtradepath,'TradeCube_EXIO2014.Rdata'))
load(paste0(futtradepath,'TradeCube_IEAETP.Rdata'))
#OECDbase
#OECDreforms
load(paste0(futtradepath,'TradeCube_OECDbase.Rdata'))
load(paste0(futtradepath,'TradeCube_OECDreforms.Rdata'))
#BRIICScatchup
#lessTrade
#lesserTrade
load(paste0(futtradepath,'TradeCube_BRIICScatchup.Rdata'))
load(paste0(futtradepath,'TradeCube_lesserTrade.Rdata'))


#***************************************************
# make industry trade shares from aggregated ind
#***************************************************
TradeCubeIndIEAETP <- makeIndTrade(IndAgg,TradeCubeIndEXIO2014,TradeCubeEXIO2014,TradeCubeIEAETP,nind,nreg)
TradeSharesCubeIndIEAETP <- makeIndTradeShares(TradeCubeIndIEAETP,nind,nreg)

#OECDbase
TradeCubeIndOECDbase <- makeIndTrade(IndAgg,TradeCubeIndEXIO2014,TradeCubeEXIO2014,TradeCubeOECDbase,nind,nreg)
TradeSharesCubeIndOECDbase <- makeIndTradeShares(TradeCubeIndOECDbase,nind,nreg)

#OECDreforms
TradeCubeIndOECDreforms <- makeIndTrade(IndAgg,TradeCubeIndEXIO2014,TradeCubeEXIO2014,TradeCubeOECDreforms,nind,nreg)
TradeSharesCubeIndOECDreforms <- makeIndTradeShares(TradeCubeIndOECDreforms,nind,nreg)

#BRIICScatchup
TradeCubeIndBRIICScatchup <- makeIndTrade(IndAgg,TradeCubeIndEXIO2014,TradeCubeEXIO2014,TradeCubeBRIICScatchup,nind,nreg)
TradeSharesCubeIndBRIICScatchup <- makeIndTradeShares(TradeCubeIndBRIICScatchup,nind,nreg)


#lessTrade
#lesserTrade
TradeCubeIndlesserTrade <- makeIndTrade(IndAgg,TradeCubeIndEXIO2014,TradeCubeEXIO2014,TradeCubelesserTrade,nind,nreg)
TradeSharesCubeIndlesserTrade <- makeIndTradeShares(TradeCubeIndlesserTrade,nind,nreg)