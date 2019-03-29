# basic start for all industries
TotalTrade.glm <- glm(totaltrade ~ log(distw) + #FTA dummy seems more important
                        log(gdp_o) + log(gdp_d) + 
                        log(gdpcap_o) + log(gdpcap_d) +
                        #log(area_o) + log(area_d) +
                        #fta_bb + 
                        #contig + 
                        Euro + EUEEA + #inFTA +
                        intracou +
                        #-1 + # intercept --> does it make sense with fixed effects? yes, bc it's non-linear
                        factor(iso3_o) + factor(iso3_d),
                      data=gravdataEXIOfinal, family = quasipoisson(link="log") )
summarylist <- summary(TotalTrade.glm)
fittedlist <- TotalTrade.glm$fitted.values
tidylist <- tidy(TotalTrade.glm)
#glance(TotalTrade.glm)

one = which(names(gravdataEXIOfinal)=='totaltrade')+1
AggrInd <- names(gravdataEXIOfinal)[one:dim(gravdataEXIOfinal)[2]]
tidynames <- c('Total',AggrInd)


#for( i in AggrInd){
#  print(i)
#}

for( i in AggrInd){
  #gravdataEXIOfinal$temp <- gravdataEXIOfinal[i][[1]]
  trade.glm <- glm(gravdataEXIOfinal[i][[1]] ~ log(distw) + #FTA dummy seems more important
                     log(gdp_o) + log(gdp_d) + 
                     log(gdpcap_o) + log(gdpcap_d) +
                     #log(area_o) + log(area_d) +
                     #fta_bb + 
                     #contig + 
                     Euro + EUEEA + #inFTA +
                     intracou +
                     #-1 + # intercept --> does it make sense with fixed effects? yes, bc it's non-linear
                     factor(iso3_o) + factor(iso3_d),
                   data=gravdataEXIOfinal, family = quasipoisson(link="log") )
  
  summarylist[[i]] <- summary(trade.glm)
  tidylist[[i]] <- tidy(trade.glm)
  #  fittedlist[[i]] <- trade.glm$fitted.values
  
}
#names(tidylist) <- tidynames
#names(summarylist) <- tidynames
save(file='GLM_R/TidyRegressionResults_cepii.Rdata',tidylist)
save(file='GLM_R/SummaryRegressionResults_cepii.Rdata',summarylist)
#save(file='GLM_R/fittedRegressionResults_cepii.Rdata',summarylist)



# look at all results
#View(tidylist)

tidydf <- as.data.frame(tidylist)
mode(tidydf)

#write.table(tidydf,file=paste0('GLM_R/TidyResultsOverview ',Sys.time(),'.csv'),sep=';',
write.table(tidydf,file='GLM_R/TidyResultsOverview_cepii.csv',sep=';',
            col.names=TRUE, row.names=TRUE, append=FALSE,na="NA")

