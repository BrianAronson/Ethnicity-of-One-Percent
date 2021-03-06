*Fix missing savings value info for 1996.  Unfortunately, most of this code is unecessary, since only the family heads were asked their savings in 1996;
Data SippTemp;
	set Sipp.combined2;
run;
proc sort data=sipptemp;
	by year ssuid shhadid refperson;
run; 
Data Sipptemp;
	set sipptemp;
	if year=1996 then do;
	thhthrif=0;
	if lag(refperson)= 1 then thhthrif=taltb;
		else thhthrif=taltb+lag(thhthrif);
		thhthrif1 = lag(thhthrif);
	end;
	run;

*Create all variables;
Data SippTemp;
	set SippTemp;

	*Missing to ".";
	Array variables _numeric_;
		do over variables;
		if variables=-1 then variables=.;
		end;
	*recode monthly income to annual income;
	Income=THTOTINC*12;  
	salaryincome=thearn*12;
	*Education variables;
		if eeducate<39 & eeducate~=. then LessThanHS=1;
			else if eeducate~=. then LessThanHS=0;
		if eeducate=39 then HSGraduate=1;
			else if eeducate~=. then HSGraduate=0;
		if eeducate>39 & eeducate<44 then SomeCollege=1;
			else if eeducate~=. then SomeCollege=0;
		if eeducate=44 then Bachelors=1;
			else if eeducate~=. then Bachelors=0;
		if eeducate>44 then AdvancedDegree=1;
			else if eeducate~=. then AdvancedDegree=0;
		if LessThanHS=1 then Education=0;
		if HSGraduate=1 then Education=1;
		if SomeCollege=1 then Education=2;
		if Bachelors=1 then Education=3;
		if AdvancedDegree=1 then Education=4;
	*Race dummies;
		If eorigin=1 & (year=2008 | year=2004) then Latino=1;
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
		If Asian=1 or NativeAmerican=1 then Other=1;
			else if erace~=. then Other=0;
	*Race catagory;
		race=erace;
		if race=3 then race=5;
		if race=4 then race=5;
		if Latino=1 then race=3;
	*Age;
		if tage>24 & tage<40 then Age25to39=1;
			Else if tage~=. then Age25to39=0;
		if tage>39 & tage<55 then Age40to54=1;
			Else if tage~=. then Age40to54=0;
		if tage>54 then Age55P=1;
			Else if tage~=. then Age55P=0;
		age = tage;
	*Married;
		if ems=1 then Married=1;
			else if ems~=. then Married=0;
	*Children;
		Children=rfnkids;
		If Children=0 then NoKids=1;
		If Children>0 then Nokids=0;
		HasKids=1-NoKids;
	*Wealth Variables;
		Networth=thhtnw;
		Debt=thhdebt;
		if Debt<0 then Debt=0;
		Assets=Networth+Debt;
	*Home and Mortgage;
		HomeEquity=thhtheq;
		HomeDebt=thhmortg;
		if thhtheq~=0 then HomeOwner=1;
			else if thhtheq=. | thhtheq=0 then Homeowner=0;
		if HomeOwner=1 & enummort=. then Mortgages=0;
			else if Homeowner=1 then Mortgages=enummort;
		If Mortgages>4 then Mortgages=4;
		If HomeOwner=0 then Mortgages=0; *Redundant but needed for multiple imputation;
		If HomeDebt~=0 & HomeDebt~=. then HasHomeDebt=1;
			else HasHomeDebt=0;
		HouseValue=thhtheq;
		OtherRealEstateValue=thhore;
		VehicleValue=thhvehcl;
	*Liquid Asset Rates of Ownership; 
		if east3a=1 | east3b=1 then StockMutual=1;
			else if east3a=2 & east3b=2 then StockMutual=0;
		if east2a=1 then InterestBank=1;
			else if east2a=2 then InterestBank=0;
		if EALJCH=1 then Checking1=1; else if ealich=1 then Checking1=1; else Checking1=0;
		If east1b=1 | east1c=1 then IRAor401k=1;
			Else if east1b=2 | east1c=2 then IRAor401k=0;
		if ebiznow1=1 then BusinessOwner=1;
			else if ebiznow1=2 | ebiznow1=. then BusinessOwner=0;
		if ealli=1 then LifeInsurance=1;
			else if ealli=2 then LifeInsurance=0;
		If ealjdab=0 then CreditCardDebt=0;
			else CreditCardDebt=1;
		if rhhstk~=0 then OtherAssets=1;
			else OtherAssets=0;
	*Liquid Asset Value;
			StockValue=rhhstk;
			InterestBankValue=thhintbk;
			OtherAssetValue=thhotast;
			IraValue=thhira;
			BusinessValue=thhbeq;
			LifeInsuranceValue=talliv;
			CreditCardDebtValue=ealjdab;
	*Vehicle Ownership and Assets;
			NumberCarOwned=eautonum;
			if NumberCarOwned>5 then NumberCarOwned=5;
			if NumberCarOwned=. then OwnCar=0;
			if NumberCarOwned=. then NumberCarOwned=0;
			if eautonum>0 then OwnCar=1;
			if eautonum=. then OwnCar=0;
			if ea1owed=1 | ea2owed=1 | ea3owed=1 then HasCarDebt=1;
				else HasCarDebt=0;
			CarEquity = tcarval1 + tcarval2 + tcarval3;
			CarDebt = ta1amt + ta2amt + ta3amt;
			CarNetEquity = CarEquity - CarDebt;
