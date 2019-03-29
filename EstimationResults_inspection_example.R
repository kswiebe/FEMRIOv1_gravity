# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#*************************************
# Look at model results: example
#*************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')

# load results
load('GLM_R/TidyRegressionResults.Rdata')
load('GLM_R/SummaryRegressionResults.Rdata')


# look at individual results
summarylist$ManTextiles

# look at all results
View(tidylist)

tidydf <- as.data.frame(tidylist)
mode(tidydf)

write.table(tidydf,file='GLM_R/TidyResultsOverview.csv',sep=';',
            col.names=TRUE, row.names=TRUE, append=FALSE,na="NA")

write.table(tidydf,file='GLM_R/TidyResultsOverview_contig.csv',sep=';',
           col.names=TRUE, row.names=TRUE, append=FALSE,na="NA")
