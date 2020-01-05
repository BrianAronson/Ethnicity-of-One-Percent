*Sort by imputation for all later steps;
	proc sort data=SCFSynth;
		by _imputation_ Ethnicity1;
	run;

*1. Estimate counts of Ethnic groups for total sample and 1%;
	*Create mean counts of each ethnic group;
*Table 1 - Frequency;		proc means noprint data=SCFSynth; *Total Sample;
			var MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			by _Imputation_;
			weight wgt;
			output out=mimeans 
				mean=MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian
				stderr=se_MainlandChinese se_HKTaiwan se_AsianIndian se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;
	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects MainlandChinese HKTaiwan NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			stderr se_MainlandChinese se_HKTaiwan se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;
		proc means noprint data=SCFSynth; *1%;
			var MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			by _Imputation_;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian
				stderr=se_MainlandChinese se_HKTaiwan se_AsianIndian se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;
	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects MainlandChinese HKTaiwan NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			stderr se_MainlandChinese se_HKTaiwan se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;


	
*Mean Networth of 1%;
		proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;

*Table 2 - Networth;		proc means noprint data=SCFSynth; *Total Sample;
			var Networth;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=Networth
				stderr=se_Networth;		
			run;

*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_networth=. then se_networth=Networth;
			Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects Networth;
			stderr se_Networth;
			by Ethnicity2;
	   run;




*3. Estimate counts of Ethnic groups BY YEAR for total sample and 1%;
	*Sort data for models;
		proc sort data=SCFSynth;
			by _imputation_ year Ethnicity2;
		run;

*Table 3 - By Year;		proc means noprint data=SCFSynth; *Total Sample;
			var MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			by _Imputation_ year;
			weight wgt;
*			where Percent1=1;
			output out=mimeans 
				mean=MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian
				stderr=se_MainlandChinese se_HKTaiwan se_AsianIndian se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;
	*Sort by year;
		proc sort;
			by year;
		run;

	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects MainlandChinese HKTaiwan NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			stderr se_MainlandChinese se_HKTaiwan se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
			by year;
		run;
		


	
*Sort;
		proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;

*Table 4 - Financial Assets;		proc means noprint data=SCFSynth; *Total Sample;
			var StockMutual InterestBank Nochk IRAor401k OwnLifeInsurance StockValue mma IraValue LifeInsuranceValue;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=StockMutual InterestBank Nochk IRAor401k OwnLifeInsurance StockValue mma IraValue LifeInsuranceValue
				stderr= se_StockMutual se_InterestBank se_Nochk se_IRAor401k se_OwnLifeInsurance se_StockValue se_mma se_IraValue se_LifeInsuranceValue;		
			run;
*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_StockMutual=. then se_StockMutual=StockMutual;
			if se_InterestBank=. then se_InterestBank=InterestBank;
			if se_Nochk=. then se_Nochk=1;
			if se_IRAor401k=. then se_IRAor401k=IRAor401k;
			if se_OwnLifeInsurance=. then se_OwnLifeInsurance=OwnLifeInsurance;
			if se_StockValue=. then se_StockValue=StockValue;
			if se_mma=. then se_mma=mma;
			if se_LifeInsuranceValue=. then se_LifeInsuranceValue=LifeInsuranceValue;
			if se_IraValue =. then se_IraValue =IraValue ;
Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects StockMutual InterestBank IRAor401k OwnLifeInsurance StockValue mma IraValue LifeInsuranceValue;
			stderr se_StockMutual se_InterestBank se_IRAor401k se_OwnLifeInsurance se_StockValue se_mma se_IraValue se_LifeInsuranceValue;
*			where Ethnicity2="Reference Catego";
			by Ethnicity2;
	   run;

*Sort;
		proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;

*Table 5 - Business ownership and Self-employment;		proc means noprint data=SCFSynth; *Total Sample;
			var InvestInBusiness BusinessValue SelfEmployed;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=InvestInBusiness BusinessValue SelfEmployed
				median=mInvestInBusiness mBusinessValue mSelfEmployed
				stderr= se_InvestInBusiness se_BusinessValue se_SelfEmployed;		
			run;
