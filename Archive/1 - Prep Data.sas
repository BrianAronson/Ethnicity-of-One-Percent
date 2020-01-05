PROC DATASETS lib=work kill nolist memtype=data;
quit;

*Define Libraries;
libname Scf 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SCF Data Files';	
libname SIPP 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SIPP Data Files';	


*In SCF: indsname creates temporary variable of the name of each dataset, the following line creates a year variable based off the temporary name variable and the first occurence ofa number
In SIPP: Also creates a variable to identify the reference person;

DATA SCF.Combined;
	set Scf.Scfp1995 Scf.Scfp2001 Scf.Scfp2004 Scf.Scfp2007 indsname=year1; 
	year=substr(year1,ANYDIGIT(year1))+0;
	Dataset='SCF';
run; 
*Import Earlier files;
*		filename importin 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SCF Data Files\scf83b';
*		PROC CIMPORT infile=importin library=scf memtype=data;
*		RUN;

DATA SCF.Combined2;
	set Scf.Scfp1989 Scf.Scfp1992 Scf.Scfp1995 Scf.Scfp1998 Scf.Scfp2001 Scf.Scfp2004 Scf.Scfp2007 Scf.Scfp2010 indsname=year1; 
	year=substr(year1,ANYDIGIT(year1))+0;
	Dataset='SCF';
run; 

DATA SIPP.Combined;
	set SIPP.sip96l3 SIPP.sip01w3 SIPP.sip04w3 SIPP.sippl08puw3; 
	Dataset='SIPP'; /*create a variable to identify data is from SIPP*/
	year=spanel;
	if epppnum=ehrefper then refperson=1; /*Creates a variable to identify the household reference person*/
	if srefmon~=4 then delete; /*Remove multiple observations for single years from SIPP Core files. It is common practice to use the fourth reference month, as this is when the topical modules were collected.*/
run; 

*Add Topical Modules to data. First sort by year, location, household, and member;
Proc Sort Data=Sipp.Combined;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sippp08putm2;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=Sipp.SIPPP08PUTM4;
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
Proc Sort Data=SIPP.sip04t2;
	by spanel SSUID shhadid epppnum;
run;
Proc Sort Data=SIPP.sip04t3;
	by spanel SSUID shhadid epppnum;
run;
*Combine topical modules with core files;
Data SIPP.Combined1;
	merge SIPP.Combined SIPP.sip96t2 SIPP.sip96t3 SIPP.sip01t2 SIPP.sip01t3 SIPP.sip04t2 SIPP.sip04t3 SIPP.sippp08putm2 SIPP.sippp08putm4; 
	by spanel SSUID shhadid epppnum;
run;
*Since this file is about 5gb, make a truncated dataset for analysis;
Data SIPP.Combined2;
	set SIPP.Combined1 (Keep = ssuid shhadid swave rhcalmn whfnwgt thearn efrefper rfnkids epppnum esft errp tpearn ebiznow1 east1b east1c east2a east3a east3b tprstate tbrstate esex erace eorigin wpfinwgt tage ems eeducate ealow ealowa ealsb talsbv ealjch taljcha ealjdb ealjdl ealjdo ealjdab ealjdal ealjdao ealich talicha ealil ealidb ealidl ealido ealidab ealidao ealr ealry talrb ealra1 ealra2 ealra3 ealra4 ealk ealky talkb ealka1 ealka2 ealka3 ealka4 ealt ealty taltb ealta1 ealta2 ealta3 ealta4 ealli talliv eallit eallie talliev eoaeq tiajta tiaita timja timia esmjm esmjs esmjv esmjma esmjmav esmi esmiv esmima erjown erjnum trjmv erjdeb trjpri eriown erinum eriat eriata trimv erideb tripri trtmv ertdeb trtsha tmjp tmip evbno1 evbow1 tvbva1 tvbva2 eremobho ehowner1 ehowner2 ehowner3 ehbuymo ehbuyyr ehmort enummort tmor1pr emor1yr emor1mo tmor1amt emor1yrs emor1int emor1var emor2yr emor2mo emor2int emor2var emor2pgm tpropval emhloan emhtype tmhpr tmhval thomeamt eperspay eperspya eperspy2 eperspy3 tpersam1 epaycare eothre eothreo1 eothreo2 tothreva eautonum tcarval1 ea1owed ta1amt tcarval2 ea2owed ta2amt tcarval3 ea3owed ta3amt eothveh eov1own1 eov1own2 tov1val eov1owe tov1amt eov2own1 eov2own2 tov2val eov2owe tov2amt thhtnw thhtwlth thhtheq thhmortg thhvehcl thhbeq thhintbk thhintot rhhstk thhore thhotast thhira thhdebt thhscdbt rhhuscbt year eprevres ecitiznt enatcitt timstat eadjust tmovyryr toutinyr tadyear tmoveus ta1year ta2year ta3year thhthrif refperson ebrstate eprstate rmoveus efkind tfipsst rmesr taltb);
	if year=. then delete;  *remove respondents who did not complete the core questionaire;
run;

