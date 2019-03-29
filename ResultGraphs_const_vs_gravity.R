
# [[1]] is PBA 6DS, [[2]] is PBA 2DS, [[3]] is 2DS/6DS
scenario <- 'cons_shares'
load(file=paste0('GLM_R/FootprintResults/Footprints_',scenario,'.Rdata'))
scenario <- 'IEAETP'
load(file=paste0('GLM_R/FootprintResults/Footprints_',scenario,'.Rdata'))

# in cons_shares[[1]]: PBA/CBA CO2/EMPL 2DS/6DS
dimnames(cons_shares[[1]])[2]
# in cons_shares[[2]]: GDP VA6DS VA2DS
dimnames(cons_shares[[2]])[2]

{
jpeg(paste0('PaperPlots/PBA_6DS_const_vs_gravity.jpg'),
     width = 960,        
     height = 960)

  par(mfrow=c(3,1))

  # Value added
  plot(cons_shares[[2]][newcoureg,"VA6DS"]/cons_shares[[2]][newcoureg,"VA6DS"],type = 'p',col = 'black',pch = 20,
       ylab = "relative to constant shares",xlab="",xaxt="n",cex.lab=1.5,cex.axis = 1.5)
  axis(1, at=1:nreg, labels=newcoureg, las=2,cex.axis = 1.5)#, pos=, lty=, col=, tck=, ...)
  lines(IEAETP[[2]][newcoureg,"VA6DS"]/cons_shares[[2]][newcoureg,"VA6DS"],type = 'p',col = 'green',pch = 1)
  title(paste0("Value added"),cex.main=2)
  #legend('bottomleft',legend = scenarionames[1:2],col = scenariocol[1:2],pch = scenariopch[1:2],cex=1.5)
  legend('bottomleft',legend = c("Constant trade shares", "Gravity determined trade shares based on IEAT ETP (2015) GDP projections"),col = scenariocol[1:2],pch = scenariopch[1:2],cex=1.5)
  
  # Employment
  plot(cons_shares[[1]][newcoureg,"EMPL PBA 6DS"]/cons_shares[[1]][newcoureg,"EMPL PBA 6DS"],type = 'p',col = 'black',pch = 20,
       ylab = "relative to constant shares",xlab="",xaxt="n",cex.lab=1.5,cex.axis = 1.5)
  axis(1, at=1:nreg, labels=newcoureg, las=2,cex.axis = 1.5)#, pos=, lty=, col=, tck=, ...)
  lines(IEAETP[[1]][newcoureg,"EMPL PBA 6DS"]/cons_shares[[1]][newcoureg,"EMPL PBA 6DS"],type = 'p',col = 'green',pch = 1)
  title(paste0("Employment"),cex.main=2)
 # legend('bottomleft',legend = scenarionames[1:2],col = scenariocol[1:2],pch = scenariopch[1:2],cex=1.5)
  
  # CO2
  plot(cons_shares[[1]][newcoureg,"CO2 PBA 6DS"]/cons_shares[[1]][newcoureg,"CO2 PBA 6DS"],type = 'p',col = 'black',pch = 20,
       ylab = "relative to constant shares",xlab="",xaxt="n",cex.lab=1.5,cex.axis = 1.5)
  axis(1, at=1:nreg, labels=newcoureg, las=2,cex.axis = 1.5)#, pos=, lty=, col=, tck=, ...)
  lines(IEAETP[[1]][newcoureg,"CO2 PBA 6DS"]/cons_shares[[1]][newcoureg,"CO2 PBA 6DS"],type = 'p',col = 'green',pch = 1)
  title(paste0("CO2 emissions"),cex.main=2)
#  legend('bottomleft',legend = scenarionames[1:2],col = scenariocol[1:2],pch = scenariopch[1:2],cex=1.5)
  

dev.off()
}