*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_InvestInBusiness=. then se_InvestInBusiness=1;
			if se_BusinessValue=. then se_BusinessValue=BusinessValue;
			if se_SelfEmployed=. then se_SelfEmployed=1;
Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects InvestInBusiness BusinessValue SelfEmployed mInvestInBusiness mBusinessValue mSelfEmployed;
			stderr se_InvestInBusiness se_BusinessValue se_SelfEmployed se_InvestInBusiness se_BusinessValue se_SelfEmployed;
*			where Ethnicity2="Reference Catego";
			by Ethnicity2;
	   run;

*Table 6 - Real Estate;		proc means noprint data=SCFSynth; *Total Sample;
			var HomeOwner HomeEquity HomeDebt Mortgages;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=HomeOwner HomeEquity HomeDebt Mortgages
				median=mHomeOwner mHomeEquity mHomeDebt mMortgages
				stderr= se_HomeOwner se_HomeEquity se_HomeDebt se_Mortgages;		
			run;
*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_HomeOwner=. then se_HomeOwner=1;
			if se_HomeEquity=. then se_HomeEquity=HomeEquity;
			if se_HomeDebt=. then se_HomeDebt=HomeDebt;
			if se_Mortgages=. then se_Mortgages=Mortgages;
Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects HomeOwner HomeEquity HomeDebt Mortgages mHomeOwner mHomeEquity mHomeDebt mMortgages;
			stderr se_HomeOwner se_HomeEquity se_HomeDebt se_Mortgages se_HomeOwner se_HomeEquity se_HomeDebt se_Mortgages;
*			where Ethnicity2="Reference Catego";
			by Ethnicity2;
	   run;




*Sort;
	proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;


*Table 7 - Proportion of 1% for each asset;	proc means noprint data=SCFSynth; *Total Sample;
			var MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			by _Imputation_ ;
			weight wgt;
			where StockValue1=1;
			*StockValue1 mma1 IraValue1 LifeInsuranceValue1;
			output out=mimeans 
				mean=MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian
				stderr=se_MainlandChinese se_HKTaiwan se_AsianIndian se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;

	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects MainlandChinese HKTaiwan NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			stderr se_MainlandChinese se_HKTaiwan se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;


*Sort;
	proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;


*Table 8 - Any Inheritance;		proc means noprint data=SCFSynth; *Total Sample;
			var Anyinherit;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=Anyinherit
				stderr= se_Anyinherit;		
			run;
*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_Anyinherit=. then se_Anyinherit=1;
Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects Anyinherit;
			stderr se_Anyinherit;
*			where Ethnicity2="Reference Catego";
			by Ethnicity2;
	   run;



*Table 10 1% inheritance value - Proportion of 1% for inheritance;	proc means noprint data=SCFSynth; *Total Sample;
			var MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			by _Imputation_ ;
			weight wgt;
			where Totalinheritvalue1=1;
			*StockValue1 mma1 IraValue1 LifeInsuranceValue1;
			output out=mimeans 
				mean=MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian
				stderr=se_MainlandChinese se_HKTaiwan se_AsianIndian se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;

	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects MainlandChinese HKTaiwan NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian;
			stderr se_MainlandChinese se_HKTaiwan se_NativeAsian se_Mexican se_Cuban se_NativeLatino se_OtherImmigrants se_NativeWhite se_NativeBlack se_Vietnam se_Phillipino se_Korean se_European se_Canada se_AsianIndian;
		run;






proc sort data=scftemp;
by year;
run;

DATA SCFtemp;
	merge SCFtemp Networth99;
	by year;
	array financialvs (6) Networth StockValue mma IraValue LifeInsuranceValue Totalinheritvalue;
	array onepercentcutoffs (6) Networth99v StockValuev mmav IraValuev LifeInsuranceValuev Totalinheritvaluev;
	array onepercentdummies (6) Percent1 StockValue1 mma1 IraValue1 LifeInsuranceValue1 Totalinheritvalue1;
	Do i = 1 to 6;
		if financialvs(i)>onepercentcutoffs(i) then onepercentdummies(i)=1; else onepercentdummies(i)=0;
	End;
	SCFImput=substr(Y1,length(Y1),1);
	run;

