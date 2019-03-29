##################################################
#@ 3) CEPII gravity data incl all countries --> need to construct RoW regions
##################################################

#####################################################
#@ 3A) read CEPII data
#####################################################
cepii <- read.csv(file='gravitydata/gravdata_2014_relevant.csv',sep=';')
head(cepii)

gravdata <- cepii[,c('iso3_o','iso3_d','contig','distw','gdp_o','gdp_d','gdpcap_o','gdpcap_d','pop_o','pop_d','area_o','area_d','fta_bb')]
head(gravdata)

#test <- cast(gravdata,iso3_o ~ iso3_d,value = 'contig')
#dim(test)
#dimnames(test)
#dimnames(test)[[1]] <- test$iso3_o
#test <- test[,-1]
#test[1:5,1:5]
#test[c("DEU","NLD","DNK","BEL","LUX"),c("DEU","NLD","DNK","BEL","LUX")]


#####################################################
#@ 3B) read country concordance
#####################################################
coucon <- read.csv(file='metadata/countrylist_relevant.csv',sep=';')
head(coucon)
coucon$DESIRE.code2 = as.character(coucon$DESIRE.code)

for(c in 1:49) {
  cou = as.character(CountryNamesCodes[c,4])
  coucon$DESIRE.code2[which(coucon$DESIRE.code==cou)] = CountryNamesCodes[c,2]

}


#####################################################
#@ 3C) get gravdata in EXIO country/region classification
#####################################################


# 1) EXIO countries to EXIO countries, not RoW regions
# 2) RoW regions to RoW regions
# 3) RoW regions to and from all EXIO countries and regions

#*****************************************************
#@ 3C1) EXIO countries to EXIO countries, not RoW regions
#*****************************************************
# get gravdata for all countries in exiobase, not regions
gravdata$desire_o = NA
gravdata$desire_d = NA
for( i in 1:dim(gravdata)[1]){
  gravdata$desire_d[i] = as.character(coucon$DESIRE.code2[which(coucon$ISO3 == as.character(gravdata$iso3_d[i]))])
  gravdata$desire_o[i] = as.character(coucon$DESIRE.code2[which(coucon$ISO3 == as.character(gravdata$iso3_o[i]))])
}

# for Johannes to calculate the distw data
write_delim(gravdata,path="gravdataEXIO/gravdataEXIO_codes_2014.csv",delim=';') 

gravdataEXIOd = gravdata[which((gravdata$desire_d %in% EXIOcou)) , ]
gravdataEXIO = gravdataEXIOd[which((gravdataEXIOd$desire_o %in% EXIOcou)) , ]
gravdataEXIO$iso3_o <- as.character(gravdataEXIO$iso3_o)
gravdataEXIO$iso3_d <- as.character(gravdataEXIO$iso3_d)
rm(gravdataEXIOd)

#*****************************************************
#@ 3C2) RoW regions to RoW regions
#*****************************************************
{
gravdataEXIOregd = gravdata[which((gravdata$desire_d %in% EXIOreg)) , ]
gravdataEXIOreg = gravdataEXIOregd[which((gravdataEXIOregd$desire_o %in% EXIOreg)) , ]
rm(gravdataEXIOregd)

i = 1
gravdataRoWtemp = gravdataEXIOreg[i,]
for (expc in unique(gravdataEXIOreg$iso3_o)){
  temp = gravdataEXIOreg[which(gravdataEXIOreg$iso3_o == expc),]
  gravdataRoWtemp[i,] = temp[which(temp$iso3_d == expc),]
  i = i+1
}
gravdataRoWtemp$iso3_o = as.character(gravdataRoWtemp$iso3_o)
gravdataRoWtemp$iso3_d = as.character(gravdataRoWtemp$iso3_d)
gravdataRoWtemp$desire_o = as.character(gravdataRoWtemp$desire_o)
gravdataRoWtemp$desire_d = as.character(gravdataRoWtemp$desire_d)
i = 1
gravdataRoW = gravdataRoWtemp[i,]
for (reg in EXIOreg){
  if(i>1)gravdataRoW[i,] = gravdataRoW[i-1,]
  gravdataRoW$distw[i] = NA
  gravdataRoW$gdp_o[i] = sum(gravdataRoWtemp$gdp_o[which(gravdataRoWtemp$desire_o == reg)],na.rm=TRUE)
  gravdataRoW$gdp_d[i] = sum(gravdataRoWtemp$gdp_d[which(gravdataRoWtemp$desire_d == reg)],na.rm=TRUE)
  gravdataRoW$area_o[i] = sum(gravdataRoWtemp$area_o[which(gravdataRoWtemp$desire_o == reg)],na.rm=TRUE)
  gravdataRoW$area_d[i] = sum(gravdataRoWtemp$area_d[which(gravdataRoWtemp$desire_d == reg)],na.rm=TRUE)
  gravdataRoW$pop_o[i] = sum(gravdataRoWtemp$pop_o[which(gravdataRoWtemp$desire_o == reg)],na.rm=TRUE)
  gravdataRoW$pop_d[i] = sum(gravdataRoWtemp$pop_d[which(gravdataRoWtemp$desire_d == reg)],na.rm=TRUE)
  gravdataRoW$gdpcap_o[i] = 0.000001*gravdataRoW$gdp_o[i]/gravdataRoW$pop_o[i]
  gravdataRoW$gdpcap_d[i] = 0.000001*gravdataRoW$gdp_d[i]/gravdataRoW$pop_d[i]
  gravdataRoW$iso3_o[i] = as.character(reg)
  gravdataRoW$iso3_d[i] = as.character(reg)
  gravdataRoW$desire_o[i] = as.character(reg)
  gravdataRoW$desire_d[i] = as.character(reg)
  i = i+1
}
gravdataRoW$iso3_o <- as.character(gravdataRoW$iso3_o)
gravdataRoW$iso3_d <- as.character(gravdataRoW$iso3_d)
rm(gravdataEXIOreg)
rm(gravdataRoWtemp)

# add the RoW to same Row to the gravdataEXIO
#gravdataEXIO[(dim(gravdataEXIO)[1]+1):(dim(gravdataEXIO)[1]+dim(gravdataRoW)[1]),] <- gravdataRoW

}

