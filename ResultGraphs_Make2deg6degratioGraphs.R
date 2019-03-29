
# Make EU consumption footprint ratios

# changed to production-based totals
EUFPratio_consShares <- MakeEUfootprints2DS6DSratio('constantShares')
EUFPratio_IEAETP <- MakeEUfootprints2DS6DSratio('IEAETP')
EUFPratio_OECDbase <- MakeEUfootprints2DS6DSratio('OECDbase')
EUFPratio_OECDreforms <- MakeEUfootprints2DS6DSratio('OECDreforms')
EUFPratio_BRIICScatchup <- MakeEUfootprints2DS6DSratio('BRIICScatchup')
EUFPratio_lesserTrade <- MakeEUfootprints2DS6DSratio('lesserTrade')



par(mfrow = c(1,1))
for(s in 1:dim(EUFPratio_IEAETP)[2]){
  jpeg(paste0('FootprintPlots/EUFP2DS6DSratio_',dimnames(EUFPratio_IEAETP)[[2]][s],'.jpg'),
       width = 960,        
       height = 480)
  plot(EUFPratio_consShares[newcoureg,s],type = 'p',col = 'black',pch = 20,
       ylim=c(0.4,1.1),#yaxt="n"
       ylab = "2DS/6DS",xlab="Producing country",xaxt="n")
  axis(1, at=1:nreg, labels=newcoureg, las=2)#, pos=, lty=, col=, tck=, ...)
  #axis(2, at=c(0,0.5,1,1.5))
  lines(rep(1,nreg))
  lines(EUFPratio_IEAETP[newcoureg,s],type = 'p',col = 'green',pch = 1)
  lines(EUFPratio_OECDbase[newcoureg,s],type = 'p',col = 'darkgreen',pch = 3)
  lines(EUFPratio_OECDreforms[newcoureg,s],type = 'p',col = 'blue',pch = 4)
  lines(EUFPratio_BRIICScatchup[newcoureg,s],type = 'p',col = 'orange',pch = 8)
  lines(EUFPratio_lesserTrade[newcoureg,s],type = 'p',col = 'red',pch = 18)
  title(paste0("PBA: ", dimnames(EUFPratio_IEAETP)[[2]][s]))
  legend('bottomleft',legend = scenarionames,col = scenariocol,pch = scenariopch)
  dev.off()
}
