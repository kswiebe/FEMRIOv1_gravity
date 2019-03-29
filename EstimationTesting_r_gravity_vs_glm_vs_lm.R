TotalTrade.glm <- glm(totaltrade ~ gdp_o + gdp_d + distw + factor(iso3_o) + factor(iso3_d),
                      data=gravdataEXIOfinal, family = "poisson")
TotalTrade.glm <- glm(totaltrade ~ log(gdp_o) + log(gdp_d) + #log(distw) + #FTA dummy seems more important
                        log(gdpcap_o) + log(gdpcap_d) +
                        log(area_o) + log(area_d) +
                        fta_bb + contig + intracou +
                        -1 + # intercept --> does it make sense with fixed effects?
                        factor(iso3_o) + factor(iso3_d),
                      data=gravdataEXIOfinal, family = quasipoisson(link="log") )
summary(TotalTrade.glm)

TotalTrade.lm <- lm(log(totaltrade) ~ log(gdp_o) + log(gdp_d) + log(distw) + #FTA dummy seems more important
                      log(gdpcap_o) + log(gdpcap_d) +
                      log(area_o) + log(area_d) +
                      #fta_bb + 
                      contig + intracou +
                      -1 + # intercept --> does it make sense with fixed effects?
                      factor(iso3_o) + factor(iso3_d),
                    data=gravdataEXIOfinal)
summary(TotalTrade.lm)

###########################################################

install.packages('gravity')
library(gravity)

# simple averages
fit2 <- bvu(
  dependent_variable = "totaltrade",
  distance = "distw",
  additional_regressors = c("fta_bb", "contig", "intracou"),
  income_origin = "gdp_o",
  income_destination = "gdp_d",
  code_origin = "iso3_o",
  code_destination = "iso3_d",
  data = gravdataEXIOfinal
)

tidy(fit2)


fit <- ddm(
  dependent_variable = "totaltrade",
  distance = "distw",
  additional_regressors = c("fta_bb", "intracou", "contig"),
  code_origin = "iso3_o",
  code_destination = "iso3_d",
  data = gravdataEXIOfinal
)

summary(fit)


fit3 <- ppml(
  dependent_variable = "totaltrade",
  distance = "distw",
  additional_regressors = c("fta_bb", "contig", "intracou"),
  income_origin = "gdp_o",
  income_destination = "gdp_d",
  code_origin = "iso3_o",
  code_destination = "iso3_d",
  robust = TRUE,
  data = gravdataEXIOfinal
)
summary(fit3)
tidy(fit3)
glance(fit3)


fit3 <- ppml(
  dependent_variable = "totaltrade",
  distance = "distw",
  additional_regressors = c("fta_bb", "contig", "intracou"),
  code_origin = "iso3_o",
  code_destination = "iso3_d",
  robust = TRUE,
  data = gravdataEXIOfinal
)
summary(fit3)

TotalTrade.glm <- glm(totaltrade ~ log(distw) + #FTA dummy seems more important
                        #log(gdpcap_o) + log(gdpcap_d) +
                        #log(area_o) + log(area_d) +
                        fta_bb + contig + intracou, #+
                      #-1 + # intercept --> does it make sense with fixed effects?
                      #factor(iso3_o) + factor(iso3_d),
                      data=gravdataEXIOfinal, family = quasipoisson(link="log") )
summary(TotalTrade.glm)
