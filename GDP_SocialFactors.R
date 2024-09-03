setwd("~/Desktop/Statistica")

#Data cleaning 
#We started by downloading some useful library
library(tidyverse)

data_gdp = read_csv("gdp.csv", skip = 4)
data_gdp = data_gdp %>%select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
gdp_final = data_gdp %>% gather(key= "Year", value = "gdp", -"Country", -"Code") %>% drop_na()

data_netmig = read_csv("netmigration.csv", skip = 4)
data_netmig= data_netmig %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
netmig_final = data_netmig %>% gather(key= "Year", value = "netmigration", -"Country", -"Code") %>% drop_na()
all_data = gdp_final
all_data = left_join(all_data,select(netmig_final, Code, Year, netmigration), by = c("Code", "Year"))

data_fert= read_csv("fertilityrate.csv", skip =4)
data_fert= data_fert %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
fert_final = data_fert %>% gather(key= "Year", value = "fertilityrate", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(fert_final, Code, Year, fertilityrate), by = c("Code", "Year"))

data_mortfem= read_csv("mortalityratefemale.csv", skip =4)
data_mortfem= data_mortfem %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
mortfem_final = data_mortfem %>% gather(key= "Year", value = "mortalityratefemale", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(mortfem_final, Code, Year, mortalityratefemale), by = c("Code", "Year"))

data_mortmal= read_csv("mortalityratemale.csv", skip =4)
data_mortaml= data_mortmal %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
mortmal_final = data_mortmal %>% gather(key= "Year", value = "mortalityratemale", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(mortmal_final, Code, Year, mortalityratemale), by = c("Code", "Year"))

data_unem= read_csv("unemployment.csv", skip =4)
data_unem= data_unem %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
unem_final = data_unem %>% gather(key= "Year", value = "unemployment", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(unem_final, Code, Year, unemployment), by = c("Code", "Year"))

data_primedu= read_csv("primaryeducation.csv", skip =4)
data_primedu= data_primedu %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
primedu_final = data_primedu %>% gather(key= "Year", value = "primaryeducation", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(primedu_final, Code, Year, primaryeducation), by = c("Code", "Year"))

data_secedu= read_csv("secondaryeducation.csv", skip =4)
data_secedu= data_secedu %>% select(-"Indicator Name", -"Indicator Code")%>%rename(Country = "Country Name", Code = "Country Code")
secedu_final = data_secedu %>% gather(key= "Year", value = "secondaryeducation", -"Country", -"Code") %>% drop_na()
all_data = left_join(all_data,select(secedu_final, Code, Year, secondaryeducation), by = c("Code", "Year"))

#for labour force the procedure was little different because data come from a different source

data_labf = read_csv("Laborforce.csv")
labf_final= data_labf %>% select(-"INDICATOR", -"SUBJECT", -"MEASURE", -"FREQUENCY", -"Flag Codes")%>%rename(Code = "LOCATION", Year = "TIME", labourforce = "Value")
labf_final$Year = as.character(labf_final$Year)
all_data = left_join(all_data,select(labf_final, Code, Year, labourforce), by = c("Code", "Year"))

#We exported the file to work on it any time
write.table(all_data, "Researchdata.csv")
expdata(all_data, "Researchdata.csv")
#we open our file
raw_data = read.csv("Researchdata.csv")
View(raw_data)

#setting up the data for regression
df = na.omit(raw_data)
all_variables = c("gdp", "fertilityrate", "netmigration", "unemployment", "primaryeducation", "mortalityratefemale", "mortalityratemale", "labourforce", "grossfixedcapital", "secondaryeducation")
df = log(df[all_variables])

#NAs were generated when taking the logarithm of negative data (netmigration has some negative values), so we take them out again
df = na.omit(df)
attach(df)

#first regression
regression1 = lm(gdp ~ grossfixedcapital+labourforce)
summary(regression1)

#testing normality of residuals
library(olsrr)
ols_plot_resid_fit(regression1)
ols_plot_resid_qq(regression1)
ols_test_normality(regression1)

#generate added variable plots
library(car)
avPlots(regression1)

#second regression
regression2 = lm(gdp ~ fertilityrate+netmigration+unemployment+primaryeducation+mortalityratefemale+mortalityratemale+secondaryeducation)
summary(regression2)

#testing for potential outliers and testing normality of residuals
boxplot(df["gdp"], xlab="gdp")
plot(regression2)
hist(residuals(regression2) main="Residuals histogram", xlab="residuals")
ols_test_normality(regression2)

#generate added variable plots
avPlots(regression2)

#model selection, step methods
ols_step_forward_p(regression2)
ols_step_backward(regression2)
ols_step_both_p(regression2)

#model selection, cross selection
ols_step_best_subset(regression2)

#third regression
regression3 = lm(gdp ~ netmigration + secondaryeducation + unemployment + mortalityratemale)
summary(regression3)
detach(df)
