#####################################################################
compPBACBAexioieaetp <- cbind(PBA_CO2_2DS_exio2030,PBA_CO2_2DS_ieaetp2030,CBA_CO2_2DS_exio2030,CBA_CO2_2DS_ieaetp2030)
dimnames(compPBACBAexioieaetp)[[2]] <- c("PBA exio","PBA ieaetp","CBA exio","CBA ieaetp")
par(mfrow = c(1,1))
barplot(t(compPBACBAexioieaetp), beside=TRUE,legend = dimnames(compPBACBAexioieaetp)[[2]])

compPBACBAexioieaetp_percdiff <- cbind(PBA_CO2_2DS_ieaetp2030/PBA_CO2_2DS_exio2030-1,CBA_CO2_2DS_ieaetp2030/CBA_CO2_2DS_exio2030-1)
dimnames(compPBACBAexioieaetp_percdiff)[[2]] <- c("PBA ieaetp/exio","CBA ieaetp/exio")
par(mfrow = c(1,1))
plot(compPBACBAexioieaetp_percdiff[,1], type = 'p')
lines(compPBACBAexioieaetp_percdiff[,2],type = 'p', col='red')


compPBACBAexioieaetp_pc <- cbind(PBA_CO2_2DS_exio2030_pc,PBA_CO2_2DS_ieaetp2030_pc,CBA_CO2_2DS_exio2030_pc,CBA_CO2_2DS_ieaetp2030_pc)
dimnames(compPBACBAexioieaetp_pc)[[2]] <- c("PBA exio","PBA ieaetp","CBA exio","CBA ieaetp")
barplot(t(compPBACBAexioieaetp_pc), beside=TRUE,legend = dimnames(compPBACBAexioieaetp_pc)[[2]])

jpeg(paste0('FootprintPlots/Comparison.jpg'),
     width = 960,        
     height = 480)
par(mfrow = c(1,1))
barplot(t(compPBACBAexioieaetp), beside=TRUE,
        col = c('darkred','red','darkblue','blue'),
        legend = dimnames(compPBACBAexioieaetp)[[2]])

#  barplot(t(compPBACBAexioieaetp_pc), beside=TRUE,
#          col = c('darkred','red','darkblue','blue'),
#          legend = dimnames(compPBACBAexioieaetp_pc)[[2]])
dev.off()
write.csv(compPBACBAexioieaetp,file='FootprintPlots/compPBACBAexioieaetp.csv')


jpeg(paste0('FootprintPlots/Comparison_percapita.jpg'),
     width = 960,        
     height = 480)
par(mfrow = c(1,1))
barplot(t(compPBACBAexioieaetp_pc), beside=TRUE,
        col = c('darkred','red','darkblue','blue'),
        legend = dimnames(compPBACBAexioieaetp_pc)[[2]])
dev.off()
write.table(compPBACBAexioieaetp_pc,file='FootprintPlots/compPBACBAexioieaetp_percapita.csv')


jpeg(paste0('GLM_R/FootprintPlots/Const_IEAETP_comp_heatmap.jpg'),
     width = 960,        
     height = 480)
par(mfrow = c(1,2))
image(t(C02cxc_2DS_exio2030),col = terrain.colors(256), axes=F)
mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
title(paste0("Constant trade shares (2DS)"))
image(t(C02cxc_2DS_ieaetp2030),col = terrain.colors(256), axes=F)
mtext(text=EXIOcoureg, side=2, line=0.3, at=seq(0,1,1/48), las=1, cex=0.7)
mtext(text=EXIOcoureg, side=1, line=0.3, at=seq(0,1,1/48), las=2, cex=0.7)
title(paste0("Gravity IEAETP (2DS)"))
dev.off()

