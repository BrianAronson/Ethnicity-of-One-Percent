rm(list=ls())
library(ggplot2)
library(randomForest)
load("/Users/bdaro_000/Sociology/IndependentStudyRA/SIPP and SCF Merge Project/SIPP Data Files/sipptemp.RData")
load("/Users/bdaro_000/Sociology/IndependentStudyRA/SIPP and SCF Merge Project/SCF Data Files/scftemp.RData")

#Random forrest of imputation models
        sipptemp1<-sipptemp[!(is.na(sipptemp$Ethnicity)),]
        head(sipptemp,0)
        sum(is.na(sipptemp1$Children))
        set.seed+(123)
        rf.SIPPTemp1=randomForest(MainlandChinese~age+Married+Children+Mortgages+StockMutual+InterestBank+Checking1+IRAor401k+Unemployed+VehicleValue+OwnCar+NumberCarOwned+HomeOwner+year1996+year2001+year2004+loggedincome+loggednetworth+loggeddebt+loggedassets+loggedhomeequity+loggedCheckingValue+loggedSavingsPlanValue+loggedStockValue+loggedIraValue+loggedLifeInsuranceValue+loggedOtherRealEstateValue+loggedBusinessValue+loggedOtherAssetValue+loggedSecuredDebtValue+loggedHomeDebt+loggedCreditCardDebtValue+Female+Education+race,data=sipptemp1,importance=TRUE, na.action = na.omit)
        varImpPlot(rf.SIPPTemp1)
#SIPP data Prep
        #Remove NA networth
        sipptemp<-sipptemp[!(is.na(sipptemp$Networth)),]
        head(sipptemp,0)
        head(scftemp,0)
        #replace NAs with 0
        sipptemp$SIPPnet50<-ifelse(is.na(sipptemp$SIPPnet50),0,1)
        sipptemp$SIPPnet90<-ifelse(is.na(sipptemp$SIPPnet90),0,1)
        sipptemp$SIPPnet95<-ifelse(is.na(sipptemp$SIPPnet95),0,1)
        sipptemp$SIPPnet99<-ifelse(is.na(sipptemp$SIPPnet99),0,1)
        SIPPnet95<-sipptemp[sipptemp$SIPPnet95==1,]
        #Create Percentile variable
        sipptemp$percentile<-ifelse(sipptemp$SIPPnet99==1,"99",ifelse(sipptemp$SIPPnet95==1,"95",ifelse(sipptemp$SIPPnet90==1,"90",ifelse(sipptemp$SIPPnet50==1,"50",0))))
        table(sipptemp$percentile)
        mean(sipptemp$StockValue)
        sipptemp$year<-as.factor(sipptemp$year)
#SIPP Two way figure: Proportion of Networth in financial assets and median value of financial assets by percentile over time
        
                p <- ggplot(data=SIPPnet95,
                    aes(x=as.factor(year),
                        y=log(StockValue)))
                p + geom_point() 
        