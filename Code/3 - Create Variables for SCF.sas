Data SCFTemp;
	*Set SCF.Combined; *1995-2007;
	Set SCF.Combined2; *1988-2007;
	*Education;
		if educ<12 then EducBelowHS=1;
		else EducBelowHS=0;
		if educ<12 then Education=0;
		else if educ<13 then Education=1;
		else if educ<16 then Education=2;
		else if educ<17 then Education=3;
		else if educ=17 then Education=4;
		if Education=0 then LessThanHS=1;
			else if Education~=0 & Education~=. then LessThanHS=0;
		if Education=1 then HSGraduate=1;
			else if Education~=1 & Education~=. then HSGraduate=0;
		if Education=2 then SomeCollege=1;
			else if Education~=2 & Education~=. then SomeCollege=0;
		if Education=3 then Bachelors=1;
			else if Education~=3 & Education~=. then Bachelors=0;
		if Education=4 then AdvancedDegree=1;
			else if Education~=4 & Education~=. then AdvancedDegree=0;

	*Race;
		if race=1 then White=1;
		else White=0;
		if race=2 then Black=1;
		else Black=0;
		if race=3 then Latino=1;
		else Latino=0;
		if race=5 then Other=1;
		else Other=0;
	*Age;
		if age>24 & age<65 then Age25to64=1;
		Else Age25to64=0;
	*Married;
		if Married=2 then Married=0;
	*Children;
		Children=kids;
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
			else Mortgages=0; *This is redundant.  Models on mortgages should exclude non-home owners.
	*Liquid Asset Rates of Ownership; 
		if hstocks=1 | deq>0 then StockMutual=1;
		else StockMutual=0;
		if mma>0 then InterestBank=1;
		else InterestBank=0;
		if nochk=0 then Checking1=1;
		else Checking1=0;
		If irakh>0 then IRAor401k=1;
		Else  IRAor401k=0;
	*New Variables to be matched;
		Unemployed = 1 - lf;
		CheckingValue = checking;
		SavingsPlanValue = thrift;
		StockValue = deq;
		IraValue = irakh;
		LifeInsuranceValue = cashli;
		VehicleValue = vehic;
		OwnCar = own;
		NumberCarOwned = nown;
		if NumberCarOwned>5 then NumberCarOwned=5;
		HomeOwner = hhouses;
		OtherRealEstateValue = nnresre;
		BusinessValue = bus;
		OtherAssetValue = othnfin;
		SecuredDebtValue = mrthel;
		HomeDebt = NH_MORT;
		HouseValue = homeeq;
		CreditCardDebtValue = ccbal;
		CarDebt = VEH_INST;
		refperson = 1;
*Year Dummies;
	if year=1995 then year1996=1;
		else year1996=0;
	if year=2001 then year2001=1;
		else year2001=0;
	if year=2004 then year2004=1;
		else year2004=0;
*	if year=2007 then delete;
*logged variables;
	Array SkewedVariable (17) income networth debt assets homeequity CheckingValue SavingsPlanValue StockValue IraValue LifeInsuranceValue OtherRealEstateValue BusinessValue OtherAssetValue SecuredDebtValue HomeDebt CreditCardDebtValue CarDebt;
	Array LoggedVariable (17) loggedincome loggednetworth loggeddebt loggedassets loggedhomeequity loggedCheckingValue loggedSavingsPlanValue loggedStockValue loggedIraValue loggedLifeInsuranceValue loggedOtherRealEstateValue loggedBusinessValue loggedOtherAssetValue loggedSecuredDebtValue loggedHomeDebt loggedCreditCardDebtValue loggedCarDebt;
	Do i = 1 to 17;
		if SkewedVariable(i)>0 then LoggedVariable(i)=log10(SkewedVariable(i));  *This without if statement would produce an error and missing number for those with negative and 0 networth.;
*		if SkewedVariable(i)<0 then LoggedVariable(i)=-log10(ABS(SkewedVariable(i))); *This gives me negative logged networth;
		if SkewedVariable(i)<=0 then LoggedVariable(i)=0; *This is not actually true, but log of 1=0, and 0 is pretty close to 1...;
	END;
