# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#*************************************
# Model set up and estimation
#*************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


# Poisson maximum likelihood
# https://www.r-bloggers.com/poisson-regression-fitted-by-glm-maximum-likelihood-and-mcmc/
# GLM and pseudo maximum likelihood are the same for poisson

#install.packages('broom')
library(broom)
#install.packages("tidyverse")
library(tidyverse)

setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')

# 1) Initializations
# 1A read country and industry names
source('GLM_R/DataPrep_1.r')
# 1B) load data
load('gravDataEXIO/gravdataEXIOfinal.Rdata')

# 2) GLM on total trade

# 2.1) CEPII gdp and popu data

#source('GLM_R/EstimationModel_cepii_gdp.R')




# 2.1) EXIOBASE gdp and popu data

# PSEUDO R squared: 
# http://rcompanion.org/handbook/G_10.html 
#install.packages('rcompanion')
#if(!require(psych)){install.packages("psych")}
#if(!require(lmtest)){install.packages("lmtest")}
#if(!require(boot)){install.packages("boot")}
#if(!require(rcompanion)){install.packages("rcompanion")}
#library(rcompanion)

#gravdataEXIOfinal$fta_bb = gravdataEXIOfinal$Euro + gravdataEXIOfinal$EUEEA + gravdataEXIOfinal$inFTA
TotalTrade.glm.test <- glm(totaltrade ~ log(distw) + #FTA dummy seems more important
                             log(GDPEXIO_o) + log(GDPEXIO_d) + 
                             log(GDPcapEXIO_o) + log(GDPcapEXIO_d) +
                             #log(area_o) + log(area_d) +
                             #fta_bb + # is the common Euro EUEEA inFTA
                             contig + 
                             Euro + EUEEA + inFTA +
                             intracou +
                             #-1 + # intercept --> does it make sense with fixed effects? yes, bc it's non-linear
                             factor(iso3_o) + factor(iso3_d),
                           data=gravdataEXIOfinal, family = quasipoisson(link="log") )
summary(TotalTrade.glm.test)
1-TotalTrade.glm.test$deviance/TotalTrade.glm.test$null.deviance

#nagelkerke(TotalTrade.glm.test) # works with gausiian, not with quasipoisson

# basic start for all industries
TotalTrade.glm <- glm(totaltrade ~ log(distw) + #FTA dummy seems more important
                        log(GDPEXIO_o) + log(GDPEXIO_d) + 
                        log(GDPcapEXIO_o) + log(GDPcapEXIO_d) +
                        #log(area_o) + log(area_d) +
                        #fta_bb + 
                        contig + 
                        Euro + EUEEA + inFTA +
                        intracou +
                        #-1 + # intercept --> does it make sense with fixed effects? yes, bc it's non-linear
                        factor(iso3_o) + factor(iso3_d),
                      data=gravdataEXIOfinal, family = quasipoisson(link="log") )
summarylist <- summary(TotalTrade.glm)
tidylist <- tidy(TotalTrade.glm)
#glance(TotalTrade.glm)



one = which(names(gravdataEXIOfinal)=='totaltrade')+1
AggrInd <- names(gravdataEXIOfinal)[one:dim(gravdataEXIOfinal)[2]]
tidynames <- c('Total',AggrInd)

fittedlist <- array(0,dim=c(dim(gravdataEXIOfinal)[1],length(tidynames)))
dimnames(fittedlist)[[2]] <- tidynames
fittedlist[,1] <- TotalTrade.glm$fitted.values

pseudoRsq <- array(0,dim=c(length(tidynames)))
dimnames(pseudoRsq)[[1]] <- tidynames
pseudoRsq[1] <- 1-TotalTrade.glm$deviance/TotalTrade.glm$null.deviance
#for( i in AggrInd){
#  print(i)
#}

for( i in AggrInd){
  #gravdataEXIOfinal$temp <- gravdataEXIOfinal[i][[1]]
  trade.glm <- glm(gravdataEXIOfinal[i][[1]] ~ log(distw) + #FTA dummy seems more important
                     log(GDPEXIO_o) + log(GDPEXIO_d) + 
                     log(GDPcapEXIO_o) + log(GDPcapEXIO_d) +
                     #log(area_o) + log(area_d) +
                     #fta_bb + 
                     contig + 
                     Euro + EUEEA + inFTA +
                     intracou +
                     #-1 + # intercept --> does it make sense with fixed effects? yes, bc it's non-linear
                     factor(iso3_o) + factor(iso3_d),
                   data=gravdataEXIOfinal, family = quasipoisson(link="log") )
  
  summarylist[[i]] <- summary(trade.glm)
  tidylist[[i]] <- tidy(trade.glm)
  fittedlist[,i] <- trade.glm$fitted.values
  pseudoRsq[i] <- 1-trade.glm$deviance/trade.glm$null.deviance
  
}
#dim(fittedlist)
#dimnames(fittedlist)[[2]] <- tidynames
#names(tidylist) <- tidynames
#names(summarylist) <- tidynames
save(file='GLM_R/TidyRegressionResults_exio.Rdata',tidylist)
save(file='GLM_R/SummaryRegressionResults_exio.Rdata',summarylist)
save(file='GLM_R/FittedRegressionResults_exio.Rdata',fittedlist)
save(file='GLM_R/AggrInd.Rdata',AggrInd)


# look at all results
#View(tidylist)

tidydf <- as.data.frame(tidylist)
#mode(tidydf)

#write.table(tidydf,file=paste0('GLM_R/TidyResultsOverview ',Sys.time(),'.csv'),sep=';',
write.table(tidydf,file='GLM_R/TidyResultsOverview_exio.csv',sep=';',
            col.names=TRUE, row.names=TRUE, append=FALSE,na="NA")

write.table(pseudoRsq,file='GLM_R/TidyResultsOverview_exio_pseudoRsq.csv',sep=';',
            col.names=TRUE, row.names=TRUE, append=FALSE,na="NA")


