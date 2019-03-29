# Poisson maximum likelihood
# https://www.r-bloggers.com/poisson-regression-fitted-by-glm-maximum-likelihood-and-mcmc/

# GLM and pseudo maximum likelihood are the same for poisson
setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')

#install.packages('readr')
library(readr)
#install.packages("openxlsx")
library(openxlsx)
library(reshape)

# 1) read country and industry names
source('GLM_R/DataPrep_1.r')

# 2) read EXIOBASE data for 2014 from matlab file
# 2A) Trade data 
# 2A1) Intermediate trade
# 2A2) Final trade
# 2A3) Total trade
# 2B) Demand
# 2C) Production
# 2D) GDP
# --> 2E) make it compatible with gravdata-frame
source('GLM_R/DataPrep_2.r')

# 3) CEPII gravity data incl all countries
# 3A) read CEPII data
# 3B) read country concordance
# 3C) get gravdata in EXIO country/region classification
# 3C1) EXIO countries to EXIO countries, not RoW regions
# 3C2) RoW regions to RoW regions
# 3C3) RoW regions to and from all EXIO countries and regions
# 3D) Save the dataframe
source('GLM_R/DataPrep_3.r')



# 4) Completing the gravity data 
# 4A) load the data frame
# 4B) Selvmade variables/dummies
#     - Trade agreement data
#     - Intracountry dummies
#     - contiguity for world regions
# 4C) distw
# 4D) trade data
source('GLM_R/DataPrep_4.r')




