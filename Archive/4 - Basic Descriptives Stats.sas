*New Variables;
Data Sipptemp;
	set sipptemp;
	if age=>25 & age<40 then Age25to39=1; else Age25to39=0;
	if age=>40 & age<50 then Age40to49=1; else Age40to49=0;
	if age=>50 & age<60 then Age50to59=1; else Age50to59=0;
	if age=>60 & age<70 then Age60to69=1; else Age60to69=0;
	if age=>70 then Age70P=1; else Age70P=0;
	Marital=ems;
	if marital=1 then marital=2;
	marital=marital-1;
	if marital=1 then Married=1; else married=0;
	if marital=2 then Widowed=1; else widowed=0;
	if marital=3 then Divorced=1; else divorced=0;
	if marital=4 then separated=1; else separated=0;
	if marital=5 then nevermarried=1; else nevermarried=0;
run;

Data SCFTemp;
	set scftemp;
	if age=>25 & age<40 then Age25to39=1; else Age25to39=0;
	if age=>40 & age<50 then Age40to49=1; else Age40to49=0;
	if age=>50 & age<60 then Age50to59=1; else Age50to59=0;
	if age=>60 & age<70 then Age60to69=1; else Age60to69=0;
	if age=>70 then Age70P=1; else Age70P=0;
run;
*Sipp Demographics;
	Proc Means mean Data=SippTemp;	
	var Age25to39 Age40to49 Age50to59 Age60to69 Age70P LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree femalehead White Black Latino Other married widowed divorced separated nevermarried unemployed; 
	by year;
	Weight wpfinwgt;
	where refperson=1;
	run;
*SCF Demographics;
	Proc Means mean Data=SCFTemp;	
	var Age25to39 Age40to49 Age50to59 Age60to69 Age70P LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree female White Black Latino Other married unemployed;
	by year;
	weight wgt;
	run;

	*Sipp Income and Wealth;
	Proc Means mean median P90 P99 Data=SippTemp;	
	var Income Networth Debt Assets;
	by year;
	Weight wpfinwgt;
	*where tage>34 & tage<55 & white=1;	
run;
*Sipp Homeownership;
	Proc Means mean median P90 P99 Data=SippTemp;	
	var Homeowner Mortgages HomeEquity HomeDebt;
	by year;
	Weight wpfinwgt;
	*where White=1;
	*where tage=24 & tage<65;
run;
*Liquid assets;
	Proc Means mean median P90 P99 Data=SippTemp;	
	var StockMutual InterestBank Checking IRAor401k;
	by year;
	Weight wpfinwgt;
	*where White=1;
	*where tage=24 & tage<65;
run;


*SCF Stats:

	*SCF Demographics;
		Proc Means mean Data=SCFTemp;	
		var EducBelowHS Age25to64 Married Children White Black Hispanic Other ;
		by year;
		Weight wgt;
		run;
	*SCF Income and Wealth;
		Proc Means mean median P90 P99 Data=SCFTemp;	
		var Income Networth Debt Assets;
		by year;
		Weight wgt;
		*where age>34 & age<55 & white=1;	
		run;
	*SCF Homeownership;
		Proc Means mean median P90 P99 Data=SCFTemp;	
		var Homeowner Mortgages HomeEquity HomeDebt;
		by year;
		Weight wgt;
		run;
	*SCF Liquid assets;
		Proc Means mean median P90 P99 Data=SCFTemp;	
		var StockMutual InterestBank Checking IRAor401k;
		by year;
		Weight wgt;
		run;

*Combined Stats;

	*Comparing ages;
		proc means data=SIPPTEMP;
		var tage;
		where refperson=1 & tage>34 & tage<55 & white=1;	
		run;
		proc means data=SCFTEMP;
		var age;
		where age>34 & age<55 & white=1;
		run;


*Newest Stats;
	*Generate SCF income and networth top percentiles;
		proc univariate data=SCFTEMP;
	    var networth;
	    output out=percentiles1 pctlpts=99 95 90 80 50 pctlpre=networth;
	    by year;
	    weight wgt;
		run;
	*Change years to match SIPP;
		DATA Percentiles1;
		set Percentiles1;
		if year=1995 then year=1996;
		if year=2007 then year=2008;
		run;

