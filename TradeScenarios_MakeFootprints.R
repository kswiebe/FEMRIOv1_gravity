# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Trade scenarios for MRIOs: MakeFootprints function
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

MakeFootprints <- function(GDP,POPU,TradeSharesCubeInd,scenario,
                           HOUS,HOUS_eps,NPSH,NPSH_eps,GOVE,GOVE_eps,GFCF,GFCF_eps,
                           FDshares2DS,FDshares6DS,Anat2DS,Anat6DS,CO22DS,CO26DS,
                           EMPL,forest,fossil,metals,nmms,
                           aggrci2c){
 #***************************************************
  # 1) get FD data depending on GDP
  #***************************************************
  FD_HOUS <- macroFDcat(HOUS,HOUS_eps,GDP)/1000000
#}

#testfunction <- function(){
  FD_NPSH <- macroFDcat(NPSH,NPSH_eps,GDP)/1000000
  FD_GOVE <- macroFDcat(GOVE,GOVE_eps,GDP)/1000000
  FD_GFCF <- macroFDcat(GFCF,GFCF_eps,GDP)/1000000

  
  #***************************************************
  # 2) make FDnat matrix from FD data and 2 FD shares
  #***************************************************
  # aggregates all FD categories to one
  FD_nat_2DS <- makeFDnatagg(FD_HOUS,FD_NPSH,FD_GOVE,FD_GFCF,FDshares2DS,nreg)
  FD_nat_6DS <- makeFDnatagg(FD_HOUS,FD_NPSH,FD_GOVE,FD_GFCF,FDshares6DS,nreg)
  
  #***************************************************
  # 4) make global matrices: 2DS & 6DS, trade shares
  #***************************************************
  #TradeSahresCubes are for aggrgated industries...
  # aggregated all FD categories
  
  FD2DS <- makeglobal(FD_nat_2DS, TradeSharesCubeInd,nreg, 1, nind)
  A2DS <- makeglobal(Anat2DS, TradeSharesCubeInd,nreg, nind, nind)
  FD6DS <- makeglobal(FD_nat_6DS, TradeSharesCubeInd,nreg, 1, nind)
  A6DS <- makeglobal(Anat6DS, TradeSharesCubeInd,nreg, nind, nind)
  
  
  #***************************************************
  # 5) Calculate footprints
  #***************************************************
  # 5.1) calculate (I-A)-1*FD
  # speed up matrix calculation
  # https://statmodeling.stat.columbia.edu/2008/06/22/a_trick_to_spee/
  I = diag(1,nreg*nind)
  #test1 <- solve(I-A2DS_exio2030)
  
  print("Leontief calculation 2DS")
  #LINV_2DS <- solve(I-A2DS)
  LINVFD_2DS <- solve(I-A2DS) %*% FD2DS
  
  # calcualte output
  x_2DS <- rowSums(LINVFD_2DS)
  # calculate flow matrix and take colsums to get intermediate output
  sumZ_2DS <- colSums(A2DS * t(matrix(x_2DS,dim(A2DS)[1],dim(A2DS)[2])))
  # value added = x-sumZ
  VA_2DSlong = x_2DS - sumZ_2DS
  #print(VA_2DS)
  
  print("Leontief calculation 6DS")
  #LINV_6DS <- solve(I-A6DS)
  LINVFD_6DS <- solve(I-A6DS) %*% FD6DS
  x_6DS <- rowSums(LINVFD_6DS)
  sumZ_6DS <- colSums(A6DS * t(matrix(x_6DS,dim(A6DS)[1],dim(A6DS)[2])))
  # value added = x-sumZ
  VA_6DSlong = x_6DS - sumZ_6DS
  
  
  GDPcomp <- array(0,dim=c(length(GDP),3))
  dimnames(GDPcomp)[[1]] <- names(GDP)
  dimnames(GDPcomp)[[2]] <- c('GDP','VA6DS','VA2DS')
  GDPcomp[,1] <- GDP/1000000
  nind = length(x_6DS)/length(GDP)
  for(c in 1:length(GDP)){
    c1 = (c-1)*nind+1
    c2 = nind * c
    GDPcomp[c,2] = sum(VA_6DSlong[c1:c2])
    GDPcomp[c,3] = sum(VA_2DSlong[c1:c2])
  }
  MakeGDPcompGraph(scenario,GDPcomp)
  
  print("Leontief calculations done")
  
  
  # CO2 emissions
  C02cxc_2DS = aggrci2c %*% (diag(CO22DS) %*% LINVFD_2DS)
  C02cxc_6DS = aggrci2c %*% (diag(CO26DS) %*% LINVFD_6DS)
  
  cxc_2DS <- array(0, dim=c(dim(C02cxc_2DS),6))
  cxc_6DS <- array(0, dim=c(dim(C02cxc_6DS),6))
  cxc_2DS[,,1] <- C02cxc_2DS
  cxc_6DS[,,1] <- C02cxc_6DS
  dimnames(cxc_2DS)[[1]] <- names(GDP)
  dimnames(cxc_2DS)[[2]] <- names(GDP)
  dimnames(cxc_2DS)[[3]] <- c('CO2emissions','Employment','Forest','Fossil','Metals','NonMetalicMinerals')
  
  # Employment
  cxc_2DS[,,2] = aggrci2c %*% (diag(EMPL) %*% LINVFD_2DS)
  cxc_6DS[,,2] = aggrci2c %*% (diag(EMPL) %*% LINVFD_6DS)
  # Forestry
  cxc_2DS[,,3] = aggrci2c %*% (diag(forest) %*% LINVFD_2DS)
  cxc_6DS[,,3] = aggrci2c %*% (diag(forest) %*% LINVFD_6DS)
  # Fossil fuels
  cxc_2DS[,,4] = aggrci2c %*% (diag(fossil) %*% LINVFD_2DS)
  cxc_6DS[,,4] = aggrci2c %*% (diag(fossil) %*% LINVFD_6DS)
  # Metals
  cxc_2DS[,,5] = aggrci2c %*% (diag(metals) %*% LINVFD_2DS)
  cxc_6DS[,,5] = aggrci2c %*% (diag(metals) %*% LINVFD_6DS)
  # Non-metallic minerals
  cxc_2DS[,,6] = aggrci2c %*% (diag(nmms) %*% LINVFD_2DS)
  cxc_6DS[,,6] = aggrci2c %*% (diag(nmms) %*% LINVFD_6DS)
  
  save(file=paste0('GLM_R/FootprintResults/cxc_2DS_',scenario,'.Rdata'),cxc_2DS)
  save(file=paste0('GLM_R/FootprintResults/cxc_6DS_',scenario,'.Rdata'),cxc_6DS)
  
  
  # Consumption CBA and PRoduction PBA based accounts
  PBA_CO2_2DS = rowSums(C02cxc_2DS)/1000000
  CBA_CO2_2DS = colSums(C02cxc_2DS)/1000000
  PBA_CO2_6DS = rowSums(C02cxc_6DS)/1000000
  CBA_CO2_6DS = colSums(C02cxc_6DS)/1000000
  
  # Per capita PBA and CBA
  PBA_CO2_2DS_pc = rowSums(C02cxc_2DS)/POPU
  CBA_CO2_2DS_pc = colSums(C02cxc_2DS)/POPU
  PBA_CO2_6DS_pc = rowSums(C02cxc_6DS)/POPU
  CBA_CO2_6DS_pc = colSums(C02cxc_6DS)/POPU
  
  
  PBA_empl_2DS = rowSums(cxc_2DS[,,2])/1000000
  CBA_empl_2DS = colSums(cxc_2DS[,,2])/1000000
  PBA_empl_6DS = rowSums(cxc_6DS[,,2])/1000000
  CBA_empl_6DS = colSums(cxc_6DS[,,2])/1000000
  
  FPs = cbind(PBA_CO2_2DS,CBA_CO2_2DS,PBA_CO2_6DS,CBA_CO2_6DS,
              PBA_CO2_2DS_pc,CBA_CO2_2DS_pc,PBA_CO2_6DS_pc,CBA_CO2_6DS_pc,
              PBA_empl_2DS,CBA_empl_2DS,PBA_empl_6DS,CBA_empl_6DS)
  dimnames(FPs)[[1]] <- names(GDP)
  dimnames(FPs)[[2]] <- c('CO2 PBA 2DS','CO2 CBA 2DS','CO2 PBA 6DS','CO2 CBA 6DS',
                          'CO2 PBApc 2DS','CO2 CBApc 2DS','CO2 PBApc 6DS','CO2 CBApc 6DS',
                          'EMPL PBA 2DS','EMPL CBA 2DS','EMPL PBA 6DS','EMPL CBA 6DS')
  return(list(FPs,GDPcomp))
  
}# end function MakeFootprints()




