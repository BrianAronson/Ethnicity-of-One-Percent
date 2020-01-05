PROC DATASETS lib=work kill nolist memtype=data;
quit;

*Define SCF Library;
libname Scf 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SCF Data Files';	
libname SIPP 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SIPP Data Files';	

*Combine data and create year variables- 
In SCF: indsname creates temporary variable of the name of each dataset, the following line creates a year variable based off the temporary name variable and the first occurence ofa number
In SIPP: Also creates a variable to identify the reference person;

*%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\Prep Data.sas';

*Sort SIPP by year and race for Proc "by" statements;
*Proc Sort Data=Sipp.Combined2;
*	by year erace;
*run;

*SIPP: Generate new temporary variables for analyses, convert missing to ".";
Data SippTemp;
	set Sipp.combined2;
	*Missing to ".";
	Array variables _numeric_;
		do over variables;
		if variables=-1 then variables=.;
		end;
	*Education;
		if eeducate<39 then EducBelowHS=1;
		else if eeducate~=. then EducBelowHS=0;
		Education=eeducate-30;
		if Education=9 then Education=8;
		if Education=10 then Education=9;
		if Education=11 then Education=10;
		if Education=13 then Education=10;
		if Education=14 then Education=11;
		if Education=15 then Education=12;
		if Education=16 then Education=12;
		if Education=17 then Education=12;

	*Race;
		If eorigin=1 & (year=2008 | year=2004) then Latino=1;
		Else if eorigin=0 & (year=2008 | year=2004) then Latino=0;
		Else if eorigin>19 & eorigin<30 then Latino=1;
		Else Latino=0;
		if erace=1 & Latino~=1 then White=1;
		else if erace~=. then White=0;
		if erace=2 & Latino~=1 then Black=1;
		else if erace~=. then Black=0;
		if erace=3 & Latino~=1 then NativeAmerican=1;
		else if erace~=. then NativeAmerican=0;
		if erace=4 & Latino~=1 then Asian=1;
		else if erace~=. then Asian=0;
		race1=erace;
		if erace=4 then race1=3;
		if Latino=1 then race1=3;
	*Age;
		if tage>24 & tage<65 then Age25to64=1;
		Else if tage~=. then Age25to64=0;
	*Married;
		if ems=1 then Married=1;
		else if ems~=. then Married=0;
	*Children;
		if rfnkids<5 then Children=rfnkids;
		else if rfnkids~=. then Children=5;
	*Wealth Variables;
		Networth=thhtnw;
		Debt=thhdebt;
		Assets=Networth+Debt;
	*Home and Mortgage;
		HomeEquity=thhtheq;
		HomeDebt=thhmortg;
		if thhtheq~=0 then HomeOwner=1;
		else if thhtheq=. | thhtheq=0 then Homeowner=0;
		if HomeOwner=1 & enummort=. then Mortgages=0;
		else if Homeowner=1 then Mortgages=enummort;
	*Liquid Asset Rates of Ownership; 
		if east3a=1 | east3b=1 then StockMutual=1;
		else if east3a=2 & east3b=2 then StockMutual=0;
		if east2a=1 then InterestBank=1;
		else if east2a=2 then InterestBank=0;
		if ealich=1 then Checking=1;
		else if ealich=2 then Checking=0;
		If east1b=1 | east1c=1 then IRAor401k=1;
		Else if east1b=2 | east1c=2 then IRAor401k=0;
	*Inflate variables by year;
		Array Inflation (6) Income Networth Debt Assets HomeEquity HomeDebt;
		Do i = 1 to 6;
			IF year=1996 then Inflation(i)=Inflation(i)*233.916/154.4;
			IF year=2001 then Inflation(i)=Inflation(i)*233.916/175.1;
			IF year=2004 then Inflation(i)=Inflation(i)*233.916/185.2;
			IF year=2008 then Inflation(i)=Inflation(i)*233.916/214.429;
		END;
run;

Data SCFTemp;
	Set SCF.Combined;
	*Education;
		if educ<12 then EducBelowHS=1;
		else EducBelowHS=0;
		if educ=-1 then Education=1;
		else if educ>0 & educ<5 then Education=2;
		else if educ>4 & educ<7 then Education=3;
		else if educ>6 & educ<9 then Education=4;
		else if educ=9 then Education=5;
		else if educ=10 then Education=6;
		else if educ=11 then Education=7;
		else if educ=12 then Education=8;
		else if educ=13 then Education=9;
		else if educ=14 then Education=10;
		else if educ=15 then Education=10;
		else if educ=16 then Education=11;
		else if educ=17 then Education=12;
		*Race;
		if race=1 then White=1;
		else White=0;
		if race=2 then Black=1;
		else Black=0;
		if race=3 then Hispanic=1;
		else Hispanic=0;
		if race=5 then Other=1;
		else Other=0;
		race1=race;
		if race=5 then race1=3;
	*Age;
		if age>24 & age<65 then Age25to64=1;
		Else Age25to64=0;
	*Married;
		if Married=2 then Married=0;
	*Children;
		if kids<5 then Children=kids;
		else Children=5;
	*Wealth Variables;
		Assets=Networth+Debt;
	*Home and Mortgage;
		HomeEquity=homeeq;
		HomeDebt=NH_MORT;
		if homeeq~=0 then HomeOwner=1;
		else if homeeq=. | homeeq=0 then Homeowner=0;
		if housecl~=2 then HomeOwner1=1;
		else Homeowner1=0;
		if HomeOwner=1 & PAYMORT1=0 then Mortgages=0;
		else if Homeowner=1 & PAYMORT1>0 & PAYMORT2>0 & PAYMORT3>0 then Mortgages=3 ;
		else if Homeowner=1 & PAYMORT1>0 & PAYMORT2>0 & PAYMORT3=0 then Mortgages=2 ;
		else if Homeowner=1 & PAYMORT1>0 & PAYMORT2=0 & PAYMORT3=0 then Mortgages=1 ;
	*Liquid Asset Rates of Ownership; 
		if hstocks=1 | deq>0 then StockMutual=1;
		else StockMutual=0;
		if mma>0 then InterestBank=1;
		else InterestBank=0;
		if nochk=0 then Checking=1;
		else Checking=0;
		If irakh>0 then IRAor401k=1;
		Else  IRAor401k=0;
run;


*merge criteria: networth income education race;
Data SIPPTEMP;
set SIPPTEMP;
Array variables (21) married income checking debt networth year educbelowhs education white black race1 age25to64 children assets homeequity homedebt homeowner mortgages stockmutual interestbank iraor401k;
Array variables1 (21) married1 income1 checking1 debt1 networth1 year1 educbelowhs1 education1 white1 black1 race11 age25to641 children1 assets1 homeequity1 homedebt1 homeowner11 mortgages1 stockmutual1 interestbank1 iraor401k1;
do i= 1 to 21;
		variables1(i)=variables(i);
	end;
	drop married income checking debt networth year educbelowhs education white black race1 age25to64 children assets homeequity homedebt homeowner mortgages stockmutual interestbank iraor401k;
run;

proc sql;
* a.Income as Income1, a.Networth as Networth1, a.Education as Education1,
   a.Race1 as Race1,
   b.Income as Income2, b.Networth as Networth2, b.Education as Education2,
   b.Race1 as Race2;
  
create table _Merged as
  select *
   from work.SIPPTEMP as a, work.SCFTEMP as b

   where a.race11=b.race1 &
		 a.education1=b.education &
		 a.income1=b.income &
		 a.networth1=b.networth;
		
quit;


proc freq data=_merged;
tables networth networth1 income income1 race1 race11 education education1;
run;