*SIPP
	*Merge Percentiles with SIPP, create SIPP income categories to count;
	DATA SIPPTEMP;
		merge SIPPTEMP Percentiles1;
		by year;
		if networth>=networth99 then SIPPnet99=1;
		if networth>=networth90 then SIPPnet90=1;
		if networth>=networth80 then SIPPnet80=1;
		if networth>=networth50 then SIPPnet50=1;
	*Separate percentile categories;
		if networth>=networth95 then Percentile="95-100";
		else if networth>=networth80 then Percentile="80-95";
		else if networth>=networth50 then Percentile="50-79";
		else Percentile="0-49";
	run;
	*Frequencies of networth categories;
		proc freq data=sipptemp;
		tables Percentile;
		run;
	*Percentile of Networth in stocks;
	Data Sipptemp;
		set sipptemp;
		PAssetsInFinance=(StockValue) /(Assets*);
		if PAssetsInFinance=. then PAssetsInFinance=0;
		if PAssetsInFinance<0 then PAssetsInFinance=0;
		if PAssetsInFinance>1 then PAssetsInFinance=1;
	run;
	*Check data;
	proc univariate;
		var PAssetsInFinance;
	run;
	*Sort;
		proc sort;
		by year Percentile;
		run;

*1. Two way figure: Proportion of Assets in stocks and median value of stocks by percentile over time.
	Intended takeaway: As financial asset values went up, financial assets played a larger role in determining who was in the 1%.;

*a;		proc means;
		var PAssetsInFinance;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*b;		proc means;
		var StockValue;
		where age>24;
		weight wgt;
		by year Percentile;
		run;



*Newest Stats;
	*Generate SCF income and networth top percentiles;
		proc univariate data=SCFTEMP;
	    var networth;
	    output out=percentiles1 pctlpts=99 95 90 80 50 pctlpre=networth;
	    by year;
	    weight wgt;
		run;

*SCF
	*Merge Percentiles with SIPP, create SIPP income categories to count;
	DATA SCFTEMP;
		merge SCFtemp Percentiles1;
		by year;
		if networth>=networth99 then SCFnet99=1;
		if networth>=networth90 then SCFnet90=1;
		if networth>=networth80 then SCFnet80=1;
		if networth>=networth50 then SCFnet50=1;
	*Separate percentile categories;
		if networth>=networth95 then Percentile="95-100";
		else if networth>=networth80 then Percentile="80-95";
		else if networth>=networth50 then Percentile="50-79";
		else Percentile="0-49";
	run;
	*Frequencies of networth categories;
		proc freq data=scftemp;
		tables Percentile;
		run;
	*Percentile of Networth in stocks;
	Data SCFTEMP;
		set SCFTEMP;
		PAssetsInFinance=(StockValue) /(Assets);
		if PAssetsInFinance=. then PAssetsInFinance=0;
		if PAssetsInFinance<0 then PAssetsInFinance=0;
		if PAssetsInFinance>1 then PAssetsInFinance=1;
	run;
	*Check data;
	proc univariate;
		var PAssetsInFinance;
	run;
	*Sort;
		proc sort;
		by year Percentile;
		run;

*1. Two way figure: Proportion of Assets in stocks and median value of stocks by percentile over time.
	Intended takeaway: As financial asset values went up, financial assets played a larger role in determining who was in the 1%.;

*a;		proc means;
		var PAssetsInFinance;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*b;		proc means;
		var StockValue;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*c;		proc means;
		var mma;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*d;		proc means;
		var IraValue;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*e;		proc means;
		var LifeInsuranceValue;
		where age>24;
		weight wgt;
		by year Percentile;
		run;
*F;		proc means;
		var Networth;
		where age>24;
		weight wgt;
		by year Percentile;
		run;





/*	*Means of Everything;
		proc means data=sipptemp;
		var LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other age Married Children Networth Debt Assets HomeEquity Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue VehicleValue OwnCar NumberCarOwned HomeOwner OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt HouseValue CreditCardDebtValue CarDebt;
		where refperson=1 & age>24;
		weight wgt;
		run;

		proc means data=scftemp;
		var LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree Latino White Black Other age Married Children Networth Debt Assets HomeEquity Mortgages StockMutual InterestBank Checking1 IRAor401k Unemployed CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue VehicleValue OwnCar NumberCarOwned HomeOwner OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt HouseValue CreditCardDebtValue CarDebt;
		where refperson=1 & age>24;
		weight wgt;
		run;

proc means data=sipptemp;
		var Age Children Mortgages VehicleValue NumberCarOwned loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt Female Education Race Married StockMutual InterestBank Checking1 IRAor401k Unemployed OwnCar HomeOwner year1996 year2001 year2004 refperson Ethnicity;
		where refperson=1 & age>24;
		weight wgt;
		run;

proc freq data=SCF.SYNTHETIC_DATA;
		tables ethnicity1;
		run;
/*
