# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Result graphs of trade scenarios 
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

#setwd('D:/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
source('GLM_R/DataPrep_1.R')

source('GLM_R/ResultGraphs_functions.R')

source('GLM_R/ResultGraphs_init.R')



##########################################
# Figures for IO Workshop: 14.03.2019
##########################################

# Figures: EU cons based by producing region
# for presentation at IO Workshop: slides 16, 17, 20, 21
source('GLM_R/ResultGraphs_MakeEUfootprintGraphs.R')


# Figures: 2degree / 6 degree ratios
# for presentation at IO Workshop: slides 18 & 19
source('GLM_R/ResultGraphs_Make2deg6degratioGraphs.R')


# Figures:  PBA 6 degree scenario - const vs IEA & OECD base vs all
# for presentation at IO Workshop: slides 14 & 15
source('GLM_R/ResultGraphs_const_vs_and_base_vs.R')

##########################################
# Figures for paper 21.03.2019
##########################################

# constant versus gravity
source('GLM_R/ResultGraphs_const_vs_gravity.R')





#############33
par(mfrow = c(1,1))
for(s in 1:dim(EUFPratio_IEAETP)[2]){
  jpeg(paste0('FootprintPlots/PBA_6DS_',dimnames(EUFPratio_IEAETP)[[2]][s],'.jpg'),
       width = 960,        
       height = 480)
  plot(consShares[[1]][newcoureg,s],type = 'p',col = 'black',pch = 20,
       #ylim=c(0,1.5),yaxt="n"
       ylab = "2DS/6DS",xlab="Producing country",xaxt="n")
  axis(1, at=1:nreg, labels=newcoureg, las=2)#, pos=, lty=, col=, tck=, ...)
  #axis(2, at=c(0,0.5,1,1.5))
  lines(rep(1,nreg))
  lines(IEAETP[[1]][newcoureg,s],type = 'p',col = 'green',pch = 1)
  lines(OECDbase[[1]][newcoureg,s],type = 'p',col = 'darkgreen',pch = 3)
  lines(OECDreforms[[1]][newcoureg,s],type = 'p',col = 'blue',pch = 4)
  lines(BRIICScatchup[[1]][newcoureg,s],type = 'p',col = 'orange',pch = 8)
  lines(lesserTrade[[1]][newcoureg,s],type = 'p',col = 'red',pch = 18)
  title(paste0("PBA 6DS ", dimnames(EUFPratio_IEAETP)[[2]][s]))
  legend('bottomleft',legend = scenarionames,col = scenariocol,pch = scenariopch)
  dev.off()
}