SIPP=0;
Female=hhsex-1;
salaryincome=wageinc;
yeartemp=year*1;
			drop year;
			rename yeartemp=year;
		if year<1992 then Y1temp= X1*1; else Y1temp=Y1*1;
		if year<1992 then YY1temp= XX1*1; else YY1temp=YY1*1;
		drop Y1;
		drop YY1;
		rename Y1temp=Y1 ;
		rename YY1temp=YY1; 
run;

*New Variables;
data Data SCFTempFull;
	set Scffull.Combined4;
	*family members;
		Array family (5) boarder spouse parent otherrelative grandchild;
		Array code (5) _temporary_ (34 2 6 29 5);
		Do i = 1 to 5;
			if X8020=code(i) then family(i)=1; else family(i)=0; if X102=code(i) then family(i)=family(i)+1; if X108=code(i) then family(i)=family(i)+1; if X114=code(i) then family(i)=family(i)+1; if X120=code(i) then family(i)=family(i)+1; if X126=code(i) then family(i)=family(i)+1; if X132=code(i) then family(i)=family(i)+1; if X202=code(i) then family(i)=family(i)+1; if X208=code(i) then family(i)=family(i)+1; if X214=code(i) then family(i)=family(i)+1; if X220=code(i) then family(i)=family(i)+1; if X226=code(i) then family(i)=family(i)+1;
		End;
	*Marital Status;
	*	if X7021=5 then DistantSpouse=1; *else DistantSpouse=0;
		if X8023=3 then Separated=1; else Separated=0;
		if X8023=4 then Divorced=1; else Divorced=0;
		if X8023=6 then NeverMarried=1; else NeverMarried=0;
	*Vehicles;
		if X2505=1 then ownrv=1; else ownrv=0;
		if X2505=11 then ownmotorcycle=1; else ownmotorcycle=0;
		if X2505=3 then ownboat=1; else ownboat=0;
		if X2505~=0 & X2505~=1 & X2505~=11 & X2505~=3 then ownnoncar=1; else ownnoncar=0;
		ownnoncar=ownnoncar+ownboat;
	*Other;
		if X5906=1 then evermilitary=1; else evermilitary=0;
		householdsize=X101;
		if X3731=1 | X3737=1 | X3743=1 | X3749=1 | X3755=1 | X3761=1 then jointsavings=1; else jointsavings=0;
		if X1223=1 | X504=1 then RentsProperty=1; else RentsProperty=0;
		if X7801=1 then studentloan=1; else studentloan=0;
		yearsatjob=X4115;
		if X4115=-1 then yearsatjob=0;
		if X5733=1 then supportother=1; else supportother=0;
		if X5731=1 then supportchild=1; else supportchild=0;
		incomefamily=X6403;
		TRWorkStatus=X6670;
			if TRWorkStatus=1 then Employed=1; else Employed=0;
			if TRWorkStatus=5 then Homemaker=1; else Homemaker=0;
			if TRWorkStatus=7 then Retired=1; else Retired=0;
			if Employed=0 & Homemaker=0 & Retired=0 then Unemployed=1; else Unemployed=0;
			RHoursPerWeek=X4110;
			if Employed=1 & RHoursPerWeek=>35 then fulltime=1; else fulltime=0; 
			if Employed=1 & RHoursPerWeek=<35 then parttime=1; else parttime=0;
		TSWorkStatus=X6678;
			if TSWorkStatus=1 then SEmployed=1; else SEmployed=0;
			if TSWorkStatus=5 then SHomemaker=1; else SHomemaker=0;
			if TSWorkStatus=7 then SRetired=1; else SRetired=0;
			if TSWorkStatus=3 then SUnemployed=1; else SUnemployed=0;
			SHoursPerWeek=X4710;
			if SEmployed=1 & SHoursPerWeek=>35 then Sfulltime=1; else Sfulltime=0; 
			if SEmployed=1 & SHoursPerWeek=<35 then Sparttime=1; else Sparttime=0;
	*Characters to numbers for ID and year;
		X1=Y1;
		XX1=YY1;
		Y1=X1*1;
		YY1=XX1*1;
		yeartemp=year*1;
			drop year;
			rename yeartemp=year;
	EnglishProficiency=X6526;
	if EnglishProficiency=2 then EnglishProficiency=1;
	if EnglishProficiency>2 then EnglishProficiency=2;

