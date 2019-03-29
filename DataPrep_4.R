##################################################
#@ 4) Completing the gravity data 
##################################################



#*****************************************************
#@ 4A) load the data we prepared
#*****************************************************
load('gravdataEXIO/gravdataEXIOdraft.rdata')
gravdataEXIOfinal <- gravdataEXIOdraft

#*****************************************************
#@ 4B) Selvmade variables/dummies
#*****************************************************
# load trade dummies and reshape


FTA <- read.xlsx("metadata/TradeDummies.xlsx", sheet="FTA",colNames=TRUE,rowNames = TRUE)
RoWcontig <- read.xlsx("metadata/TradeDummies.xlsx", sheet="CONTIGUITYrow",colNames=TRUE,rowNames = TRUE)


# we loop through the entire gravity data frame and fill the column fta_bb
# by using iso3_o and iso3_d as the names for looking up in the matrices 
# loaded from excel

gravdataEXIOfinal$intracou <- 0

for(i in 1:dim(gravdataEXIOfinal)[1]){
  # allocation of trade agreement strength
  gravdataEXIOfinal$fta_bb[i] <- FTA[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i]]
  # allocation of intra country dummy
  if (gravdataEXIOfinal$iso3_o[i] == gravdataEXIOfinal$iso3_d[i]) 
    gravdataEXIOfinal$intracou[i] <- 1
  # allocation of RoW contiguities
  if (gravdataEXIOfinal$iso3_o[i] %in% EXIOreg)
    gravdataEXIOfinal$contig[i] <- RoWcontig[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i]]
  if (gravdataEXIOfinal$iso3_d[i] %in% EXIOreg)
    gravdataEXIOfinal$contig[i] <- RoWcontig[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i]]
    
}

gravdataEXIOfinal$Euro <- 0
gravdataEXIOfinal$Euro[which(gravdataEXIOfinal$fta_bb==3)] <- 1
gravdataEXIOfinal$EUEEA <- 0
gravdataEXIOfinal$EUEEA[which(gravdataEXIOfinal$fta_bb==2)] <- 1
gravdataEXIOfinal$inFTA <- 0
gravdataEXIOfinal$inFTA[which(gravdataEXIOfinal$fta_bb==1)] <- 1


#*****************************************************
#@ 4C) distance
#*****************************************************
gravdata_raw <- read.csv('gravdataEXIO/gravdataEXIO_codes_2014.csv', header = TRUE, sep = ';' )
gravdata_raw$prod_pop_dist <- gravdata_raw$pop_d * gravdata_raw$pop_o  
gravdata_raw$prod_gdp_dist <- gravdata_raw$gdp_o * gravdata_raw$gdp_d / 1e12
gravdata_raw$prod_pop <- gravdata_raw$pop_d * gravdata_raw$pop_o * gravdata_raw$distw 
gravdata_raw$prod_gdp <- gravdata_raw$gdp_o * gravdata_raw$gdp_d * gravdata_raw$distw/ 1e12

tmp=gravdata_raw
for (i in 1:dim(gravdataEXIOfinal)[1]) {
  if (is.na(gravdataEXIOfinal$distw)[i]){
    tmp=subset.data.frame(gravdata_raw,gravdata_raw$desire_o == gravdataEXIOfinal$iso3_o[i] & gravdata_raw$desire_d == gravdataEXIOfinal$iso3_d[i])
    tmp$pop_weight=tmp$prod_pop/sum(tmp$prod_pop, na.rm = TRUE)
    gravdataEXIOfinal$distw[i]=sum(tmp$distw*tmp$pop_weight, na.rm = TRUE)
  }
}

tmp=gravdata_raw
for (i in 1:dim(gravdataEXIOfinal)[1]) {
  tmp=subset.data.frame(gravdata_raw,gravdata_raw$desire_o == gravdataEXIOfinal$iso3_o[i] & gravdata_raw$desire_d == gravdataEXIOfinal$iso3_d[i])
  tmp$gdp_weight=tmp$prod_gdp/sum(tmp$prod_gdp, na.rm = TRUE)
  gravdataEXIOfinal$distgdp[i]=sum(tmp$distw*tmp$gdp_weight, na.rm = TRUE)
}


#*****************************************************
#@ 4D) GDP and population from EXIOBASE
#*****************************************************


gravdataEXIOfinal$GDPEXIO_o <- 0
gravdataEXIOfinal$GDPEXIO_d <- 0
gravdataEXIOfinal$POPEXIO_o <- 0
gravdataEXIOfinal$POPEXIO_d <- 0

year <- "2014"

