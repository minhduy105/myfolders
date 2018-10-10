libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/LogTime.csv';
/*This is for the normal time*/
/*FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/NormalTime.csv';*/


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
   var TotalDurationAroundLog1_0s TotalDurationAroundLog1_200s TotalDurationAroundLog2_0s TotalDurationAroundLog2_200s 
   		TotalDurationFaceLog1_0s TotalDurationFaceLog1_200s TotalDurationFaceLog2_0s TotalDurationFaceLog2_200s;
   title 'Summary of Total gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var MeanDurationAroundLog1_0s MeanDurationAroundLog1_200s MeanDurationAroundLog2_0s MeanDurationAroundLog2_200s 
   		MeanDurationFaceLog1_0s MeanDurationFaceLog1_200s MeanDurationFaceLog2_0s MeanDurationFaceLog2_200s;
   title 'Summary of Mean gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var FrequencyAround1_0s FrequencyAround1_200s FrequencyAround2_0s FrequencyAround2_200s 
   		FrequencyFace1_0s FrequencyFace1_200s FrequencyFace2_0s FrequencyFace2_200s;
   title 'Summary of Frequency of gaze in 4 categories and 2 conversation';
run;

/*-------------------------Running the Paired T-Test for gazes between conversation------------------------------------------*/
proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   paired TotalDurationAroundLog1_0s*TotalDurationAroundLog1_200s
   			TotalDurationAroundLog2_0s*TotalDurationAroundLog2_200s
   			TotalDurationAroundLog1_0s*TotalDurationAroundLog2_0s
			TotalDurationAroundLog1_200s*TotalDurationAroundLog2_0s
   			TotalDurationAroundLog1_200s*TotalDurationAroundLog2_200s
   		
   			TotalDurationFaceLog1_0s*TotalDurationFaceLog1_200s
   			TotalDurationFaceLog2_0s*TotalDurationFaceLog2_200s
   			TotalDurationFaceLog1_0s*TotalDurationFaceLog2_0s
   			TotalDurationFaceLog1_200s*TotalDurationFaceLog2_0s
   			TotalDurationFaceLog1_200s*TotalDurationFaceLog2_200s
   			
			MeanDurationAroundLog1_0s*MeanDurationAroundLog1_200s 
			MeanDurationAroundLog2_0s*MeanDurationAroundLog2_200s
			MeanDurationAroundLog1_0s*MeanDurationAroundLog2_0s
			MeanDurationAroundLog1_200s*MeanDurationAroundLog2_0s
			MeanDurationAroundLog1_200s*MeanDurationAroundLog2_200s
			
			MeanDurationFaceLog1_0s*MeanDurationFaceLog1_200s
			MeanDurationFaceLog2_0s*MeanDurationFaceLog2_200s
			MeanDurationFaceLog1_0s*MeanDurationFaceLog2_0s
			MeanDurationFaceLog1_200s*MeanDurationFaceLog2_0s
			MeanDurationFaceLog1_200s*MeanDurationFaceLog2_200s
			
			FrequencyAround1_0s*FrequencyAround1_200s 
			FrequencyAround2_0s*FrequencyAround2_200s
			FrequencyAround1_0s*FrequencyAround2_0s
			FrequencyAround1_200s*FrequencyAround2_0s
			FrequencyAround1_200s*FrequencyAround2_200s
			
			FrequencyFace1_0s*FrequencyFace1_200s 
			FrequencyFace2_0s*FrequencyFace2_200s
			FrequencyFace1_0s*FrequencyFace2_0s
			FrequencyFace1_200s*FrequencyFace2_0s
			FrequencyFace1_200s*FrequencyFace2_200s
			;
run;

/*------------------------------Running the Correlation Test------------------------------------------*/
proc corr data=Summary;
	var TotalDurationAroundLog1_0s TotalDurationAroundLog1_200s 
		TotalDurationAroundLog2_0s TotalDurationAroundLog2_200s ;
run;

proc corr data=Summary;
	var TotalDurationFaceLog1_0s TotalDurationFaceLog1_200s 
		TotalDurationFaceLog2_0s TotalDurationFaceLog2_200s ;
run;

proc corr data=Summary;
	var MeanDurationAroundLog1_0s MeanDurationAroundLog1_200s 
		MeanDurationAroundLog2_0s MeanDurationAroundLog2_200s ;
run;

proc corr data=Summary;
	var MeanDurationFaceLog1_0s MeanDurationFaceLog1_200s 
		MeanDurationFaceLog2_0s MeanDurationFaceLog2_200s ;
run;

proc corr data=Summary;
	var FrequencyAround1_0s FrequencyAround1_200s FrequencyAround2_0s FrequencyAround2_200s ;
run;

