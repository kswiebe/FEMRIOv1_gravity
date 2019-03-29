# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

#setwd('D:/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
source('GLM_R/DataPrep_1.R')

source('GLM_R/TradeScenarios_functions.R')
# contains
# globalmatrix <- makeglobal(national, TS,nreg, numc)
# FD_cat <- macroFDcat(coef,error,GDP)
# FD_nat <- makeFDnat(FD_HOUS,FD_NPSH,FD_GOVE,FD_GFCF,FDshares,nreg,nfd)
source('GLM_R/TradeScenarios_MakeFootprints.R')


source('GLM_R/TradeScenarios_getFDandA.R')
# gives us Anat2DS, Anat6DS, FDnat2DS, FDnat6DS
# and FDshares2DS, FDshares6DS
source('GLM_R/TradeScenarios_getmacroregres.R')
# gives us HOUS and HOUS_eps etc.
source('GLM_R/TradeScenarios_getstressors.R')

# make Trade Share Cubes by industry for all scenarios
source('GLM_R/TradeScenarios_makeTradeShareCubesInd.R')

# load GDP
load(paste0(futtradepath,'GDPTR2030.Rdata'))
load(paste0(futtradepath,'POPU2030.Rdata'))

#IEAETP2030GDPTR <- GDPTR2030$IEAETP
#IEAETP2030POPU <- POPU2030

############################################
# Footprints by scenario
############################################

# 1) constant shares
GDP <- GDPTR2030$cons_shares
names(GDP) <- dimnames(GDPTR2030)[[1]]

cons_shares <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndEXIO2014,'constantShares',
                         HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                         FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                         # more stressors
                         EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                         aggrci2c)

save(file=paste0('GLM_R/FootprintResults/Footprints_','cons_shares','.Rdata'),cons_shares)
write.csv(cons_shares[[1]],file=paste0('GLM_R/FootprintResults/Footprints_','cons_shares','.csv'))

#MakeGDPcompGraph(scenarioname,scenariodataGDP)
#write.csv(cons_shares[[2]],file=paste0('GLM_R/FootprintResults/GDP_',scenarioname,'.csv'))



# 2) IEAETP
GDP <- GDPTR2030$IEAETP
names(GDP) <- dimnames(GDPTR2030)[[1]]

IEAETP <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndIEAETP,'IEAETP',
                           HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                           FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                           EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                           aggrci2c)
save(file=paste0('GLM_R/FootprintResults/Footprints_','IEAETP','.Rdata'),IEAETP)
write.csv(IEAETP,file=paste0('GLM_R/FootprintResults/Footprints_','IEAETP','.csv'))


# 3) OECDbase
GDP <- GDPTR2030$OECDbase
names(GDP) <- dimnames(GDPTR2030)[[1]]

OECDbase <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndOECDbase,'OECDbase',
                         HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                         FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                         EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                         aggrci2c)

save(file=paste0('GLM_R/FootprintResults/Footprints_','OECDbase','.Rdata'),OECDbase)
write.csv(OECDbase,file=paste0('GLM_R/FootprintResults/Footprints_','OECDbase','.csv'))

# 4) OECDreforms

GDP <- GDPTR2030$OECDreforms
names(GDP) <- dimnames(GDPTR2030)[[1]]

OECDreforms <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndOECDreforms,'OECDreforms',
                         HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                         FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                         EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                         aggrci2c)

save(file=paste0('GLM_R/FootprintResults/Footprints_','OECDreforms','.Rdata'),OECDreforms)
write.csv(OECDreforms,file=paste0('GLM_R/FootprintResults/Footprints_','OECDreforms','.csv'))

# 5) BRIICScatchup
GDP <- GDPTR2030$BRIICScatchup
names(GDP) <- dimnames(GDPTR2030)[[1]]

BRIICScatchup <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndBRIICScatchup,'BRIICScatchup',
                         HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                         FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                         EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                         aggrci2c)

save(file=paste0('GLM_R/FootprintResults/Footprints_','BRIICScatchup','.Rdata'),BRIICScatchup)
write.csv(BRIICScatchup,file=paste0('GLM_R/FootprintResults/Footprints_','BRIICScatchup','.csv'))

# 6) lessTrade
# 7) lesserTrade
GDP <- GDPTR2030$lesserTRADE
names(GDP) <- dimnames(GDPTR2030)[[1]]

lesserTrade <- MakeFootprints(GDP,POPU2030,TradeSharesCubeIndlesserTrade,'lesserTrade',
                         HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                         FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                         EMPLhist,foresthist,fossilhist,metalshist,nmmshist,
                         aggrci2c)


save(file=paste0('GLM_R/FootprintResults/Footprints_','lesserTrade','.Rdata'),lesserTrade)
write.csv(lesserTrade,file=paste0('GLM_R/FootprintResults/Footprints_','lesserTrade','.csv'))


