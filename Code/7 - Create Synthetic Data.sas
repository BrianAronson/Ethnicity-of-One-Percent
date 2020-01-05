*Create synthetic dataset;
proc mi data=Merged nimpute=3 out=SCF.Synthetic_Data seed=12345;
class Ethnicity1 WorkStatus SWorkStatus Marital Race Education;
var age	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	Mortgages	NumberCarOwned	ownmotorcycle	ownnoncar	ownrv	parent	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education ethnicity1;
monotone discrim (Ethnicity1 = age	children	evermilitary	female	HomeOwner	HouseHoldSize	year WorkStatus Marital Race Education / classeffects=include);
run;























*To enable diagnostics;
*ods graphics off;

*Renable ODS for later graphs;
*ods graphics on;


/*
*Create Synthetic data with standardiing;
proc mi data=Standardied_Merged nimpute=5 out=SCF.Synthetic_Data seed=54321;
mcmc timeplot(mean(mainlandchinese)) acfplot (mean(mainlandchinese));
var MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt female;
run;1
*/
/*
*Create Synthetic data with FCS and standardiing;
proc mi data=Standardied_Merged nimpute=5 out=SCF.Synthetic_Data seed=54321;
class Ethnicity1 Education Race;
var Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt female Education Race Ethnicity1 ;
monotone logistic(Ethnicity1 = Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt female Education Race /  PCOV=FIXED classeffects=include);
run;
*/


/*
*Create Synthetic data without standardiing - Sadly - This model does not converge;
proc mi data=Merged nimpute=5 out=Merged_Synthetic_Data seed=54321;
mcmc timeplot(mean(mainlandchinese)) acfplot (mean(mainlandchinese));
var MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 networth debt assets homeequity CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt CreditCardDebtValue CarDebt;
run;
*/

/*
*basic stats;
proc means;
var MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack;
where SIPP=0;
run;
*/