*New Variables to be matched;
	*Employment;
*		if rmesr > 5 then Unemployed=1;
*		else if rmesr>0 then Unemployed=0;
		if EPDJBTHN=1 then employed=1; 
		if EPDJBTHN=2 then employed=0; 
		if ERSNOWRK = 4 then retired=1; else retired=0;
		if ERSNOWRK = 6 | EPTRESN=6 then homemaker=1; else homemaker=0;
		if employed=1 & EPTWRK=2 | EPTRESN=7 then fulltime=1; else fulltime=0; 
		if employed=1 & EPTWRK=1 & homemaker=0 & retired=0 then parttime=1; else parttime=0;
		if parttime=0 & fulltime=0 & retired=0 & homemaker=0 then unemployed=1; else unemployed=0;

	*Financial Assets;
		CheckingValue=taljcha;
		SavingsPlanValue=thhthrif;
		SecuredDebtValue=thhscdbt;

	*Inflate variables by year;
		Array Inflation (22) Income Networth Debt Assets HomeEquity HomeDebt HouseValue OtherRealEstateValue VehicleValue StockValue InterestBankValue OtherAssetValue IraValue BusinessValue LifeInsuranceValue CreditCardDebtValue CarEquity CarDebt CarNetEquity CheckingValue SavingsPlanValue SecuredDebtValue;
		Do i = 1 to 22;
			IF year=1996 then Inflation(i)=Inflation(i)*233.916/154.4;
			IF year=2001 then Inflation(i)=Inflation(i)*233.916/175.1;
			IF year=2004 then Inflation(i)=Inflation(i)*233.916/185.2;
			IF year=2008 then Inflation(i)=Inflation(i)*233.916/214.429;
		END;
*Networth, Assets and Debts Greater than 0.;
		if Networth>0 then AnyNetworth=1;
			else if Networth=<0 & Networth~=. then AnyNetworth=0;	
		if Debt>0 then AnyDebt=1;
			else if Debt=<0 & Debt~=. then AnyDebt=0;	
		if Assets>0 then AnyAssets=1;
			else if Assets=<0 & Assets~=. then AnyAssets=0;	
*Total Financial Assets;
		FinancialAssets=StockValue+InterestBankValue+IraValue+LifeInsuranceValue;
		FinancialAssets1=Assets-HouseValue-OtherRealEstateValue-VehicleValue;
		if FinancialAssets>0 then AnyFinancialAssets=1;
			else if FinancialAssets~=. then AnyFinancialAssets=0;
