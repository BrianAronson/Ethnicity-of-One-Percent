PROC DATASETS lib=work kill nolist memtype=data;
quit;

*Define Library;
	libname SIPP 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SIPP Data Files';	
	libname Scf 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files';	
	libname ScfFull 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Data\SCF Full Data Files';

	libname SIPP 'M:\Sociology\Papers\Lisa Projects\Data\SIPP Data Files';
	libname Scf 'M:\Sociology\Papers\Lisa Projects\Data\SCF Extract Data Files';
	libname ScfFull 'M:\Sociology\Papers\Lisa Projects\Data\SCF Full Data Files';

*	libname SIPP 'N:\Data\SIPP Data Files';	
*	libname Scf 'N:\Data\SCF Extract Data Files';	
*	libname ScfFull 'N:\Data\SCF Full Data Files';


*1 - (Optional - Not needed if datasets already created) - Combine data and create year variables. Also creates a variable to identify the reference person;
	*%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\SCF-SIPP Ethnicity code\1 - Prep Data.sas';
*2 - Create Variables for SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\2 - Create Variables for SIPP.sas';
*2.5 - Create country of birth variables for SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\2.5 - Create country of birth variables for SIPP.sas';
*3 - Create Variables for SCF;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\3 - Create Variables for SCF.sas';
*4 - (Optional - Not needed) Basic Descriptives Stats;
	*%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\SCF-SIPP Ethnicity code\4 - Basic Descriptives Stats.sas';
*5 - MI for missing values within SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\5 - MI for missing values within SIPP.sas';
*6 - Append Datasets;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\6 - Append Datasets.sas';
*7 - Create Synthetic Data;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\7 - Create Synthetic Data.sas';
*8 - Test Synthetic Data; 
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\Paper - Ethnicity Synthetic Paper\Code\8 - Modify Synthetic Data.sas';
*9 - Synthetic Descriptive stats;
	%Include 'C:\Users\bdaro_000\Sociology\Papers\Lisa Projects\SCF-SIPP Ethnicity code\9 - Synth Descriptives.sas'
