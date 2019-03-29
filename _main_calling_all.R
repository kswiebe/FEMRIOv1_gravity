# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Main script
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com

setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
#all scripts can run individually
source('GLM_R/DataPrep_main.R')
rm(list=ls())
source('GLM_R/EstimationModel_main.R')
rm(list=ls())
source('GLM_R/FutureTradeFlows_main.R')
rm(list=ls())
source('GLM_R/TradeScenarios_main.R')
rm(list=ls())
source('GLM_R/ResultGraphs_main.R')