proc sort data=scftemp;
by race;
run;


proc means data=scftemp;
var ReceivedInheritance;
weight wgt;
by race;
where percent1=1;
run;


proc sort data=richscftemp;
by scfimput race;
run;

*Table 8 - Any Inheritance;		proc means noprint data=richSCFtemp; *Total Sample;
			var ReceivedInheritance;
			by scfimput Race;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=Anyinherit
				stderr= se_Anyinherit;		
			run;
*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_Anyinherit=. then se_Anyinherit=1;
Run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Race;
			run;

* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects Anyinherit;
			stderr se_Anyinherit;
*			where Ethnicity2="Reference Catego";
			by Race;
	   run;


	   


proc means data=richscftemp;
var NETWORTH  StockValue  MMA  IraValue  LifeInsuranceValue  Totalinheritvalue  ;
where percent1=1;
run;







	proc sort data=scftemp;
	by year;
	run;

	Proc Means P99 Data=SCFtemp;
		Var NetWorth;
		by year;
		Weight wgt; 
		output 	out = Networth99 P99=Networth99v;
	run;

DATA SCFtemp;
	merge SCFtemp Networth99;
	by year;
	array financialvs (1) Networth ;
	array onepercentcutoffs (1) Networth99v ;
	array onepercentdummies (1) Percent1 ;
	Do i = 1 to 1;
		if financialvs(i)>onepercentcutoffs(i) then onepercentdummies(i)=1; else onepercentdummies(i)=0;
	End;
	SCFImput=substr(Y1,length(Y1),1);
	run;

proc sort data=scftemp;
by race;
run;

proc means data=scftemp;
var ReceivedInheritance;
weight wgt;
by race;
where percent1=1;
run;











*2. Ethnicity composition of the 1%, 5%, and 10% over time.;
	proc sort data=SCF.SCFSynth;
		by year;
	run;

	proc freq data=SCF.SCFSynth;
		tables Ethnicity1; 
		where Percent1=1;
		Weight wgt;
		by year;
	run;

	proc freq data=SCF.SCFSynth;
		tables Ethnicity1; 
		where Percent5=1;
		Weight wgt;
		by year;
	run;

	proc freq data=SCF.SCFSynth;
		tables Ethnicity1; 
		where Percent10=1;
		Weight wgt;
	run;




*3. Frequency of investments in business of the 1% by ethnicity.;
	*Sort by Ethnicity1;
	proc sort data=SCF.SCFSynth;
		by Ethnicity1;
	run;
	*Create variable to see rate of investment;
	data SCF.SCFSynth;
		set SCF.SCFSynth;
		if BusinessValue>0 & BusinessValue~=. then InvestInBusiness=1; else InvestInBusiness=0;
	run;
	*Invest;
	proc means;
		var InvestInBusiness;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;
	*Value;
	proc means;
		var BusinessValue;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;


*4. Correlation of high-risk investment and 1% status by ethnicity.;
	*create needed variables;
	data SCF.SCFSynth;
		set SCF.SCFSynth;
		if LifeInsuranceValue>0 & LifeInsuranceValue~=. then OwnLifeInsurance=1; else OwnLifeInsurance=0;
		if StockMutual=1 | InterestBank=1 | Checking=1 | IRAor401k=1 | OwnLifeInsurance=1 | AnyFinancialAssets=1 then AnyFinancialAssets=1; else AnyFinancialAssets=0;
	run;
	*ownership;
	proc means;
		var StockMutual InterestBank Nochk IRAor401k OwnLifeInsurance AnyFinancialAssets;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;
	*Values;
	proc means;
		var StockValue mma IraValue LifeInsuranceValue;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;
	*Values for those with any;
	proc means;
		var StockValue;
		by Ethnicity1;
		where Percent1=1 & StockValue>0;
		Weight wgt;
	run;
	proc means;
		var mma;
		by Ethnicity1;
		where Percent1=1 & mma>0;
		Weight wgt;
	run;
	proc means;
		var IraValue ;
		by Ethnicity1;
		where Percent1=1 & IraValue>0;
		Weight wgt;
	run;
	proc means;
		var LifeInsuranceValue;
		by Ethnicity1;
		where Percent1=1 & LifeInsuranceValue>0;
		Weight wgt;
	run;