for(i in 1:dim(gravdataEXIOfinal)[1]){
  gravdataEXIOfinal$GDPEXIO_o[i] <- EXIO.GDPTR[gravdataEXIOfinal$iso3_o[i],year]
  gravdataEXIOfinal$GDPEXIO_d[i] <- EXIO.GDPTR[gravdataEXIOfinal$iso3_d[i],year]
  gravdataEXIOfinal$POPEXIO_o[i] <- EXIO.POPU[gravdataEXIOfinal$iso3_o[i],year]
  gravdataEXIOfinal$POPEXIO_d[i] <- EXIO.POPU[gravdataEXIOfinal$iso3_d[i],year]
}

gravdataEXIOfinal$GDPcapEXIO_o <- gravdataEXIOfinal$GDPEXIO_o/gravdataEXIOfinal$POPEXIO_o
gravdataEXIOfinal$GDPcapEXIO_d <- gravdataEXIOfinal$GDPEXIO_d/gravdataEXIOfinal$POPEXIO_d

#*****************************************************
#@ 4E) trade data
#*****************************************************

#gravdataEXIOfinalsave <- gravdataEXIOfinal
#gravdataEXIOfinal <- gravdataEXIOfinalsave
gravdataEXIOfinal$totaltrade <- 0
tottrade <- as.array(totallist[[1]]) #intermed and final trade
dimnames(tottrade) <- list(CountryNamesCodes[,2],CountryNamesCodes[,2],IndustryNamesCodes[,3])

TradeSharesCubeIndEXIO2014 = array(0,dim = dim(tottrade))
dimnames(TradeSharesCubeIndEXIO2014) <- dimnames(tottrade)
for(i in 1:nind){
  for(impc in 1:nreg)
    for(expc in 1:nreg)
      TradeSharesCubeIndEXIO2014[expc,impc,i] <- tottrade[expc,impc,i]/sum(tottrade[,impc,i])
}
TradeSharesCubeIndEXIO2014[is.nan(TradeSharesCubeIndEXIO2014)] = 0
save(TradeSharesCubeIndEXIO2014,file='gravdataEXIO/TradeSharesCubeIndEXIO2014.rdata')
TradeCubeIndEXIO2014 <- tottrade
save(TradeCubeIndEXIO2014,file='gravdataEXIO/TradeCubeIndEXIO2014.rdata')
# plot trade shares
for ( ind in 1:163){
  jpeg(paste0('GLM_R/TradeSharePlots/Orig_',ind,'.jpg'),
       width = 480,        
       height = 480)
  par(mfrow = c(1,1))
  image(t(TradeSharesCubeIndEXIO2014[,,ind]),col = terrain.colors(256), axes=F)
  mtext(text=1:49, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
  mtext(text=1:49, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
  title(paste0(ind," EXIO2014"))
  dev.off()
}

rm(TradeCubeIndEXIO2014)
rm(TradeSharesCubeIndEXIO2014)

for(i in 1:dim(gravdataEXIOfinal)[1]){
  gravdataEXIOfinal$totaltrade[i] <- sum(tottrade[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i],])
}

# add industry groups
IndAgg <- read.csv2('metadata/IndustryAggregates.csv',sep=";")
dimnames(IndAgg)[[1]] <- IndAgg[,1]
IndAgg <- IndAgg[,-1]

currsize <- dim(gravdataEXIOfinal)[2]
for (j in 1:dim(IndAgg)[2]){
  temp <- array(0,dim=c(dim(gravdataEXIOfinal)[1],1))
  for(i in 1:dim(gravdataEXIOfinal)[1]){
    temp[i] <- sum(tottrade[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i],which(IndAgg[,j]==1)])
  }
  gravdataEXIOfinal <- cbind(gravdataEXIOfinal,temp)
}
names(gravdataEXIOfinal)[(currsize+1):dim(gravdataEXIOfinal)[2]] <- dimnames(IndAgg)[[2]]


# add all individual industries
#currsize <- dim(gravdataEXIOfinal)[2]
#for (j in 1:dim(tottrade)[3]){
#  temp <- array(0,dim=c(dim(gravdataEXIOfinal)[1],1))
#  for(i in 1:dim(gravdataEXIOfinal)[1]){
#    temp[i] <- tottrade[gravdataEXIOfinal$iso3_o[i],gravdataEXIOfinal$iso3_d[i],j]
#  }
#  gravdataEXIOfinal <- cbind(gravdataEXIOfinal,temp)
#}
#names(gravdataEXIOfinal)[(currsize+1):dim(gravdataEXIOfinal)[2]] <- IndustryNamesCodes[,3]

#*****************************************************
#@ 4G) save data
#*****************************************************
save(file = 'gravdataEXIO/gravdataEXIOfinal.rdata',gravdataEXIOfinal)
write_delim(gravdataEXIOfinal,path="gravdataEXIO/gravdataEXIOfinal_2014.csv",delim=';')




