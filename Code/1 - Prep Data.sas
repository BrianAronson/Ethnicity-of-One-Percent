PROC DATASETS lib=work kill nolist memtype=data;
quit;

*import SCF files;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp1989';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp1992';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp1995';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp1998';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp2001';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp2004';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp2007';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp2010';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;
		filename importin 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files\Scfp2013';
		PROC CIMPORT infile=importin library=scf memtype=data;
		RUN;


*In SCF: indsname creates temporary variable of the name of each dataset, the following line creates a year variable based off the temporary name variable and the first occurence ofa number;

DATA SCF.Combined;
	set Scf.Scfp1995 Scf.Scfp2001 Scf.Scfp2004 Scf.Scfp2007 indsname=year1; 
	year=substr(year1,ANYDIGIT(year1))+0;
	Dataset='SCF';
run; 

DATA SCF.Combined2;
	set Scf.Scfp1989 Scf.Scfp1992 Scf.Scfp1995 Scf.Scfp1998 Scf.Scfp2001 Scf.Scfp2004 Scf.Scfp2007 Scf.Scfp2010 Scf.Scfp2013 indsname=year1; 
	year=substr(year1,ANYDIGIT(year1))+0;
	Dataset='SCF';
run; 

*Create full SCF dataset;
libname ScfFull 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Full Data Files';
DATA SCFFull.Combined;
	set ScfFull.P89i6 ScfFull.P92i4 ScfFull.P95i6 ScfFull.P98i6 ScfFull.P01i6 ScfFull.P04i6 ScfFull.P07i6 ScfFull.P10i6 ScfFull.P13i6 indsname=year1 ; 
	year=substr(year1,ANYDIGIT(year1),2);
	if (1*year)>50 then year=1900+year;
	if (1*year)<50 then year=2000+year;
run; 


Data SCFFull.Combined3;
	set SCFFull.Combined; 
	if year<1995 | year>2004 then delete;
	run;

Data SCFFull.Combined4;
*Limit to variables of interest;
	set SCFFull.Combined3 (keep= YY1 Y1 X2001 X2002 X2003 X2004 X2009 X2505 X2506 X2605 X2606 X2623 X4020 X4024 X4028 X4022 X4026 X4030 X4110 X4710 X6670 X6678 X4111 X4711 X108 X114 X120 X126 X132 X202 X208 X214 X220 X226 X4100 X4700 XX1 X1 X5801 X5802 X6703 X5803 X5808 X5813 X5804 X5809 X5814 X5805 X5810 X5815 X5806 X5811 X5816 X5818 X5819 X5821
X6526 X504 X3737 X3743 X3749 X3755 X3761 X5731 X8020 X102 X108 X114 X120 X126 X132 X202 X208 X214 X220 X226 X7021 X8023 X5906 X101 X3731 X3737 X3743 X3749 X3755 X3761 X2505 X2605 X1223 x7801 X5733 X4115 X6403 X5801 X5802 X5803 X5808 X5813 X5804 X5809 X5814 X5805 X5810 X5815 X5806 X5811 X5816 year);
*fix identifiers for old years;
	if YY1=. then YY1=XX1;
	if Y1=. then Y1=X1;
*Match job status for old years;
	if X4100>10 & X4100<20 then X4100=1;
		if X4100=20 | X4100=21 then X4100=2;
		if X4100=30 then X4100=3;
		if X4100=50 then X4100=7;
		if X4100=52 then X4100=6;
		if X4100=70 then X4100=4;
		if X4100=80 then X4100=5;
		if X4100>89 then X4100=1;
	if X4700>10 & X4700<20 then X4700=1;
		if X4700=20 | X4700=21 then X4700=2;
		if X4700=30 then X4700=3;
		if X4700=50 then X4700=7;
		if X4700=52 then X4700=6;
		if X4700=70 then X4700=4;
		if X4700=80 then X4700=5;
		if X4700>89 then X4700=1;
*Match job name for old years;
	if X6670=. then X6670=X4100;
	if X6678=. then X6678=X4700;
*Delete duplicate variables;
	drop X1;
	drop XX1;
	drop X4100;
	drop X4700;
	run;

proc freq data=SCFFull.Combined;
tables X8020;
run;

*SIPP: Create core data;

DATA SIPP.Combined;
	set SIPP.sip96l3 SIPP.sip01w3 SIPP.sip04w3 SIPP.sippl08puw3; 
	Dataset='SIPP'; *create a variable to identify data is from SIPP;
	year=spanel;
	if epppnum=ehrefper then refperson=1; *Creates a variable to identify the household reference person;
	if srefmon~=4 then delete; *Remove multiple observations for single years from SIPP Core files. It is common practice to use the fourth reference month, as this is when the topical modules were collected.;
