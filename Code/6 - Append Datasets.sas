*Create temporary SIPP dataset, excluding non-scf variables and non-reference persons.;
Data MI_SIPPTemp;
	set Sipp.MI_SIPPTEMP (keep = age	boarder	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Mortgages	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education ethnicity1);
	SIPP=1;
run;

*Merge data;
Data Merged;
	set MI_SIPPTEMP RichSCFTEMP;
	run;

*proc means data=RichScfTemp;
*var age	boarder	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Mortgages	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education EnglishProficiency;
*run;


*Create new variables to standardize and use for imputation;
/* Data SCFTemp;
	set SCFTemp;
	Array Variables (35) Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 refperson loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt female;
	Array ZVariables (35) ZAge ZMarried ZChildren ZMortgages ZStockMutual ZInterestBank ZChecking1 ZIRAor401k ZUnemployed ZVehicleValue ZOwnCar ZNumberCarOwned ZHomeOwner Zyear1996 Zyear2001 Zyear2004 Zrefperson zloggedincome Zloggednetworth Zloggeddebt Zloggedassets Zloggedhomeequity ZloggedCheckingValue ZloggedSavingsPlanValue ZloggedStockValue ZloggedIraValue ZloggedLifeInsuranceValue ZloggedOtherRealEstateValue ZloggedBusinessValue ZloggedOtherAssetValue ZloggedSecuredDebtValue ZloggedHomeDebt ZloggedCreditCardDebtValue ZloggedCarDebt zfemale;
	Do i = 1 to 35;
		ZVariables(i)=Variables(i);
	End;
Run;

Data MI_SIPPTemp;
	set MI_SIPPTemp;
	Array Variables (35) Age Married Children Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed VehicleValue OwnCar NumberCarOwned HomeOwner year1996 year2001 year2004 refperson loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt female;
	Array ZVariables (35) ZAge ZMarried ZChildren ZMortgages ZStockMutual ZInterestBank ZChecking1 ZIRAor401k ZUnemployed ZVehicleValue ZOwnCar ZNumberCarOwned ZHomeOwner Zyear1996 Zyear2001 Zyear2004 Zrefperson Zloggedincome Zloggednetworth Zloggeddebt Zloggedassets Zloggedhomeequity ZloggedCheckingValue ZloggedSavingsPlanValue ZloggedStockValue ZloggedIraValue ZloggedLifeInsuranceValue ZloggedOtherRealEstateValue ZloggedBusinessValue ZloggedOtherAssetValue ZloggedSecuredDebtValue ZloggedHomeDebt ZloggedCreditCardDebtValue ZloggedCarDebt zfemale;
	Do i = 1 to 35;
		ZVariables(i)=Variables(i);
	End;
Run;

*Create Standardized version of SIPP - Do not standardize ethnicity or output will seem non-sensical;
PROC STANDARD DATA=MI_SIPPTEMP MEAN=0 STD=1 OUT=Standardized_MI_SIPPTemp;
  VAR ZAge ZMarried ZChildren ZMortgages ZStockMutual ZInterestBank ZChecking1 ZIRAor401k ZUnemployed ZVehicleValue ZOwnCar ZNumberCarOwned ZHomeOwner Zyear1996 Zyear2001 Zyear2004 Zrefperson Zloggedincome Zloggednetworth Zloggeddebt Zloggedassets Zloggedhomeequity ZloggedCheckingValue ZloggedSavingsPlanValue ZloggedStockValue ZloggedIraValue ZloggedLifeInsuranceValue ZloggedOtherRealEstateValue ZloggedBusinessValue ZloggedOtherAssetValue ZloggedSecuredDebtValue ZloggedHomeDebt ZloggedCreditCardDebtValue ZloggedCarDebt zfemale;
RUN;

*Create Standardized version of SCF;
PROC STANDARD DATA=SCFTemp MEAN=0 STD=1 OUT=Standardized_SCFTemp;
  VAR ZAge ZMarried ZChildren ZMortgages ZStockMutual ZInterestBank ZChecking1 ZIRAor401k ZUnemployed ZVehicleValue ZOwnCar ZNumberCarOwned ZHomeOwner Zyear1996 Zyear2001 Zyear2004 Zrefperson Zloggedincome Zloggednetworth Zloggeddebt Zloggedassets Zloggedhomeequity ZloggedCheckingValue ZloggedSavingsPlanValue ZloggedStockValue ZloggedIraValue ZloggedLifeInsuranceValue ZloggedOtherRealEstateValue ZloggedBusinessValue ZloggedOtherAssetValue ZloggedSecuredDebtValue ZloggedHomeDebt ZloggedCreditCardDebtValue ZloggedCarDebt zfemale;
RUN;

*/


/*
	*Merge Unstandardized data;
Data Merged;
	set MI_SIPPTEMP SCFTEMP;
	run;
*/
