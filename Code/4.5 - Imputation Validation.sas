ODS TAGSETS.EXCELXP
file='C:\Users\bdaro_000\Desktop\output.xls' 
STYLE=minimal
OPTIONS ( Orientation = 'landscape'
FitToPage = 'yes'
Pages_FitWidth = '1'
Pages_FitHeight = '100' );

%macro create(howmany);
   %do i=1 %to &howmany;
	*Randomly select variables to mask.;
		data sippMIvalidation;
			set richsipptemp;
			if Ethnicity=. then delete;
			sorter=ranuni(0);
			if sorter<.9 then Ethnicitytest=Ethnicity1;
		run;
	*Model to validate;
		proc mi data=sippMIvalidation nimpute=5 out=validation NOPRINT;
			class ethnicitytest Race Education WorkStatus SWorkStatus Marital; 
			var age	boarder	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Mortgages	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	RentsProperty	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education EnglishProficiency ethnicitytest;
			fcs discrim(Race Education WorkStatus SWorkStatus Marital ethnicitytest /classeffects=include);
		run;
	*Compare Results;
		proc freq data=validation;
		tables ethnicitytest;
			title 'test';
			where sorter>=.9;
		run;
		proc freq data=validation;
		tables ethnicity1 / out=real1;
			where sorter>=.9;
			title 'real';
		run;
   %end;
%mend create;

%create(25)

ods tagsets.excelxp close;




*Validate MI Model before running through validation test;
	data sippMIvalidation;
		set richsipptemp;
	*Remove missing ethnicity to keep validation consistent;
		if Ethnicity=. then delete;
*		if year=1996 then delete;
	*Randomly select variables to mask. First create new random variable between 0 and 1 to mask by;
		sorter=ranuni(0);
	*create a new ethnicity variable that masks 10% of sample;
		if sorter<.9 then Ethnicitytest=Ethnicity1;
	run;
*Model to validate;
	proc mi data=sippMIvalidation nimpute=5 out=validation seed=54321 NOPRINT;
	class ethnicitytest Race Education WorkStatus SWorkStatus Marital; 
	*fcs plots=trace(mean std);
	*var Age Children Mortgages VehicleValue NumberCarOwned loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue Female Education Race Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 Ethnicity1;
	var age	boarder	children	evermilitary	female	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggeddebt loggedCarDebt	loggedCreditCardDebtValue	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Mortgages	NumberCarOwned	ownmotorcycle	ownnoncar	ownrv	parent	StockMutual	supportchild	year WorkStatus SWorkStatus Marital Race Education EnglishProficiency ethnicitytest;	
	fcs discrim(Race Education WorkStatus SWorkStatus Marital ethnicitytest /classeffects=include);
	run;

/*Create variable to see if imputed correctly;
	data validation;
	set validation;
	if ethnicitytest=ethnicity1 then correct=1; else correct=0;
	run;
*sort by ethnicity;
	proc sort;
	by ethnicity1;
	run;
*Check accuracy by ethnicity;
	proc freq;
	tables ethnicitytest;
	by ethnicity1;
	where sorter>=.9;
	run;
*/*Check % differences between real and test models;
	proc freq data=validation;
	tables ethnicitytest;
		title 'test';
		where sorter>=.9;
	run;
	proc freq data=validation;
	tables ethnicity1 / out=real1;
		where sorter>=.9;
		title 'real';
	run;




/*
	*TEMPORARY - Test Model's ability to predict, region, state, and city;
	*Validate MI Model before running through validation test;
	data sippMIvalidation;
		set richsipptemp;
	*Remove missing region, state, and city to keep validation consistent;
		if region=' ' then delete;
		if state=' ' then delete;
		if city=' ' then delete;
	*Randomly select variables to mask. First create new random variable between 0 and 1 to mask by;
		sorter=ranuni(0);
	*create new region, state, and city variables that masks 10% of sample;
		if sorter<.9 then regiontest=region;
		if sorter<.9 then statetest=state;
		if sorter<.9 then citytest=city;
	run;
*Model to validate;
	proc mi data=sippMIvalidation nimpute=5 out=validation seed=54321;
	class regiontest statetest citytest Race; 
	*fcs plots=trace(mean std);
	*var Age Children Mortgages VehicleValue NumberCarOwned loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue Female Education Race Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 Ethnicity1;
	var age	boarder	children	DistantSpouse	Divorced	evermilitary	female	fulltime	grandchild	homemaker	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	loggedassets	loggedCarDebt	loggedCreditCardDebtValue	loggeddebt	loggedHomeDebt	loggedIraValue	loggedLifeInsuranceValue	loggednetworth	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedsalaryincome	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedVehicleValue	loggedyearsatjob	Married	Mortgages	NeverMarried	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	parttime	RentsProperty	retired	Separated	Sfulltime	Shomemaker	Sparttime	spouse	Sretired	StockMutual	supportchild	Unemployed	year	Race	Education regiontest statetest citytest;
	fcs discrim(Race regiontest statetest citytest /classeffects=include);
	run;

	data validation;
		set validation;
		if regiontest=region then correctregion=1; else correctregion=0;
		if statetest=state then correctstate=1; else correctstate=0;
		if citytest=city then correctcity=1; else correctcity=0;
	run;
*Check % differences between real and test models;
	proc freq data=validation;
	tables regiontest statetest citytest;
		title 'test';
		where sorter>=.9;
	run;
	proc freq data=validation;
	tables region state city / out=real1;
		where sorter>=.9;
		title 'real';
	run;

	proc freq data=validation;
	tables correctregion correctstate correctcity / out=correct;
		where sorter>=.9;
		title 'correct';
	run;

	proc freq;
	tables region state city regiontest statetest citytest;
	run;