run; 

*Add Topical Modules to data. First sort by year, location, household, and member;
Proc Sort Data=Sipp.Combined;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip96t7;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip96t5;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip96t3;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip96t2;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip01t2;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip01t3;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip01t5;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip01t7;
	by spanel SSUID shhadid epppnum;
run;

Proc Sort Data=SIPP.sip04t2;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip04t3;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip04t5;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip04t7;
	by spanel SSUID shhadid epppnum;
run;

*Combine topical modules with core files;
Data SIPP.Combined1;
	merge SIPP.Combined SIPP.sip96t2 SIPP.sip96t3 SIPP.sip96t5 SIPP.sip96t7(drop = ELUMPNUM ALUMPNUM) SIPP.sip01t2 SIPP.sip01t3 SIPP.sip01t5 SIPP.sip01t7 (drop = ELUMPNUM ALUMPNUM) SIPP.sip04t2 SIPP.sip04t3 SIPP.sip04t5 SIPP.sip04t7 (drop = ELUMPNUM ALUMPNUM); *SIPP.sippp08putm2 SIPP.sippp08putm4; 
	by spanel SSUID shhadid epppnum;
run;
*Since this file is about 5gb, make a truncated dataset for analysis;
Data SIPP.Combined2;
	set SIPP.Combined1 (Keep = ssuid shhadid swave rhcalmn whfnwgt thearn efrefper rfnkids epppnum esft errp tpearn ebiznow1 east1b east1c east2a east3a east3b tprstate tbrstate esex erace eorigin wpfinwgt tage ems eeducate ealow ealowa ealsb talsbv ealjch taljcha ealjdb ealjdl ealjdo ealjdab ealjdal ealjdao ealich talicha ealil ealidb ealidl ealido ealidab ealidao ealr ealry talrb ealra1 ealra2 ealra3 ealra4 ealk ealky talkb ealka1 ealka2 ealka3 ealka4 ealt ealty taltb ealta1 ealta2 ealta3 ealta4 ealli talliv eallit eallie talliev eoaeq tiajta tiaita timja timia esmjm esmjs esmjv esmjma esmjmav esmi esmiv esmima erjown erjnum trjmv erjdeb trjpri eriown erinum eriat eriata trimv erideb tripri trtmv ertdeb trtsha tmjp tmip evbno1 evbow1 tvbva1 tvbva2 eremobho ehowner1 ehowner2 ehowner3 ehbuymo ehbuyyr ehmort enummort tmor1pr emor1yr emor1mo tmor1amt emor1yrs emor1int emor1var emor2yr emor2mo emor2int emor2var emor2pgm tpropval emhloan emhtype tmhpr tmhval thomeamt eperspay eperspya eperspy2 eperspy3 tpersam1 epaycare eothre eothreo1 eothreo2 tothreva eautonum tcarval1 ea1owed ta1amt tcarval2 ea2owed ta2amt tcarval3 ea3owed ta3amt eothveh eov1own1 eov1own2 tov1val eov1owe tov1amt eov2own1 eov2own2 tov2val eov2owe tov2amt thhtnw thhtwlth thhtheq thhmortg thhvehcl thhbeq thhintbk thhintot rhhstk thhore thhotast thhira thhdebt thhscdbt rhhuscbt year eprevres ecitiznt enatcitt timstat eadjust tmovyryr toutinyr tadyear tmoveus ta1year ta2year ta3year thhthrif refperson ebrstate eprstate rmoveus efkind tfipsst rmesr taltb ehrsbs1 ejntrnt ejrnt2 esvjt tjbocc1 tjbocc2 tafblvyr tfmyear tlmyear epvmancd eovboat eovmtrcy eovrv eovothrv redaid05 esuptyp2 tsupltad tsupotnp esupotrl esupotre eloansgn eyrlrftj ebuswksy tbuslong tptotinc THTOTINC RANYAGRE ESUPOTPY eafever EPVCHILD TLMYEAR ehltstat EPTRESN EPDJBTHN ERSNOWRK EPTWRK ESUPOTRE TBUSLONG TNUMLEN TMETRO EHOWWELL ELNGABIL);
	if year=. then delete;  *remove respondents who did not complete the core questionaire;
run;

*/
;
proc contents data=SIPP.sip04t5 ;
run;

proc freq data=sipp.combined1;
tables esex;
run;
