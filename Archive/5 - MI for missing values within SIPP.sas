*Imputation with multivariate normal distribution (MVN) method, given numerous missing values.  This model is not monotonic nor multiple-chained.  
It uses MCMC, which assumes that all variables have a joint multivariate distribution.  I use this because simulation studies 
have shown that assuming a MVN distribution usually leads to reliable estimates, even when the normality assumption is 
violated, given a sufficient sample size (Demirtas et al 2008 / KJ Lee, 2010).  I use 5 imputations, given our relatively
small amount of missing information.  White et al. (2010) has shown that the most reliable number of imputations should equal
the percentage of missing data. I used dozens of auxiiliary variables to improve the likelihood of meeting the MAR assumption
(Allison 2012).  In other words, adding more variables increases my chances of predicting my missing variables with my data.
Moreover, research has shown that including more auxilliaries yields more more accurate estimates and reduced standard errors
(Lynch 2013).  This is often referred to as a highly "inclusive analysis strategy" (Allison 2012);

*diagnostics: timeplot shows a time series plot across imputation iterations. Best case scenario is no apparent trends(?). (Good convergence of mcmc)
	The autocorrelation plot is best when there is no negative or positive autocorrelation;
*Other diagnostics: want a small relative increase in variance due to non-response.  If it is large, more imputations is a good idea.  
	The quotient of these two make up the adjusted degrees of freedom, which you want to be large.
	The fraction of missing information is best when it is small.  If large (over 50%), use more imputations);


/*
proc mi data=sipptemp nimpute=5 out=SIPP.mi_sipptemp seed=54321;
*mcmc timeplot(mean(mainlandchinese)) acfplot (mean(mainlandchinese));
var MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 refperson networth debt assets homeequity CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt CreditCardDebtValue CarDebt wgt;
run;
*/

/*
*same method with logged variables;
proc mi data=sipptemp nimpute=5 out=SIPP.mi_sipptemp seed=54321;
*mcmc timeplot(mean(mainlandchinese)) acfplot (mean(mainlandchinese));
var MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 refperson loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt Female;
run;
*/

*FCS with logged variables;
proc mi data=sipptemp nimpute=5 out=SIPP.mi_sipptemp seed=54321;
class Ethnicity1 Education Race; 
*fcs plots=trace(mean std);
var Age Children Mortgages VehicleValue NumberCarOwned loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue Female Education Race Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 Ethnicity1;
fcs discrim(Education Race Ethnicity1 /classeffects=include);
run;

/*
*No need to do this with SCF, as there was no missing data.;
 proc logistic data=sipptemp descending;
 model OtherLatino = Age Children Mortgages VehicleValue NumberCarOwned loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt Female Education Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 refperson/
 selection=stepwise slentry=0.1 slstay=0.1 ;
 run;*/

/*
proc logistic data=sipptemp descending;
 model OtherLatino = Age Married Children Mortgages Unemployed OwnCar HomeOwner year1996 year2001 year2004 checking1 numbercarowned loggeddebt loggedCheckingValue loggedCarDebt loggedSecuredDebtValue loggedOtherRealEstateValue loggedIRAvalue loggedBusinessValue loggedassets loggedhomeequity loggedSavingsPlanValue loggedStockValue loggedLifeInsuranceValue loggedOtherAssetValue loggedCreditCardDebtValue Education Race refperson;
 run;
*/
