# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Calculating future trade flows for IEAETP2015
# 3) make trade cubes
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

makeTradeCube <- function(gravdata,GDP,POPU,scenario,tidylist,fittedlist,error,AggrInd){
 
  # 3A) i.e. replace gdp_o, gdp_d, gdpcap_o, gdpcap_d, pop_o, pop_d
  
  for(i in 1:dim(gravdata)[1]){
    gravdata$gdp_o[i] <- GDP[gravdata$iso3_o[i]]
    gravdata$gdp_d[i] <- GDP[gravdata$iso3_d[i]]
    gravdata$pop_o[i] <- POPU[gravdata$iso3_o[i]]
    gravdata$pop_d[i] <- POPU[gravdata$iso3_d[i]]
  }
  
  gravdata$gdpcap_o <- gravdata$gdp_o/gravdata$pop_o
  gravdata$gdpcap_d <- gravdata$gdp_d/gravdata$pop_d
  
  # 3B)  overwrite the trade flows with the new estimates 
  #trade.glm <- glm(gravdataEXIOfinal[i][[1]] ~ log(distw) + 
  #                   log(GDPEXIO_o) + log(GDPEXIO_d) + 
  #                   log(GDPcapEXIO_o) + log(GDPcapEXIO_d) +
  #                   Euro + EUEEA +
  #                   intracou +
  #                   factor(iso3_o) + factor(iso3_d),
  #                 data=gravdataEXIOfinal, family = quasipoisson(link="log") )
  # for all aggregated industries, but not the total, 
  # maybe also total to check if it adds up. But total is
  # stored different in tidylist, so it needs to go extra
  # store in TradeCube for further processing
  TradeCube <- array(0,dim=c(length(EXIOcoureg),length(EXIOcoureg),length(AggrInd)))
  dimnames(TradeCube) <- list(EXIOcoureg,EXIOcoureg,AggrInd)

  for ( ind in AggrInd[2:length(AggrInd)]){
    #for ( ind in AggrInd){
    errorterms <- gravdata[,ind]-fittedlist[,ind]
    coefs <- tidylist[[ind]]$estimate
    names(coefs) <- tidylist[[ind]]$term
    for (i in 1:dim(gravdata)[1]){
      # there are no fixed effects for AUS and WWM
      FE_o = 0; FE_d = 0
      if (!(gravdata$iso3_o[i] %in% c("AUS","ZAF","WWM"))){
        FE_o = coefs[paste0("factor(iso3_o)",gravdata$iso3_o[i])]
      }
      if (!(gravdata$iso3_d[i] %in% c("AUS","ZAF","WWM"))){
        FE_d = coefs[paste0("factor(iso3_d)",gravdata$iso3_d[i])]
      }
      gravdata[i,ind] = exp(coefs["(Intercept)"] +
                            coefs["log(distw)"]*log(gravdata$distw[i]) + 
                            coefs["log(GDPEXIO_o)"]*log(gravdata$gdp_o[i]) + 
                            coefs["log(GDPEXIO_d)"]*log(gravdata$gdp_d[i]) + 
                            coefs["log(GDPcapEXIO_o)"]*log(gravdata$gdpcap_o[i]) + 
                            coefs["log(GDPcapEXIO_d)"]*log(gravdata$gdpcap_d[i]) +
                            coefs["contig"]*gravdata$contig[i] + 
                            coefs["Euro"]*gravdata$Euro[i] + 
                            coefs["EUEEA"]*gravdata$EUEEA[i] +
                            coefs["inFTA"]*gravdata$inFTA[i] +
                            coefs["intracou"]*gravdata$intracou[i] +
                            FE_o + FE_d) + errorterms[i]
      # we need to add the errorterms to the calculated estimates
      TradeCube[gravdata$iso3_o[i],gravdata$iso3_d[i],ind] <- gravdata[i,ind]
      
    }
    jpeg(paste0('GLM_R/Plots/',ind,'_',scenario,'.jpg'))
    plot(gravdataEXIOfinal[,ind])
    lines(fittedlist[,ind],type = 'p',col = 'blue')
    lines(gravdata[,ind],type = 'p',col = 'red')
    lines(errorterms,type = 'p',col = 'green')
    legend('topright', c("Actual 2014","Fitted 2014","Predicted 2030","Errors"), cex=0.8, 
           col=c('black','blue','red','green'),
           pch=1)
    title(ind)
    dev.off()
  }
  # do not save it here, because then the data in the .Rdata file
  # has the same name for all scenarios
  #save(file=paste0('GLM_R/predicted/gravdata_',scenario,'.Rdata'),gravdata)
  #save(file=paste0('GLM_R/predicted/TradeCube_',scenario,'.Rdata'),TradeCube)
  return(TradeCube)
   
}