run;
*Merge Full Info into Extract info;
	proc sort data=scftemp;
		by year Y1 YY1;
	run;
	proc sort data=scftempfull;
		by year Y1 YY1;
	run;
	Data SCFTemp;
		merge SCFtemp SCFtempfull;
		by year Y1 YY1;
	run;

*Create Restricted SCFTemp to match with SIPP Temp;
data scftemp;
	set scftemp;
	* kill irrelevent years;
		if year<1995 | year>2004 then delete;
	*Variables that needed merging;
		if spouse=0 & Married=1 then DistantSpouse=1; else DistantSpouse=0;
	*normalize variables;
		if boarder>1 then boarder=1;
		if children>6 then children=6;
		if grandchild>1 then grandchild=1;
		if householdsize>8 then householdsize=8;
		if otherrelative>1 then otherrelative=1;
		if yearsatjob>0 then loggedyearsatjob=log10(yearsatjob); 
		if yearsatjob<0 then loggedyearsatjob=-log10(ABS(yearsatjob)); 
		if yearsatjob=0 then loggedyearsatjob=0;
	Array SkewedVariable (3) salaryincome vehiclevalue yearsatjob;
	Array LoggedVariable (3) loggedsalaryincome loggedvehiclevalue loggedyearsatjob;
	Do i = 1 to 3;
		if SkewedVariable(i)>0 then LoggedVariable(i)=log10(SkewedVariable(i));  *This without if statement would produce an error and missing number for those with negative and 0 networth.;
*		if SkewedVariable(i)<0 then LoggedVariable(i)=-log10(ABS(SkewedVariable(i))); *This gives me negative logged networth;
		if SkewedVariable(i)<=0 then LoggedVariable(i)=0; *This is not actually true, but log of 1=0, and 0 is pretty close to 1...;
	END;
*Add inheritance variables - Taken from Lisa Keister;
	/***GENERAL GIFTS AND INHERITANCE -- SEE BELOW FOR DETAILS ON TRANSFERRED REAL ESTATE AND BUSINESSES***/
            /*EVER RECEIVED*/
            if X5801=1 then ReceivedInheritance=1;
                  else ReceivedInheritance=0; 
            /*NUMBER OF INHERITANCES*/
            NumberInheritances      =     X5802;
            /*Types:
            0. did not receive an inheritance
            1. inheritance; life insurance; other settlement; inherited trust
            2. trust
            3. transfer/gift
            4. other
            I changed values of -7 to 4; according to the SCF codebook:
                NOTE: the large number of -7 codes for this variable reflect
                a programming error that cause the verbatim response to the
               question to be skipped.
 
            I changed values of 6 (inherited trust) to 2. the codebook says to call these inheritance, but Wolff calls them trusts.
 
            I changed values of 5 to 1; there were only 5 responses of this sort to inheritance type 2;
                  the codebook makes no mention of this code, so I put them in with the most common type.
            */         
 