*US Tenure;
	*1996;
	if year=1996 then do;
		if rmoveus=9999 then rmoveus=.;
		if rmoveus<5 & rmoveus~=. then ustenure25P=1; 
			else if rmoveus~=. | tbrstate<100 then ustenure25P=0; *or statement keeps natives from being ommitted from the regression tables;
		if rmoveus>4 & rmoveus<7 then ustenure11to25=1;
			else if rmoveus~=. | tbrstate<100 then ustenure11to25=0;
		if rmoveus>6 then ustenure0to10=1;
			else if rmoveus~=. | tbrstate<100 then ustenure0to10=0;
	end;
	*2001 and 2004;	
	if year=2001 | year=2004 then do;
	if tmoveus=9999 then tmoveus=.;
		if tmoveus=<7 & tmoveus~=. then ustenure25P=1;
			else if tmoveus~=. | tbrstate<100 then ustenure25P=0;
		if tmoveus>7 & tmoveus<14 then ustenure11to25=1; 
			else if tmoveus~=. | tbrstate<100 then ustenure11to25=0;
		if tmoveus=>14 then ustenure0to10=1;
			else if tmoveus~=. | tbrstate<100 then ustenure0to10=0;
	end;
	if ustenure25P=1 then Tenure='ustenure25P';
			else if ustenure11to25=1 then Tenure='ustenure11to25';
			else If ustenure0to10=1 then Tenure='ustenure0to10';
			else Tenure='ustenure0';
	if tbrstate>100 then immigrant=1;
		else if Tenure='ustenure0' then immigrant =0;
	*Remove 2008;
	if year=2008 then delete;
*match country label in older sipp;
		if  year=1996 then tbrstate=ebrstate;
		if  year=1996 then tprstate=eprstate;
*Family head;
		if efkind=3 then Female=1;
		else if efkind<3 & efkind~=. then Female=0;
		if efkind<2 then MaleHead=1;
		else if efkind~=2 & efkind~=. then MaleHead=0;
		if efkind=1 then JointHead=1;
		else if efkind<1 & efkind~=. then JointHead=0;

*Region;
	if tfipsst=9 | tfipsst=23 | tfipsst=25 | tfipsst=33 | tfipsst=34 | tfipsst=36 | tfipsst=42 | tfipsst=44 | tfipsst=50 then Northeast=1;
		else Northeast=0;
	if tfipsst=17 | tfipsst=18 | tfipsst=19 | tfipsst=20 | tfipsst=26 | tfipsst=27 | tfipsst=29 | tfipsst=31 | tfipsst=38 | tfipsst=39 | tfipsst=46 | tfipsst=55 then Midwest=1;
		else Midwest=0;
	if tfipsst=1 | tfipsst=5 | tfipsst=10 | tfipsst=11 | tfipsst=12 | tfipsst=13 | tfipsst=21 | tfipsst=22 | tfipsst=24 | tfipsst=28 | tfipsst=37 | tfipsst=40 | tfipsst=45 | tfipsst=47 | tfipsst=48 | tfipsst=51 | tfipsst=54 then South=1;
		else South=0; 
	if tfipsst=2 | tfipsst=4 | tfipsst=6 | tfipsst=8 | tfipsst=15 | tfipsst=16 | tfipsst=30 | tfipsst=32 | tfipsst=35 | tfipsst=41 | tfipsst=49 | tfipsst=53 | tfipsst=56 then West=1;
		else West=0;
	if Northeast=0 & Midwest=0 & South=0 & West=0 then OtherRegion=1;
		else OtherRegion=0;
	If Northeast=1 then Region='Northeast';
	if Midwest=1 then Region='Midwest';
	If South=1 then Region='South';
	if West=1 then Region='West';
	If OtherRegion=1 then Region='OtherRegion';
	State=tfipsst;
	if TMETRO=1 then City=1; else if TMETRO=2 then City=0; else if TMETRO=3 then city=.;
*Year Dummies;
	if year=1996 then year1996=1;
		else year1996=0;
	if year=2001 then year2001=1;
		else year2001=0;
	if year=2004 then year2004=1;
		else year2004=0;

*Networth Brackets;
Array NWBrackets (9) NW21to40 NW41to60 NW61to80 NW81to100 NW101to120 NW121to140 NW141to160 NW161to180 NW181to200;
	Do i = 1 to 9;
		IF networth>(i*20) & networth=<((i+1)*20) then NWBrackets(i)=1;
			else if networth~=. then NWBrackets(i)=0;
		END;
	if networth<0 & networth~=. then NWLessThan0=1;
		else if networth>=0 then NWLessThan0=0;
	if networth=>0 & networth=<20 then NW0to20=1;
		else if networth~=. then NW0to20=0;
	if networth>200 then NWGreaterThan200=1;
		else if networth~=. then NWGreaterThan200=0;
