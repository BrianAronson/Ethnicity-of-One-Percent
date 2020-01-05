*FCS with logged variables;
	proc mi data=richsipptemp nimpute=10 out=SIPP.mi_sipptemp seed=54321;
	class Ethnicity1 WorkStatus SWorkStatus Marital Race Education; 
    *fcs discrim plots=trace(mean std); 
	*var Age Children Mortgages VehicleValue NumberCarOwned loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue Female Education Race Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 Ethnicity1;
	var age	boarder	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Mortgages	NumberCarOwned	ownmotorcycle	ownnoncar	ownrv	parent	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education ethnicity1;	
	fcs discrim(WorkStatus SWorkStatus Marital Race Education Ethnicity1/classeffects=include);
	run;
	


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

/*
proc logistic data=sipptemp descending;
 model OtherLatino = Age Married Children Mortgages Unemployed OwnCar HomeOwner year1996 year2001 year2004 checking1 numbercarowned loggeddebt loggedCheckingValue loggedCarDebt loggedSecuredDebtValue loggedOtherRealEstateValue loggedIRAvalue loggedBusinessValue loggedassets loggedhomeequity loggedSavingsPlanValue loggedStockValue loggedLifeInsuranceValue loggedOtherAssetValue loggedCreditCardDebtValue Education Race refperson;
 run;
*/;