/**I create a variable below that indicates whether the respondent received *any* of each of the three categories**/
 
 
            /*TYPE OF INHERITANCE -- FIRST INHERITANCE*/
            InheritanceType1  =     X5803;
                  if InheritanceType1 = -7
                  then InheritanceType1 = 4;
 
                  else if InheritanceType1 = 6
                  then InheritanceType1 = 2;
 
                  If InheritanceType1 = 1
                  then InheritanceType1_inherit = 1;
                  else InheritanceType1_inherit = 0;
 
                  If InheritanceType1 = 3
                  then InheritanceType1_gift = 1;
                  else InheritanceType1_gift = 0;
 
                  If InheritanceType1 = 2 or InheritanceType1 = 4
                  then InheritanceType1_trust = 1;
                  else InheritanceType1_trust = 0;
 
            /*TYPE OF INHERITANCE -- SECOND INHERITANCE*/
            InheritanceType2  =     X5808;
                  if InheritanceType2 = -7
                  then InheritanceType2 = 4;
 
                  else if InheritanceType2 = 6
                  then InheritanceType2 = 2;
 
                  else if InheritanceType2 = 5
                  then InheritanceType2 = 1;
 
                  If InheritanceType2 = 1
                  then InheritanceType2_inherit = 1;
                  else InheritanceType2_inherit = 0;
 
                  If InheritanceType2 = 3
                  then InheritanceType2_gift = 1;
                  else InheritanceType2_gift = 0;
 
                  If InheritanceType2 = 2 or InheritanceType1 = 4
                  then InheritanceType2_trust = 1;
                  else InheritanceType2_trust = 0;
 
            /*TYPE OF INHERITANCE -- THIRD INHERITANCE*/
            InheritanceType3  =     X5813;
                  if InheritanceType3 = -7
                  then InheritanceType3 = 4;
 
                  else if InheritanceType3 = 6
                  then InheritanceType3 = 2;
 
                  If InheritanceType3 = 1
                  then InheritanceType3_inherit = 1;
                  else InheritanceType3_inherit = 0;
 
                  If InheritanceType3 = 3
                  then InheritanceType3_gift = 1;
                  else InheritanceType3_gift = 0;
 
                  If InheritanceType3 = 2 or InheritanceType1 = 4
                  then InheritanceType3_trust = 1;
                  else InheritanceType3_trust = 0;
 
           
 
            /*INHERITANCE VALUE for three separate gifts; code inheritance less than $500 as no inheritance*/
            InheritanceValue1 =     X5804;
                  if InheritanceValue1 = -1
                  then InheritanceValue1 = 0;
                  else if InheritanceValue1 lt 500
                  then InheritanceValue1 = 0;
 
            InheritanceValue2 =     X5809;
                  if InheritanceValue2 = -1
                  then InheritanceValue2 = 0;
                  else if InheritanceValue2 lt 500
                  then InheritanceValue2 = 0;
 
            InheritanceValue3 =     X5814;
                  if InheritanceValue3 = -1
                  then InheritanceValue3 = 0;
                  else if InheritanceValue3 lt 500
                  then InheritanceValue3 = 0;
 
            /*I changed -1 values to 0; -1 indicates an inheritance with no market value;
                  there were very few cases, so this doesn't make a huge difference;
                  moreover, a value-less inheritance is unlikely to be consequential.*/
 
 
            YearReceived1           =     X5805;
            YearReceived2           =     X5810;
            YearReceived3           =     X5815;
 
            if  YearReceived1 = 2010 or YearReceived1 = 2013 or
                  YearReceived2 = 2010 or YearReceived2 = 2013 or
                  YearReceived3 = 2010 or YearReceived3 = 2013
                  then YearReceived_2010_2013 = 1;
                  else YearReceived_2010_2013 = 0;
 
            if  (YearReceived1 le 2009 and YearReceived1 ge 2000) or
                  (YearReceived2 le 2009 and YearReceived2 ge 2000) or
                  (YearReceived3 le 2009 and YearReceived3 ge 2000)
                  then YearReceived_2000s = 1;
                  else YearReceived_2000s = 0;
 
 
 
 
/*proc freq data = temp2; tables YearReceived1 YearReceived2 YearReceived3 YearReceived_2000s; run;
 
proc print data = temp2; var YearReceived1 YearReceived2 YearReceived3 YearReceived_2000s; run;*/
 
 
            /*SOURCE*/
 
            InheritFrom1      =     X5806;
                  if InheritFrom1 = 2 then InheritFrom1_parents = 1;
                  else InheritFrom1_parents = 0;
 
                  if InheritFrom1 = 1 then InheritFrom1_grandparents = 1;
                  else InheritFrom1_grandparents = 0;
 
                  if InheritFrom1 = 3 or InheritFrom1 = 4 or InheritFrom1 = 5 or InheritFrom1 = 7 or
                        InheritFrom1 = 11 or InheritFrom1 = 25 or InheritFrom1 = 30 then InheritFrom1_relative = 1;
                  else InheritFrom1_relative = 0;
 
                  if InheritFrom1 = 6 or InheritFrom1 = 12 or InheritFrom1 = -7 then InheritFrom1_other = 1;
                  else InheritFrom1_other = 0;
 
 
            InheritFrom2      =     X5811;
                  if InheritFrom2 = 2 then InheritFrom2_parents = 1;
                  else InheritFrom2_parents = 0;
 
                  if InheritFrom2 = 1 then InheritFrom2_grandparents = 1;
                  else InheritFrom2_grandparents = 0;
 
                  if InheritFrom2 = 3 or InheritFrom2 = 4 or InheritFrom2 = 5 or InheritFrom2 = 7 or
                        InheritFrom2 = 11 or InheritFrom2 = 25 or InheritFrom2 = 30 then InheritFrom2_relative = 1;
                  else InheritFrom2_relative = 0;
 
                  if InheritFrom2 = 6 or InheritFrom2 = 12 or InheritFrom2 = -7 then InheritFrom2_other = 1;
                  else InheritFrom2_other = 0;
 
 
            InheritFrom3      =     X5816;
                  if InheritFrom3 = 2 then InheritFrom3_parents = 1;
                  else InheritFrom3_parents = 0;
 
                  if InheritFrom3 = 1 then InheritFrom3_grandparents = 1;
                  else InheritFrom3_grandparents = 0;
 
                  if InheritFrom3 = 3 or InheritFrom3 = 4 or InheritFrom3 = 5 or InheritFrom3 = 7 or
                        InheritFrom3 = 11 or InheritFrom3 = 25 or InheritFrom3 = 30 then InheritFrom3_relative = 1;
                  else InheritFrom3_relative = 0;
 
                  if InheritFrom3 = 6 or InheritFrom3 = 12 or InheritFrom3 = -7 then InheritFrom3_other = 1;
                  else InheritFrom3_other = 0;
 
            /*Create summary variable - any inheritance by source*/
 
                  if InheritFrom1_parents = 1 or InheritFrom2_parents = 1 or InheritFrom3_parents = 1 then InheritFrom_parents = 1;
                  else InheritFrom_parents = 0;
 
                  if InheritFrom1_grandparents = 1 or InheritFrom2_grandparents = 1 or InheritFrom3_grandparents = 1 then InheritFrom_grandparents = 1;
                  else InheritFrom_grandparents = 0;