*Debt Brackets;
Array DebtBrackets (9) Debt21to40 Debt41to60 Debt61to80 Debt81to100 Debt101to120 Debt121to140 Debt141to160 Debt161to180 Debt181to200;
	Do i = 1 to 9;
		IF debt>(i*20) & debt=<((i+1)*20) then debtBrackets(i)=1;
			else if debt~=. then debtBrackets(i)=0;
		END;
	if debt<0 then DebtLessThan0=1;
		else if debt>=0 then DebtLessThan0=0;
	if debt=>0 & debt=<20 then Debt0to20=1;
		else if debt~=. then Debt0to20=0;
	if Debt>200 then DebtGreaterThan200=1;
		else if debt~=. then DebtGreaterThan100=0;
*Car Equity Brackets;
Array CarNetEquityBrackets (13) CarNetEquity6to10 CarNetEquity11to15 CarNetEquity16to20 CarNetEquity21to25 CarNetEquity26to30 CarNetEquity31to35 CarNetEquity36to40 CarNetEquity41to45 CarNetEquity46to50 CarNetEquity51to55 CarNetEquity56to60 CarNetEquity61to65 CarNetEquity66to70;
	Do i = 1 to 13;
		IF CarNetEquity>(i*5000) & CarNetEquity=<((i+1)*5000) then CarNetEquityBrackets(i)=1;
			else if CarNetEquity~=. then CarNetEquityBrackets(i)=0;
		END;
	if CarNetEquity>0 & CarNetEquity=<5000 & OwnCar=1 then CarNetEquity0to5=1;
		else if CarNetEquity~=. then CarNetEquity0to5=0;
	if CarNetEquity>70000 then CarNetEquityGreaterThan70=1;
		else if CarNetEquity~=. then CarNetEquityGreaterThan70=0;
	if CarNetEquity=<0 & CarNetEquity>-5000. then CarNetEquity5to0=1;
		else if CarNetEquity~=. then CarNetEquity5to0=0;
	if CarNetEquity=<-5000 & CarNetEquity>-10000 then CarNetEquity10to5=1;
		else if CarNetEquity~=. then CarNetEquity10to5=0;
	if CarNetEquity=<-10000 & CarNetEquity>-15000 then CarNetEquity15to10=1;
		else if CarNetEquity~=. then CarNetEquity15to10=0;
	if CarNetEquity=<-15000 & CarNetEquity>-20000 then CarNetEquity20to15=1;
		else if CarNetEquity~=. then CarNetEquity20to15=0;
	if CarNetEquity=<-20000 & CarNetEquity>-25000 then CarNetEquity25to20=1;
		else if CarNetEquity~=. then CarNetEquity25to20=0;
	if CarNetEquity=<-25000 & CarNetEquity~=. then CarNetEquitylessthan25=1;
		else if CarNetEquity~=. then CarNetEquitylessthan25=0;
	wgt = wpfinwgt;
	if refperson=. then refperson=0;

*Logged Variables;
	Array SkewedVariable (20) income salaryincome networth debt assets homeequity CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt CreditCardDebtValue CarDebt salaryincome VehicleValue;
	Array LoggedVariable (20) loggedincome loggedsalaryincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt loggedsalaryincome loggedVehicleValue;
	Do i = 1 to 20;
		if SkewedVariable(i)>0 then LoggedVariable(i)=log10(SkewedVariable(i));  *This without if statement would produce an error and missing number for those with negative and 0 networth.;
*		if SkewedVariable(i)<0 then LoggedVariable(i)=-log10(ABS(SkewedVariable(i))); *This gives me negative logged networth;
		if SkewedVariable(i)=<0 then LoggedVariable(i)=0; *This is not actually true, but log of 1=0, and 0 is pretty close to 1...;
	END;
*Female=esex-1;
	*Langauge proficiency;
	if year=2004 then EnglishProficiency=ehowwell;
	if year=2001 then EnglishProficiency=elngabil;
	if year~=1996 & EnglishProficiency=. then EnglishProficiency=1; *Assumption is that people who speak english at home speak english perfectly;
