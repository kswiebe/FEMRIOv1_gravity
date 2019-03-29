##################################################
#@ 2) read EXIOBASE data for 2014 from matlab file
##################################################
#install.packages('rmatio')
library(rmatio)


#*****************************************************
#@ 2A) Trade data
#*****************************************************
## Read a version 4 MAT file with little-endian byte ordering
#filename <- system.file('Matlab_GetFEMRIOdata/TradeCube.mat', package='rmatio')
filename <- 'Matlab_GetFEMRIOdata/EXIOhist/TradeCube.mat'
m <- read.mat(filename)
## View content
str(m)

TradeCube <- as.data.frame(m)

#@ 2A1) Intermediate trade
intermediatelist <-as.array(m[[1]][[1]])
intermediatelist[[1]][ ,1,1]
intermediate <- intermediatelist[[1]][,,]
dim(intermediate)
dimnames(intermediate) <- list(CountryNamesCodes[,2],CountryNamesCodes[,2],IndustryNamesCodes[,3])
intermediate[1:5,1:5,1]

library(reshape)
intmelt <- melt(intermediate)
names(intmelt) <- c("exp","imp","prod","value")
head(intmelt)

#@ 2A2) Final trade
finallist <-as.array(m[[1]][[2]])
final <- finallist[[1]][,,]
dimnames(final) <- list(CountryNamesCodes[,2],CountryNamesCodes[,2],IndustryNamesCodes[,3])
finmelt <- melt(final)
names(finmelt) <- c("exp","imp","prod","value")
head(finmelt)

#@ 2A3) Total trade
totallist <-as.array(m[[1]][[3]])
total <- totallist[[1]][,,]
dimnames(total) <- list(CountryNamesCodes[,2],CountryNamesCodes[,2],IndustryNamesCodes[,3])
totmelt <- melt(total)
names(totmelt) <- c("exp","imp","prod","value")
head(totmelt)



#*****************************************************
#@ 2B) Demand
#*****************************************************
filename <- 'Matlab_GetFEMRIOdata/EXIOhist/Demand.mat'
m <- read.mat(filename)
demandint <- as.array(m[[1]][[1]])[[1]]
names(demandint) <- list(CountryNamesCodes[,2],IndustryNamesCodes[,3])
demandfin <- as.array(m[[1]][[2]])[[1]]
names(demandfin) <- list(CountryNamesCodes[,2],IndustryNamesCodes[,3])
demandtot <- as.array(m[[1]][[3]])[[1]]
names(demandtot) <- list(CountryNamesCodes[,2],IndustryNamesCodes[,3])
demandtot-demandint-demandfin

#*****************************************************
#@ 2C) Production
#*****************************************************
filename <- 'Matlab_GetFEMRIOdata/EXIOhist/Production.mat'
m <- read.mat(filename)
production <- as.array(m[[1]][[1]])[[1]]
dimnames(production) <- list(CountryNamesCodes[,2],IndustryNamesCodes[,3])
dim(production)
production[1:5,1:5]

#*****************************************************
# 2D) GDP
#*****************************************************
filename <- 'Matlab_GetFEMRIOdata/EXIOhist/ExioGDP.mat'
m <- read.mat(filename)
exiogdp <- as.array(m[[1]])
names(exiogdp) <- CountryNamesCodes[,2]
plot(exiogdp)


#*****************************************************
# 2E) MacroData 
#*****************************************************
filename <- 'C:/Users/kirstesw/Dropbox/FEMRIOv1_EXIOfuturesIEAETP/futures/6degrees/MacroData.mat'
m <- read.mat(filename)
## View content
#str(m)
EXIO.GDPTR <- as.data.frame(m$MacroData$GDPTRshouldbe)
EXIO.POPU <- as.data.frame(m$MacroData$POPU)
dim(EXIO.GDPTR)
dimnames(EXIO.GDPTR)[[1]] <- CountryNamesCodes[,2]
dimnames(EXIO.POPU)[[1]] <- CountryNamesCodes[,2]
dimnames(EXIO.GDPTR)[[2]] <- as.character(c(1995:2030))
dimnames(EXIO.POPU)[[2]] <- as.character(c(1995:2050))