Totalinheritvalue=InheritanceValue1+InheritanceValue2+InheritanceValue3;
if InheritanceType1_inherit=1 | InheritanceType2_inherit=1 | InheritanceType3_inherit=1 then Anyinherit=1; else Anyinherit=0;

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

if Married=1 then Marital=1;
if DistantSpouse=1 then Marital=2;
if Widowed=1 then Marital=3;
if Divorced=1 then Marital=4;
if Separated=1 then Marital=5;
if NeverMarried=1 then Marital=6;
if Marital=. then Marital=6;
run;

*Create Rich SCF Sample;
	data richscftemp;
	set scftemp;
	if networth<100000 then delete;
	run;



*temp removed: loggedStockValue loggedCheckingValue loggedBusinessValue jointsavings Checking1;


/*Compare Variables in datasets;
proc means data=scftemp;
	var  year age female loggeddebt supportchild     boarder	children	DistantSpouse	Divorced	evermilitary	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	Married	Mortgages	NeverMarried	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	RentsProperty	loggedsalaryincome	Separated	spouse	StockMutual	Unemployed	loggedVehicleValue	loggedyearsatjob	loggedassets	loggedCarDebt	loggedCreditCardDebtValue loggedHomeDebt loggedIraValue	loggedLifeInsuranceValue	loggednetworth	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedSavingsPlanValue	loggedSecuredDebtValue Sretired Shomemaker Sparttime Sfulltime retired homemaker unemployed parttime fulltime Education Race;
run;

proc means data=richsipptemp;
	var  year age female loggeddebt supportchild     boarder	children	DistantSpouse	Divorced	evermilitary	grandchild	HomeOwner	HouseHoldSize	InterestBank	IRAor401k	Married	Mortgages	NeverMarried	NumberCarOwned	otherrelative	ownmotorcycle	ownnoncar	ownrv	parent	RentsProperty	loggedsalaryincome	Separated	spouse	StockMutual	Unemployed	loggedVehicleValue	loggedyearsatjob	loggedassets	loggedCarDebt	loggedCreditCardDebtValue loggedHomeDebt loggedIraValue	loggedLifeInsuranceValue	loggednetworth	loggedOtherAssetValue	loggedOtherRealEstateValue	loggedSavingsPlanValue	loggedSecuredDebtValue	loggedStockValue Sretired Shomemaker Sparttime Sfulltime retired homemaker unemployed parttime fulltime Education Race;
run;


proc freq data=scftemp; 
tables yearsatjob;
run;

*/

proc sort data=richsipptemp Threads;
by race;
run;
proc sort data=richscftemp Threads;
by race;
run;

	proc freq data=richscftemp;
	tables EnglishProficiency ;
	by race;
	run;

	proc freq data=richsipptemp;
	tables EnglishProficiency ;
	by race;
	run;
