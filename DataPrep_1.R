##################################################
#@ 1) read country and industry names
##################################################
library(openxlsx)
IndustryNamesCodes <- read.xlsx("metadata/EXIOBASE_metadata.xlsx", sheet="Industries163",colNames=FALSE)
head(IndustryNamesCodes)
CountryNamesCodes <- read.xlsx("metadata/EXIOBASE_metadata.xlsx", sheet="Countries",colNames=FALSE)
head(CountryNamesCodes)

# EXIO country/region codes 49
EXIOcoureg = CountryNamesCodes[,2]#unique(coucon$DESIRE.code2)
# EXIO individual countries: 44
EXIOcou = EXIOcoureg[-(45:49)]
# EXIO regions: 5
EXIOreg = EXIOcoureg[45:49]

nind = 163
nreg = 49
nfd = 7


# get industry groupings
IndAgg <- read.csv2('metadata/IndustryAggregates.csv',sep=";")
dimnames(IndAgg)[[1]] <- IndAgg[,1]
IndAgg <- IndAgg[,-1]


# aggregation to country by country
aggrci2c <- array(0,dim=c(nreg,nreg*nind))
for(c in 1:nreg){
  c1 = (c-1)*nind + 1
  c2 = c*nind
  aggrci2c[c,c1:c2] <- 1
}