#*****************************************************
#@ 3C3) RoW regions to and from all EXIO countries & regions
#*****************************************************
{
gravdataEXIOcouDUMMY <- gravdataEXIO[1:44,]
gravdataEXIOcouDUMMY[45:49,] <- gravdataRoW[1:5,]
gravdataEXIOcouDUMMY$iso3_o <- NA
gravdataEXIOcouDUMMY$contig <- NA
gravdataEXIOcouDUMMY$distw <- NA
gravdataEXIOcouDUMMY$gdp_o <- NA
gravdataEXIOcouDUMMY$gdpcap_o <- NA
gravdataEXIOcouDUMMY$pop_o <- NA
gravdataEXIOcouDUMMY$area_o <- NA
gravdataEXIOcouDUMMY$desire_o <- NA

# and for destination dummy
gravdataEXIOcouDUMMY_dest <- gravdataEXIOcouDUMMY
gravdataEXIOcouDUMMY_dest$iso3_o <- gravdataEXIOcouDUMMY$iso3_d
gravdataEXIOcouDUMMY_dest$iso3_d <- NA
gravdataEXIOcouDUMMY_dest$gdp_o <- gravdataEXIOcouDUMMY$gdp_d
gravdataEXIOcouDUMMY_dest$gdp_d <- NA
gravdataEXIOcouDUMMY_dest$gdpcap_o <- gravdataEXIOcouDUMMY$gdpcap_d
gravdataEXIOcouDUMMY_dest$gdpcap_d <- NA
gravdataEXIOcouDUMMY_dest$pop_o <- gravdataEXIOcouDUMMY$pop_d
gravdataEXIOcouDUMMY_dest$pop_d <- NA
gravdataEXIOcouDUMMY_dest$area_o <- gravdataEXIOcouDUMMY$area_d
gravdataEXIOcouDUMMY_dest$area_d <- NA
gravdataEXIOcouDUMMY_dest$desire_o <- gravdataEXIOcouDUMMY$desire_d
gravdataEXIOcouDUMMY_dest$desire_d <- NA
}

for (o in 1:length(EXIOreg)){
  icou = dim(gravdataEXIO)[1]
  print(icou)
  gravdataEXIO[(icou+1):(icou+49),] <- gravdataEXIOcouDUMMY
  orig = EXIOreg[o]
  print(orig)
  for( i in (icou+1):(icou+49)){
  gravdataEXIO$gdp_o[i] = gravdataRoW$gdp_o[o]
  gravdataEXIO$area_o[i] = gravdataRoW$area_o[o]
  gravdataEXIO$pop_o[i] = gravdataRoW$pop_o[o]
  gravdataEXIO$gdpcap_o[i] = gravdataRoW$gdpcap_o[o]
  gravdataEXIO$iso3_o[i] = gravdataRoW$iso3_o[o]
  gravdataEXIO$desire_o[i] = gravdataRoW$desire_o[o]
  }
}
temp = gravdataEXIO
# continue with i to fill off-diagonal
tobedeleted <- c()
for (d in 1:length(EXIOreg)){
  icou = dim(gravdataEXIO)[1]
  print(icou)
  gravdataEXIO[(icou+1):(icou+49),] <- gravdataEXIOcouDUMMY_dest
  dest = EXIOreg[d]
  print(dest)
  for( i in (icou+1):(icou+49)){
    gravdataEXIO$gdp_d[i] = gravdataRoW$gdp_d[d]
    gravdataEXIO$area_d[i] = gravdataRoW$area_d[d]
    gravdataEXIO$pop_d[i] = gravdataRoW$pop_d[d]
    gravdataEXIO$gdpcap_d[i] = gravdataRoW$gdpcap_d[d]
    gravdataEXIO$iso3_d[i] = gravdataRoW$iso3_d[d]
    gravdataEXIO$desire_d[i] = gravdataRoW$desire_d[d]
    if(gravdataEXIO$iso3_d[i] == gravdataEXIO$iso3_o[i])
      tobedeleted = c(tobedeleted,i)
  }
}

gravdataEXIOdraft <- gravdataEXIO[-tobedeleted,]

gravdataEXIOdraft <- gravdataEXIOdraft[-which(duplicated(gravdataEXIOdraft)),]
dim(gravdataEXIOdraft)

save(file = 'gravdataEXIO/gravdataEXIOdraft.rdata',gravdataEXIOdraft)

write_delim(gravdataEXIOdraft,path="gravdataEXIO/gravdataEXIOdraft_2014.csv",delim=';')
write_delim(gravdataRoW,path="gravdataEXIO/gravdataEXIOrow_2014.csv",delim=';')

