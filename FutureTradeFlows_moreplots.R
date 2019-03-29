# Gravity model for FEMRIOv1IEAETP
# using CEPII data

#***********************************************
# Calculating future trade flows more plots
#***********************************************
# by Kirsten S. Wiebe and Johannes Többen
# Februar 2019

# contact: kswiebe@gmail.com


setwd('C:/Users/kirstesw/Dropbox/CurrentWork/Paper 3 - Green economy transition and the SDGs/Gravity model/')
source('GLM_R/DataPrep_1.R')


load('GLM_R/predicted/TradeSharesCubeIEAETP.Rdata')

# create heatmap and don't reorder columns
ind = "Agriculture"
ind= "ManTransp"
ind= "TranspLand"
heatmap(TradeSharesCubeIEAETP[,,ind], Colv=NA,Rowv = NA, scale='none',col = terrain.colors(256))
write.csv(TradeSharesCubeIEAETP[,,ind],file = "heatmaptest.csv")


################################
# http://www.r-graph-gallery.com/27-levelplot-with-lattice/
install.packages('lattice')
library(lattice)

###########################################################
# https://plot.ly/r/heatmaps/
install.packages('plotly')
library(plotly)
packageVersion('plotly')
p <- plot_ly(z = volcano, type = "heatmap")

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="heatmap-simple")
chart_link


###########################################################
# https://sebastianraschka.com/Articles/heatmaps_in_r.html 
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

# creates a own color palette from red to green
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 49)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(-1,0,length=100),  # for red
               seq(0.01,0.8,length=100),           # for yellow
               seq(0.81,1,length=100))             # for green

png("../images/heatmaps_in_r.png",    # create PNG for the heat map        
    width = 5*300,        # 5 x 300 pixels
    height = 5*300,
    res = 300,            # 300 pixels per inch
    pointsize = 8)        # smaller font size


heatmap.2(TradeSharesCubeIEAETP[,,ind],
          cellnote = TradeSharesCubeIEAETP[,,ind],  # same data set for cell labels
          main = ind)#, # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
#          margins =c(12,9),     # widens margins around plot
#          col=my_palette,       # use on color palette defined earlier
#          breaks=col_breaks,    # enable color transition at specified limits
#          dendrogram="row",     # only draw a row dendrogram
          Colv="NA")            # turn off column clustering

dev.off()