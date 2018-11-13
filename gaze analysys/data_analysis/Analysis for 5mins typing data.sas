libname sql 'SAS-library';

/*This is for the normal time*/
FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/NormalTimeGaze5min.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

proc sql;
	create table Summary as 
	select * 
		from WORK.IMPORT1;
quit;	

/*set all null value to 0*/
data Summary;
	set Summary;
	array change _numeric_;
		do over change;
			if change=. then change=0;
		end;
run;


/*--------------------------------------Summary of the data-------------------------------------------*/

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var TotalDurationAround1 TotalDurationAround2 TotalDurationFace1 TotalDurationFace2
		TotalDurationMonitor1 TotalDurationMonitor2 TotalDurationKeyboard1 TotalDurationKeyboard2;
   title 'Summary of Total gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var MeanDurationAround1 MeanDurationAround2 MeanDurationFace1 MeanDurationFace2
		MeanDurationMonitor1 MeanDurationMonitor2 MeanDurationKeyboard1 MeanDurationKeyboard2;
   title 'Summary of Mean gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var FrequencyAround1 FrequencyAround2 FrequencyFace1 FrequencyFace2
		FrequencyMonitor1 FrequencyMonitor2 FrequencyKeyboard1 FrequencyKeyboard2;
   title 'Summary of Frequency of gaze in 4 categories and 2 conversation';
run;

/*-------------------------Running the Paired T-Test for gazes between conversation------------------------------------------*/
proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   paired TotalDurationAround1*TotalDurationAround2 TotalDurationFace1*TotalDurationFace2
		TotalDurationMonitor1*TotalDurationMonitor2 TotalDurationKeyboard1*TotalDurationKeyboard2
		MeanDurationAround1*MeanDurationAround2 MeanDurationFace1*MeanDurationFace2
		MeanDurationMonitor1*MeanDurationMonitor2 MeanDurationKeyboard1*MeanDurationKeyboard2
		FrequencyAround1*FrequencyAround2 FrequencyFace1*FrequencyFace2
		FrequencyMonitor1*FrequencyMonitor2 FrequencyKeyboard1*FrequencyKeyboard2;
run;

/*------------------------------Running the Correlation Test------------------------------------------*/
proc corr data=Summary;
	var TotalDurationAround1 ;
	with TotalDurationAround2 ;
run;

proc corr data=Summary;
	var TotalDurationFace1 ;
	with TotalDurationFace2 ;
run;

proc corr data=Summary;
	var TotalDurationMonitor1 ;
	with TotalDurationMonitor2 ;
run;

proc corr data=Summary;
	var TotalDurationKeyboard1;
	with TotalDurationKeyboard2;
run;

proc corr data=Summary;
	var MeanDurationAround1 ;
	with MeanDurationAround2 ;
run;

proc corr data=Summary;
	var MeanDurationFace1 ;
	with MeanDurationFace2 ;
run;

proc corr data=Summary;
	var MeanDurationMonitor1 ;
	with MeanDurationMonitor2 ;
run;

proc corr data=Summary;
	var MeanDurationKeyboard1;
	with MeanDurationKeyboard2;
run;

proc corr data=Summary;
	var FrequencyAround1 ;
	with FrequencyAround2 ;
run;

proc corr data=Summary;
	var FrequencyFace1 ;
	with FrequencyFace2 ;
run;

proc corr data=Summary;
	var FrequencyMonitor1 ;
	with FrequencyMonitor2 ;
run;

proc corr data=Summary;
	var FrequencyKeyboard1;
	with FrequencyKeyboard2;
run;
