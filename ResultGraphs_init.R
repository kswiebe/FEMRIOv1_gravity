# initializations for the result graphs

scenarionames <- c('constantShares','IEAETP','OECDbase','OECDreforms','BRIICScatchup','lesserTrade')
scenariocol <- c('black','green','darkgreen','blue','orange','red')
scenariopch <- c(20,1,3,4,8,18)


# new country order
newcoureg = array("",dim=c(nreg,1))
newcoureg[1:28] = EXIOcoureg[1:28]
newcoureg[45:49] = EXIOreg
newcoureg[29:37] = EXIOcoureg[c(29,30,32,33,36,38:40,42)] #OECD
newcoureg[38:44] = EXIOcoureg[c(34,37,35,43,31,44,41)] #BRIICS + TWN
couaggr <- read.csv('metadata/CountryAggregates.csv',sep=';')
dimnames(couaggr)[[1]] <- couaggr[,1]
couaggr <- couaggr[,-1]
coucol <- c('blue','darkblue','green','darkgreen','orange','yellow')