*	if EnglishProficiency=2 then EnglishProficiency=1;
	if EnglishProficiency>2 then EnglishProficiency=2;
run;

*Create family member variable;
Data SippTempMini;
set Sipptemp (keep=ssuid errp year shhadid TPTOTINC redaid05 EPTRESN retired homemaker unemployed parttime fulltime);
if errp=3 then spouse=1;
if errp=4 then child=1;
if errp=5 then grandchild=1;
if errp=6 then parent=1;
if errp=7 then sibling=1;
if errp=8 then otherrelative=1;
if errp=9 then fosterchild=1;
if errp=10 then partner=1;
if errp=11 then housemate=1;
if errp=12 then boarder=1;
if errp=13 then other=1;

if errp=3 then incspouse=TPTOTINC*12;
if errp=4 then incchild=TPTOTINC*12;
if errp=5 then incgrandchild=TPTOTINC*12;
if errp=6 then incparent=TPTOTINC*12;
if errp=7 then incsibling=TPTOTINC*12;
if errp=8 then incotherrelative=TPTOTINC*12;
if errp=9 then incfosterchild=TPTOTINC*12;
if errp=10 then incpartner=TPTOTINC*12;
if errp=11 then inchousemate=TPTOTINC*12;
if errp=12 then incboarder=TPTOTINC*12;
if errp=13 then incother=TPTOTINC*12;

if errp=3 then SWorkStatus=EPTRESN;
if errp=3 then Sretired=retired;
if errp=3 then Shomemaker=homemaker;
if errp=3 then Sunemployed=unemployed;
if errp=3 then Sparttime=parttime;
if errp=3 then Sfulltime=fulltime;

studentloan=redaid05;


*set missing to 0;
 array change _numeric_;
   do over change;
   if change=. then change=0;
   end;
run;
*sum family member variables;
PROC MEANS DATA=SIPPTEMPMINI NWAY NOPRINT ;
  CLASS year ssuid shhadid;
  VAR spouse child grandchild parent sibling otherrelative fosterchild partner housemate boarder other   incspouse incchild incgrandchild incparent incsibling incotherrelative incfosterchild incpartner inchousemate incboarder incother studentloan SWorkStatus Sretired Shomemaker Sunemployed Sparttime Sfulltime;
  OUTPUT OUT=Sipptempmini2 SUM=spouse child grandchild parent sibling otherrelative fosterchild partner housemate boarder other   incspouse incchild incgrandchild incparent incsibling incotherrelative incfosterchild incpartner inchousemate incboarder incother SWorkStatus studentloan Sretired Shomemaker Sunemployed Sparttime Sfulltime;
RUN;
*prep for merging;
proc sort data=Sipptempmini2;
by year ssuid shhadid;
run;

*Merge family member variables into dataset and remove individual observations;
Data SippTemp;
	set SippTemp;
	if refperson~=1 then delete;
run;
Data SippTemp;
	set SippTemp;
	merge SippTemp Sipptempmini2;
	by year ssuid shhadid;
run;

*Add new family oriented variables;
Data SippTemp;
	set SippTemp;
	if ems=1 | ems=2 then Married=1;
			else if ems~=. then Married=0;
	if ems=3 then Widowed=1;
			else if ems~=. then Widowed=0;
	if ems=4 then Divorced=1;
			else if ems~=. then Divorced=0;
	if ems=5 then Separated=1;
			else if ems~=. then Separated=0;
	if ems=6 then NeverMarried=1;
			else if ems~=. then NeverMarried=0;
	if ((married=1) & (spouse=0 & partner=0)) then DistantSpouse = 1; else DistantSpouse = 0;
*Categorical version;
	Marital=ems;
	if DistantSpouse=1 then Marital=2;
	HouseHoldSize= 1 + spouse + child + grandchild + parent + sibling + otherrelative + fosterchild + partner + housemate + boarder + other;
	incref=income-(incspouse +incchild +incgrandchild +incparent +incsibling +incotherrelative +incfosterchild +incpartner+ inchousemate+incboarder+incother);