*Home Ownership;
proc means;
		var Homeowner;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;
	proc means;
		var HomeEquity HomeDebt;
		by Ethnicity1;
		where Percent1=1 & Homeowner=1;
		Weight wgt;
	run;

*Marital, Children, Age; 
	proc means;
		var Married Children Age;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;
*Education;
	proc means;
		var LessThanHS HSGraduate SomeCollege Bachelors AdvancedDegree;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;

*Self Employed, Managerial/Professional Occupation;
	proc means;
		var ManageProf SelfEmployed;
		by Ethnicity1;
		where Percent1=1;
		Weight wgt;
	run;




	proc glm data=SCFSynth;
	Model loggednetworth = MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack Vietnam Phillipino Korean European Canada AsianIndian/solution;
	where age>24;
	weight wgt;
	by _imputation_;
	ods output ParameterEstimates=a_mvn;
	run;

proc mianalyze parms=a_mvn ;
	modeleffects intercept MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite;
run;



/*Useless


Estimate location of 100k+ sample and 1% by race.;
		proc sort data=SCFSynth;
		by _imputation_ Ethnicity2;
	run;
*Table 4;		proc means noprint data=SCFSynth; *Total Sample;
			var city midwest northeast otherregion south west;
			by _Imputation_ Ethnicity2;
			weight wgt;
			output out=mimeans 
				mean=city midwest northeast otherregion south west
				stderr=se_city se_midwest se_northeast se_otherregion se_south se_west;		
			run;
*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;
* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects city midwest northeast otherregion south west;
			stderr se_city se_midwest se_northeast se_otherregion se_south se_west;
			by Ethnicity2;
	   run;
		proc means noprint data=SCFSynth; *1%;
			var city midwest northeast otherregion south west;
			by _Imputation_ Ethnicity2;
			weight wgt;
			where Percent1=1;
			output out=mimeans 
				mean=city midwest northeast otherregion south west
				stderr=se_city se_midwest se_northeast se_otherregion se_south se_west;		
			run;
	*Since I want to run proc mianalyze by ethnicity, need to sort by ethnicity;
			proc sort;
			by Ethnicity2;
			run;
	*Since some ethnicities only have one observation, I need to fill their standard errors;
			data mimeans;
			set mimeans;
			if se_city=. then se_city=city;
			if se_midwest=. then se_midwest=midwest;
			if se_northeast=. then se_northeast=northeast;
			if se_otherregion=. then se_otherregion=otherregion;
			if se_south=. then se_south=south;
			if se_west=. then se_west=west;
			Run;

	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects city midwest northeast otherregion south west;
			stderr se_city se_midwest se_northeast se_otherregion se_south se_west;
			by Ethnicity2;
	   run;





*/
*Create 5 imputation categories;
data SCFTEMP;
	set SCFTEMP;
	SCFImput=substr(Y1,length(Y1),1);
	run;

*Make table for Income by Race; 
	*Sort Data;
		proc sort data=SCFTemp; 
		by SCFImput race; 
		run;
	*Calculate means by replicate;
		proc means noprint; *Total Sample;
			var Income;
			by SCFImput race;
			weight wgt;
			where year=2004;
			output out=mimeans 
				mean=Income
				stderr=se_Income;
		run;
	*Sort means by year;
		proc sort;
			by race;
		run;

	* Use MI analyze to get an estimate of the means/std. error;
		proc mianalyze data=mimeans;
			modeleffects Income;
			stderr se_Income;
			by race;
		run;
