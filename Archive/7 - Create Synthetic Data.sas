*To enable diagnostics;
*ods graphics off;

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
proc mi data=Standardized_Merged nimpute=5 out=SCF.Synthetic_Data seed=54321;
class Ethnicity1 Education Race;
var Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 zloggedincome zloggednetworth zloggeddebt zloggedassets zloggedhomeequity zloggedCheckingValue zloggedSavingsPlanValue zloggedStockValue zloggedIraValue zloggedLifeInsuranceValue zloggedOtherRealEstateValue zloggedBusinessValue zloggedOtherAssetValue zloggedSecuredDebtValue zloggedHomeDebt zloggedCreditCardDebtValue female Education Race Ethnicity1 ;
monotone discrim (Ethnicity1 = Age Married Children Mortgages Unemployed StockMutual InterestBank Checking1 IRAor401k OwnCar HomeOwner year1996 year2001 year2004 checking1 numbercarowned zloggedincome zloggedHomeDebt zloggeddebt zloggedCheckingValue zloggedSecuredDebtValue zloggedOtherRealEstateValue zloggedIRAvalue zloggedBusinessValue zloggedassets zloggedhomeequity zloggedSavingsPlanValue zloggedStockValue zloggedLifeInsuranceValue zloggedOtherAssetValue zloggedCreditCardDebtValue Education Race / classeffects=include);
run;

*Renable ODS for later graphs;
*ods graphics on;





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
