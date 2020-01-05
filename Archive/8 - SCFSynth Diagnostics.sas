*Remove extra SIPP info used for generating this dataset;
Data SCF.Synthetic_Data;
set SCF.Synthetic_Data;
if HHSEX=. then delete;
run;

Data SCFSynth;
set SCF.Synthetic_Data;
*Create proper SCF imputation names;
	SCFImput=substr(Y1,length(Y1),1);
*Create proper Full Imputation names;
	_Imputation_=SCFImput+(5*(_Imputation_-1));
*Since having problems using Ethnicity variable in regressions, make separate variabls;
if Ethnicity1='Mainland Chinese' then MainlandChinese=1;  else MainlandChinese=0;
if Ethnicity1='HK-Taiwan' then HKTaiwan=1;  else HKTaiwan=0;
if Ethnicity1='Asian Indian' then AsianIndian=1;  else AsianIndian=0;
if Ethnicity1='Other Asian' then OtherAsian=1;  else OtherAsian=0;
if Ethnicity1='Native Asian'  then NativeAsian=1;  else NativeAsian=0;
if Ethnicity1='Mexican' then Mexican=1;  else Mexican=0;
if Ethnicity1='Cuban' then Cuban=1;  else Cuban=0;
if Ethnicity1='Other Latino' then OtherLatino=1;  else OtherLatino=0;
if Ethnicity1='Native Latino' then NativeLatino=1;  else NativeLatino=0;
if Ethnicity1='Other Immigrants' then OtherImmigrants=1;  else OtherImmigrants=0;
if Ethnicity1="Reference Category-Native Black" then NativeBlack=1;  else NativeBlack=0;
if Ethnicity1='Native White' then NativeWhite=1;  else NativeWhite=0;

run;
*Sort by imputation for all later steps;
proc sort data=SCFSynth;
by _imputation_;
run;

proc glm data=SCFSynth;
	Model loggednetworth = MainlandChinese HKTaiwan AsianIndian OtherAsian NativeAsian Mexican Cuban OtherLatino NativeLatino OtherImmigrants NativeWhite NativeBlack/solution;
	where age>24;
	weight wgt;
	by _imputation_;
	ods output ParameterEstimates=a_mvn;
*	where year~=2007;
	run;

proc mianalyze parms=a_mvn ;
	modeleffects intercept MainlandChinese HKTaiwan AsianIndian NativeAsian Mexican Cuban NativeLatino OtherImmigrants NativeWhite;
run;
