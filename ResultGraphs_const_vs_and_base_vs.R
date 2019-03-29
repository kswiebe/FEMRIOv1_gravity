

consShares <- PBA2DS6DS_and_ratio('constantShares')
IEAETP <- PBA2DS6DS_and_ratio('IEAETP')
OECDbase <- PBA2DS6DS_and_ratio('OECDbase')
OECDreforms <- PBA2DS6DS_and_ratio('OECDreforms')
BRIICScatchup <- PBA2DS6DS_and_ratio('BRIICScatchup')
lesserTrade <- PBA2DS6DS_and_ratio('lesserTrade')

par(mfrow=c(2,1))
for(s in 1:dim(EUFPratio_IEAETP)[2]){
  jpeg(paste0('FootprintPlots/PBA_6DS_relconst_and_OECDbase_',dimnames(EUFPratio_IEAETP)[[2]][s],'.jpg'),
       width = 960,        
       height = 480)
  par(mfrow=c(2,1))
  plot(consShares[[1]][newcoureg,s]/consShares[[1]][newcoureg,s],type = 'p',col = 'black',pch = 20,
       #ylim=c(0,1.5),yaxt="n"
       ylab = "relative to constant shares",xlab="Producing country",xaxt="n")
  axis(1, at=1:nreg, labels=newcoureg, las=2)#, pos=, lty=, col=, tck=, ...)
  #axis(2, at=c(0,0.5,1,1.5))
  #lines(rep(1,nreg))
  lines(IEAETP[[1]][newcoureg,s]/consShares[[1]][newcoureg,s],type = 'p',col = 'green',pch = 1)
  title(paste0("Gravity vs constant: ", dimnames(EUFPratio_IEAETP)[[2]][s]))
  legend('bottomleft',legend = scenarionames[1:2],col = scenariocol[1:2],pch = scenariopch[1:2],cex=0.8)
  
  plot(OECDbase[[1]][newcoureg,s]/OECDbase[[1]][newcoureg,s],type = 'p',col = 'darkgreen',pch = 3,
       #ylim=c(0,1.5),yaxt="n"
       ylab = "relative to OECDbase",xlab="Producing country",xaxt="n")
  axis(1, at=1:nreg, labels=newcoureg, las=2)#, pos=, lty=, col=, tck=, ...)
  #lines(OECDbase[[1]][newcoureg,s]/OECDbase[[1]][newcoureg,s],type = 'p',col = 'darkgreen',pch = 3)
  lines(OECDreforms[[1]][newcoureg,s]/OECDbase[[1]][newcoureg,s],type = 'p',col = 'blue',pch = 4)
  lines(BRIICScatchup[[1]][newcoureg,s]/OECDbase[[1]][newcoureg,s],type = 'p',col = 'orange',pch = 8)
  lines(lesserTrade[[1]][newcoureg,s]/OECDbase[[1]][newcoureg,s],type = 'p',col = 'red',pch = 18)
  title(paste0("OECD scenarios: ", dimnames(EUFPratio_IEAETP)[[2]][s]))
  legend('bottomleft',legend = scenarionames[3:6],col = scenariocol[3:6],pch = scenariopch[3:6],cex=0.8)
  dev.off()
}