proc corr data=Summary;
	var FrequencyFace1_0s FrequencyFace1_200s FrequencyFace2_0s FrequencyFace2_200s ;
run;


/*--------------------------------Draw plot-box -----------------------------------------------------*/
/*create new column in order to create new table for doing box-plot */
proc sql; /*adding new column*/
      alter table Summary
      ADD AroundID char format = $6.
      ADD FaceID char format = $4.
      ADD MonitorID char format = $7.
      ADD KeyboardID char format = $3.
      ADD Cov1 char format = $4.
      ADD Cov2 char format = $4.
      ADD TimeStart0 char format = $2.
      ADD TimeStart2 char format = $4.;
   update Summary
   set AroundID='Around', FaceID='Face', MonitorID='Monitor', KeyboardID='Key',
	   Cov1 = 'Con1', Cov2 = 'Con2',
	   TimeStart0 = '0s', TimeStart2 = '200s' ; /*set initial values for those column*/
quit;

proc sql;/*create new table for box-plot, need ID or Union will combine similar value*/
create table Summary_box_plot as 
	select Dyad, AroundID as GazeType, Cov1 as Conversation, TimeStart0 as TimeStart,
			TotalDurationAroundLog1_0s as TotalDurationLog, MeanDurationAroundLog1_0s as MeanDurationLog,
			FrequencyAround1_0s as Frequency from Summary
	union
	select Dyad, AroundID, Cov1, TimeStart2, TotalDurationAroundLog1_200s, 
			MeanDurationAroundLog1_200s, FrequencyAround1_200s  from Summary
	union
	select Dyad, AroundID, Cov2, TimeStart0, TotalDurationAroundLog2_0s, 
			MeanDurationAroundLog2_0s, FrequencyAround2_0s  from Summary
	union
	select Dyad, AroundID, Cov2, TimeStart2, TotalDurationAroundLog2_200s, 
			MeanDurationAroundLog2_200s, FrequencyAround2_200s  from Summary
	union

	select Dyad, FaceID,Cov1, TimeStart0, TotalDurationFaceLog1_0s , 
			MeanDurationFaceLog1_0s, FrequencyFace1_0s  from Summary
	union
	select Dyad,FaceID,Cov1, TimeStart2, TotalDurationFaceLog1_200s , 
			MeanDurationFaceLog1_200s, FrequencyFace1_200s  from Summary
	union
	select Dyad, FaceID,Cov2, TimeStart0, TotalDurationFaceLog2_0s , 
			MeanDurationFaceLog2_0s, FrequencyFace2_0s  from Summary
	union
	select Dyad, FaceID,Cov2, TimeStart2, TotalDurationFaceLog2_200s , 
			MeanDurationFaceLog2_200s, FrequencyFace2_200s  from Summary
;
quit;

data Summary_box_plot;
   set Summary_box_plot;
   ConvTime=catx('_at_', of Conversation, TimeStart );
run;


title 'Box Plot for Total Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox TotalDurationLog / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log(seconds)';
  run;


title 'Box Plot for Mean Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox MeanDurationLog / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log(seconds)';
  run;
  
title 'Box Plot for Frequency of Face Gaze and Around Gaze in Conversation 1 and 2 (v1)';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=ConvTime group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;  

title 'Box Plot for Total Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox TotalDurationLog / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log(seconds)';
  run;


title 'Box Plot for Mean Duration of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox MeanDurationLog / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log(seconds)';
  run;
  

title 'Box Plot for Frequency of Face Gaze and Around Gaze in Conversation 1 and 2 (v2)';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=GazeType group=ConvTime groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;  
  
/*--------------------------------------Draw histogram plot-------------------------------------------*/

/*-------------------------------------Total Around------------------------------------*/
title 'Histogram for Total Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Total Face------------------------------------*/
title 'Histogram for Total Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Mean Around------------------------------------*/
title 'Histogram for Mean Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Mean Face------------------------------------*/
title 'Histogram for Mean Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDurationLog / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Mean Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

/*-------------------------------------Frequency Around------------------------------------*/
title 'Histogram for Frequency Around Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con1");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and Conversation in ("Con2");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("0s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and TimeStart in ("200s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Around Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;


/*-------------------------------------Frequency Face------------------------------------*/
title 'Histogram for Frequency Face Gaze of the 1st interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze of the 2nd interaction between the first 100s and the last 100s with kernel fitting';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram Frequency / group=TimeStart transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=TimeStart;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the first 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("0s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the last 100s with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and TimeStart in ("200s");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Frequency Face Gaze in the last 100s of the 1st interaction and the first 100s of the 2nd interaction with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face") and((TimeStart in ("200s") and Conversation in ("Con1"))
								or (TimeStart in ("0s") and Conversation in ("Con2")));       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
