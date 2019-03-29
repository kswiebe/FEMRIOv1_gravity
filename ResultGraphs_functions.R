MakeEUfootprints <- function(scenario,couaggr){
  
  load(file=paste0('GLM_R/FootprintResults/cxc_2DS_',scenario,'.Rdata'))
  load(file=paste0('GLM_R/FootprintResults/cxc_6DS_',scenario,'.Rdata'))
  dimnames(cxc_6DS) <- dimnames(cxc_2DS)
  EUcons_6DS <- array(0,dim = c(dim(couaggr)[2],dim(cxc_2DS)[3]))
  EUcons_2DS <- array(0,dim = c(dim(couaggr)[2],dim(cxc_2DS)[3]))
  dimnames(EUcons_2DS) <- list(dimnames(couaggr)[[2]],dimnames(cxc_2DS)[[3]])
  dimnames(EUcons_6DS) <- list(dimnames(couaggr)[[2]],dimnames(cxc_2DS)[[3]])
  for (s in 1:dim(cxc_2DS)[3]){
    EUcons_6DS[,s] = t(couaggr) %*% rowSums(cxc_6DS[,1:28,s])
    EUcons_2DS[,s] = t(couaggr) %*% rowSums(cxc_2DS[,1:28,s])
  }
  return(list=list(EUcons_6DS,EUcons_2DS))
}

MakeEUfootprints2DS6DSratio <- function(scenario){
  
  load(file=paste0('GLM_R/FootprintResults/cxc_2DS_',scenario,'.Rdata'))
  load(file=paste0('GLM_R/FootprintResults/cxc_6DS_',scenario,'.Rdata'))
  EUcons_6DS <- array(0,dim = c(dim(cxc_2DS)[1],dim(cxc_2DS)[3]))
  EUcons_2DS <- array(0,dim = c(dim(cxc_2DS)[1],dim(cxc_2DS)[3]))
  dimnames(EUcons_2DS) <- list(dimnames(cxc_2DS)[[1]],dimnames(cxc_2DS)[[3]])
  dimnames(EUcons_6DS) <- list(dimnames(cxc_2DS)[[1]],dimnames(cxc_2DS)[[3]])
  for (s in 1:dim(cxc_2DS)[3]){
    EUcons_6DS[,s] = rowSums(cxc_6DS[,,s])# to get EU FP [,1:28,s]
    EUcons_2DS[,s] = rowSums(cxc_2DS[,,s])
  }
  EUcons_2DS6DS_ratio = EUcons_2DS/EUcons_6DS
  #EUcons_2DS6DS_ratio[is.nan(EUcons_2DS6DS_ratio)] <- 1
  return(EUcons_2DS6DS_ratio)
}

PBA2DS6DS_and_ratio <- function(scenario){
  
  load(file=paste0('GLM_R/FootprintResults/cxc_2DS_',scenario,'.Rdata'))
  load(file=paste0('GLM_R/FootprintResults/cxc_6DS_',scenario,'.Rdata'))
  PBA_6DS <- array(0,dim = c(dim(cxc_2DS)[1],dim(cxc_2DS)[3]))
  PBA_2DS <- array(0,dim = c(dim(cxc_2DS)[1],dim(cxc_2DS)[3]))
  dimnames(PBA_2DS) <- list(dimnames(cxc_2DS)[[1]],dimnames(cxc_2DS)[[3]])
  dimnames(PBA_6DS) <- list(dimnames(cxc_2DS)[[1]],dimnames(cxc_2DS)[[3]])
  for (s in 1:dim(cxc_2DS)[3]){
    PBA_6DS[,s] = rowSums(cxc_6DS[,,s])
    PBA_2DS[,s] = rowSums(cxc_2DS[,,s])
  }
  PBA_2DS6DS_ratio = PBA_2DS/PBA_6DS
  #EUcons_2DS6DS_ratio[is.nan(EUcons_2DS6DS_ratio)] <- 1
  return(list(PBA_6DS,PBA_2DS,PBA_2DS6DS_ratio))
}


regxregtrademosaic <- function(scenario,couaggr,coucol){
  couaggr <- as.matrix(couaggr)
  dimnames(couaggr)[[2]] <- c('EU','EUR','AME','ASI','BRIICS','RoW')
  load(file=paste0('GLM_R/FootprintResults/cxc_2DS_',scenario,'.Rdata'))
  load(file=paste0('GLM_R/FootprintResults/cxc_6DS_',scenario,'.Rdata'))
  
  # region x region x stressors
  trade_6DS <- array(0,dim = c(dim(couaggr)[2],dim(couaggr)[2],dim(cxc_2DS)[3]))
  trade_2DS <- array(0,dim = c(dim(couaggr)[2],dim(couaggr)[2],dim(cxc_2DS)[3]))
  dimnames(trade_6DS) <- list(dimnames(couaggr)[[2]],dimnames(couaggr)[[2]],dimnames(cxc_2DS)[[3]])
  dimnames(trade_2DS) <- list(dimnames(couaggr)[[2]],dimnames(couaggr)[[2]],dimnames(cxc_2DS)[[3]])
  for (s in 1:dim(cxc_2DS)[3]){
    trade_6DS[,,s] <- t(couaggr) %*% cxc_6DS[,,s] %*% couaggr
    trade_2DS[,,s] <- t(couaggr) %*% cxc_2DS[,,s] %*% couaggr
    
    filename <- paste0("FootprintPlots/mosaic_",scenario,'_',dimnames(cxc_2DS)[[3]][s],".jpg")
    jpeg(filename, width=200, height=400) # A4 landscape
    par(mfrow=c(2,1))
    mosaicplot(trade_6DS[,,s],
               color=coucol,
               las=1,cex.axis=0.5,main=paste0(scenario,' 6DS'))
    mosaicplot(trade_2DS[,,s],
               color=coucol,
               las=1,cex.axis=0.5,main=paste0(scenario,' 2DS'))
    dev.off()
  }
  
  
  #return(list(trade_6DS,trade_2DS))
}