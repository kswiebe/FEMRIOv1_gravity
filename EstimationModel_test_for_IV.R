###########################################################
# test for 
#   using instrument for FTAs and distance
#   storing regr output in list
distfta.lm <- lm(distw ~fta_bb, data = gravdataEXIOfinal)
summary(distfta.lm)
tidylist <- tidy(distfta.lm)
glance(distfta.lm)
distwfta <- distfta.lm$fitted.values
plot(distwfta,gravdataEXIOfinal$distw)


distcon.lm <- lm(distw ~contig, data = gravdataEXIOfinal)
tidylist <- list(tidylist,tidy(distcon.lm))
names(tidylist) <- c('disfta','discon')

tidylist
tidylist$disfta