*dummy family income variables;
	if incref > 0 then anyincref=1; else anyincref=0;
	if incspouse  > 0 then anyincspouse =1; else anyincspouse =0;
	if incchild > 0 then anyincchild =1; else anyincchild =0;
	if incgrandchild > 0 then anyincgrandchild =1; else anyincgrandchild =0;
	if incparent > 0 then anyincparent =1; else anyincparent =0;
	if incsibling > 0 then anyincsibling =1; else anyincsibling =0;
	if incotherrelative > 0 then anyincotherrelative =1; else anyincotherrelative =0;
	if incfosterchild > 0 then anyincfosterchild =1; else anyincfosterchild =0;
	if incpartner > 0 then anyincpartner =1; else anyincpartner =0;
	if inchousemate > 0 then anyinchousemate =1; else anyinchousemate =0;
	if incboarder > 0 then anyincboarder =1; else anyincboarder =0;
	if incother> 0 then anyincother=1; else anyincother=0;
	yearsatjob=TNUMLEN;
	if yearsatjob=. then yearsatjob=0;
*Logged income variables;
	Array SkewedVariable (13) incref incspouse incchild incgrandchild incparent incsibling incotherrelative incfosterchild incpartner inchousemate incboarder incother yearsatjob;
	Array LoggedVariable (13) loggedincref loggedincspouse loggedincchild loggedincgrandchild loggedincparent loggedincsibling loggedincotherrelative loggedincfosterchild loggedincpartner loggedinchousemate loggedincboarder loggedincother loggedyearsatjob;
	Do i = 1 to 13;
		if SkewedVariable(i)>0 then LoggedVariable(i)=log10(SkewedVariable(i));  *This without if statement would produce an error and missing number for those with negative and 0 networth.;
		if SkewedVariable(i)<0 then LoggedVariable(i)=-log10(ABS(SkewedVariable(i))); *This gives me negative logged networth;
		if SkewedVariable(i)=0 then LoggedVariable(i)=0; *This is not actually true, but log of 1=0, and 0 is pretty close to 1...;
	END;
*other variables;
	jointsavings= 2-esvjt;
	if jointsavings=. then jointsavings=0;
	if ejrnt2=1 | ejntrnt=1 then RentsProperty=1; else RentsProperty=0;
	if eovboat=1 then ownboat=1; else ownboat=0;
	if eovmtrcy =1 then ownmotorcycle=1; else ownmotorcycle=0;
	if eovrv =1 then ownrv=1; else ownrv=0;
	if eovothrv=1 then ownothervehicle=1; else ownothervehicle=0;
	if EOTHVEH=1 then ownnoncar=1; else ownnoncar=0;	
	if RANYAGRE=1 then supportchild=1; else supportchild=0;
	supportother=2-ESUPOTPY;
	evermilitary=2-eafever;
	outsidekids=EPVCHILD;
	yearmarried=TLMYEAR;
	health=ehltstat;
	if Sunemployed=2 then Sunemployed=1;
	if sparttime=2 then sparttime=1;
	*normalize variables;
	if boarder>1 then boarder=1;
	if children>6 then children=6;
	if grandchild>1 then grandchild=1;
	if householdsize>8 then householdsize=8;
	if otherrelative>1 then otherrelative=1;
	*Workstatus variables;
	if sfulltime>1 then sfulltime=1;
	if Fulltime=1 then WorkStatus=1;
	if Homemaker=1 then WorkStatus=2;
	if Parttime=1 then WorkStatus=3;
	if Retired=1 then WorkStatus=4;
	if Unemployed=1 then WorkStatus=5;
	if SFulltime=1 then SWorkStatus=1;
	if SHomemaker=1 then SWorkStatus=2;
	if SParttime=1 then SWorkStatus=3;
	if SRetired=1 then SWorkStatus=4;
	if Sunemployed=1 then SWorkStatus=5;
	if SWorkStatus=. then SWorkStatus=0;
	
run;	

*Sort;
	proc sort;
	by year region;
	run;



/*Figuring out which variables have a non-normal distribution;
	proc univariate plot data=scftemp; var loggedyearsatjob; run;
*Variables with non-normal distributions (skewness>2) based on George and Mallery 2010: networth debt assets homeequity CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt CreditCardDebtValue CarDebt 
*/

