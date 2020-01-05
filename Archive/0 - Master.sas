PROC DATASETS lib=work kill nolist memtype=data;
quit;

*Define Library;
	libname SIPP 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SIPP Data Files';	
	libname Scf 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\SCF Data Files';	
*1 - (Optional - Not needed if datasets already created) - Combine data and create year variables. Also creates a variable to identify the reference person;
	*%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\1 - Prep Data.sas';
*2 - Create Variables for SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\2 - Create Variables for SIPP.sas';
*2.5 - Create country of birth variables for SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\2.5 - Create country of birth variables for SIPP.sas';
*3 - Create Variables for SCF;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\3 - Create Variables for SCF.sas';
*4 - (Optional - Not needed) Basic Descriptives Stats;
	*%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\4 - Basic Descriptives Stats.sas';
*5 - MI for missing values within SIPP;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\5 - MI for missing values within SIPP.sas';
*6 - Append Datasets;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\6 - Append Datasets.sas';
*7 - Create Synthetic Data;
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\7 - Create Synthetic Data.sas';
*8 - Test Synthetic Data; 
	%Include 'C:\Users\bdaro_000\Sociology\IndependentStudyRA\SIPP and SCF Merge Project\8 - SCFSynth Diagnostics.sas';
	
