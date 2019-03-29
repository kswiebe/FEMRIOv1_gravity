# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs: functions
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


makeglobal <- function(national, TS,nreg, numc,nind)
{ 
  # national = national matrix
  # TS = trade share cube
  # numc = number of columns
  # numc = nind for A, numc = nfd for Y
  globalmatrix <- array(0,c(nind*nreg,numc*nreg))
  for(impc in 1:nreg)
  {
    impc1 = (impc-1)*numc+1
    impc2 = impc*numc
    for(expc in 1:nreg)
    {
      expc0 = (expc-1)*nind
      for(i in 1:nind)
      {
        globalmatrix[expc0+i,impc1:impc2] <- national[i,impc1:impc2] * TS[expc,impc,i];
      }# end i
    }# end expc
  }# end impc
  return(globalmatrix)
} # end makeglobal()


macroFDcat <- function(coef,error,GDP) {
  FDcat = coef[,1] + coef[,2]*GDP - error
  return(FDcat)
} # end macroFDcat()

makeFDnatagg <- function(HOUS,NPSH,GOVE,GFCF,FDshares,nreg){
  FDnat = array(0,dim=c(dim(FDshares)[1],nreg))
  for(c in 1:nreg){
    c0 = (c-1)*nfd
    FDnat[,c] = HOUS[c]*FDshares[,c0+1] + NPSH[c]*FDshares[,c0+2] +
      GOVE[c]*FDshares[,c0+3] + GFCF[c]*FDshares[,c0+4]

  }
  return(FDnat)
}


makeFDnat <- function(HOUS,NPSH,GOVE,GFCF,FDshares,nreg,nfd){
  FDnat = array(0,dim=dim(FDshares))
  for(c in 1:nreg){
    c0 = (c-1)*nfd
    FDnat[,c0+1] = HOUS[c]*FDshares[,c0+1]
    FDnat[,c0+2] = NPSH[c]*FDshares[,c0+2]
    FDnat[,c0+3] = GOVE[c]*FDshares[,c0+3]
    FDnat[,c0+4] = GFCF[c]*FDshares[,c0+4]
  }
  return(FDnat)
}

makeIndTrade <- function(IndAgg,TradeCubeInd_old,TradeCube_old,TradeCube_new,nind,nreg){
  TradeCubeInd_new = array(0,dim=dim(TradeCubeInd_old))
  for(i in 1:nind){
    j = which(IndAgg[i,]==1)
    for(impc in 1:nreg)
      for(expc in 1:nreg)
        TradeCubeInd_new[expc,impc,i] = TradeCubeInd_old[expc,impc,i] * TradeCube_new[expc,impc,j+1] / TradeCube_old[expc,impc,j+1]
  }
  TradeCubeInd_new[which(is.nan(TradeCubeInd_new))] = 0
  TradeCubeInd_new[which(is.infinite(TradeCubeInd_new))] = 0
  return(TradeCubeInd_new)
}

makeIndTradeShares <- function(TradeCubeInd,nind,nreg){
  TradeSharesCubeInd = array(0,dim = dim(TradeCubeInd))
  for(i in 1:nind){
    TradeSharesCubeInd[,,i] <- TradeCubeInd[,,i]/rep(colSums(TradeCubeInd[,,i]),each=dim(TradeCubeInd)[1])
  }
  TradeSharesCubeInd[is.nan(TradeSharesCubeInd)] = 0
  return(TradeSharesCubeInd)
}



MakeGDPcompGraph <- function(scenarioname,scenariodata){
  
  par(mfrow=c(1,1))
  jpeg(paste0('GLM_R/FootprintResults/GDPcomp_',scenarioname,'.jpg'),
       width = 960,        
       height = 480)
  plot(scenariodata[,1]/scenariodata[,1],type = 'p',col = 'black',pch = 20,
       #ylim=c(0,1.5),yaxt="n"
       ylab = "Relative to FD side GDP",xlab="country",xaxt="n")
  axis(1, at=1:(dim(scenariodata)[1]), labels=dimnames(scenariodata)[1][[1]], las=2)#, pos=, lty=, col=, tck=, ...)
  lines(scenariodata[,2]/scenariodata[,1],type = 'p',col = 'green',pch = 1)
  lines(scenariodata[,3]/scenariodata[,1],type = 'p',col = 'blue',pch = 3)
  title(paste0('GDP comparison ',scenarioname))
  legend('bottomleft',legend = dimnames(scenariodata)[2],col = c('black','green','blue'),pch = c(20,1,3))
  dev.off()
}
