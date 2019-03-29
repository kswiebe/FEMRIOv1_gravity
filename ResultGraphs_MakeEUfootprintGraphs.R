

# Make EU consumption-based footprint by region
EUFP_consShares <- MakeEUfootprints('constantShares',couaggr)
EUFP_IEAETP <- MakeEUfootprints('IEAETP',couaggr)
EUFP_OECDbase <- MakeEUfootprints('OECDbase',couaggr)
EUFP_OECDreforms <- MakeEUfootprints('OECDreforms',couaggr)
EUFP_BRIICScatchup <- MakeEUfootprints('BRIICScatchup',couaggr)
EUFP_lesserTrade <- MakeEUfootprints('lesserTrade',couaggr)


for(s in 1:dim(EUFP_consShares[[1]])[2]){
  jpeg(paste0('FootprintPlots/EUFP_const_gravity_',dimnames(EUFP_consShares[[1]])[[2]][s],'.jpg'),
       width = 480,        
       height = 480)
    barplot(cbind(EUFP_consShares[[1]][,s],EUFP_IEAETP[[1]][,s],
                  EUFP_consShares[[2]][,s],EUFP_IEAETP[[2]][,s]),
            col = coucol,
            legend.text = dimnames(couaggr)[[2]],
            names.arg = c('6DS constant','6DS gravity',
                          '2DS constant','2DS gravity'),
            cex.names =  0.8)
    title(paste0('EU consumption-based ',dimnames(EUFP_consShares[[1]])[[2]][s],' in 2030'))
  dev.off()
  
  jpeg(paste0('FootprintPlots/EUFP_OECD_',dimnames(EUFP_consShares[[1]])[[2]][s],'.jpg'),
       width = 960,        
       height = 480)
    barplot(cbind(EUFP_OECDbase[[1]][,s],EUFP_OECDreforms[[1]][,s],EUFP_BRIICScatchup[[1]][,s],EUFP_lesserTrade[[1]][,s],
                  EUFP_OECDbase[[2]][,s],EUFP_OECDreforms[[2]][,s],EUFP_BRIICScatchup[[2]][,s],EUFP_lesserTrade[[2]][,s]),
            col = coucol,
            legend.text = dimnames(couaggr)[[2]],
            names.arg = c('6DS OECDbase','6DS OECDreforms','6DS BRIICScatchup','6DS lesserTrade',
                          '2DS OECDbase','2DS OECDreforms','2DS BRIICScatchup','2DS lesserTrade'),
            cex.names =  0.8)
    title(paste0('EU consumption-based ',dimnames(EUFP_consShares[[1]])[[2]][s],' in 2030'))
  dev.off()
}
