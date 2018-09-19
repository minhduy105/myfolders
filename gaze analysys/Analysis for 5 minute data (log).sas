/*For the "fancy" graph at the end, need to be version 9.4 or above to run*/


/*NOTE: Using log, so there is no log 0, so I don't change null value to 0 */
libname sql 'SAS-library';
FILENAME REFFILE '/folders/myfolders/gaze analysys/DiscriptiveData_4gazes_100sec.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT1 (keep = Dyad Cov Duration GazeType);
	where Cov = 1;
run;


/*
Get the total, mean, and frequency of the four gaze
Divide to 30.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/


proc sql; /*Get the "Cov" column so we can add two table back together*/
	create table Around_1 as
	
/*	This is taking log at the end
   	select Dyad, log(sum(Duration/30.0)) as TotalDurationAround1,
   		log(mean(Duration/30.0)) as MeanDurationAround1,*/
   		
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationAroundLog1,
   		mean(log(Duration/30.0)) as MeanDurationAroundLog1,
   		count(*) as FrequencyAround1
		from WORK.Gaze1
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_1 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitorLog1,
   		mean(log(Duration/30.0)) as MeanDurationMonitorLog1,
   		count(*) as FrequencyMonitor1
		from WORK.Gaze1
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboardLog1,
   		mean(log(Duration/30.0)) as MeanDurationKeyboardLog1,
   		count(*) as FrequencyKeyboard1
		from WORK.Gaze1
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_1 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFaceLog1,
   		mean(log(Duration/30.0)) as MeanDurationFaceLog1,
   		count(*) as FrequencyFace1
		from WORK.Gaze1
		where GazeType = 4
		group by Dyad;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_1 as 
	select A.*, M.*, K.*, F.* 
		from WORK.Around_1 A	
		full join WORK.Monitor_1 M on A.Dyad = M.Dyad
		full join WORK.Keyboard_1 K on A.Dyad = K.Dyad
		full join WORK.Face_1 F on A.Dyad = F.Dyad;
quit;	

/*set all the null value to 0, such as Hawking do not look at the keyboard the whole time in dyad 8 and 44*/
/*
data Summary_1;
	set Summary_1; /*read an observation (row)*/
/*	array a(*) _numeric_; /*turm the row into an array*/
/*	do i=1 to dim(a); /*go through the array, find and change null to 0*/
/*	if a(i) = . then a(i) = 0;
	end;
	drop i;
*/

/* -----------------get data for conversation 2-----------------------*/
data Gaze2;
   set WORK.IMPORT1 (keep = Dyad Cov Duration GazeType);
	where Cov = 2;
run;

/*
Get the total, mean, and frequency of the four gaze
Divide to 30.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/


proc sql;
	create table Around_2 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationAroundLog2,
   		mean(log(Duration/30.0)) as MeanDurationAroundLog2,
   		count(*) as FrequencyAround2
		from WORK.Gaze2
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_2 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationMonitorLog2,
   		mean(log(Duration/30.0)) as MeanDurationMonitorLog2,
   		count(*) as FrequencyMonitor2
		from WORK.Gaze2
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2 as 
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationKeyboardLog2,
   		mean(log(Duration/30.0))  as MeanDurationKeyboardLog2,
   		count(*) as FrequencyKeyboard2
		from WORK.Gaze2
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_2 as
   	select Dyad, sum(log(Duration/30.0)) as TotalDurationFaceLog2,
   		mean(log(Duration/30.0)) as MeanDurationFaceLog2,
   		count(*) as FrequencyFace2
		from WORK.Gaze2
		where GazeType = 4
		group by Dyad;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_2 as 
	select A.*, M.*, K.*, F.* 
		from WORK.Around_2 A	
		full join WORK.Monitor_2 M on A.Dyad = M.Dyad
		full join WORK.Keyboard_2 K on A.Dyad = K.Dyad
		full join WORK.Face_2 F on A.Dyad = F.Dyad;
quit;	

/*set all the null value to 0*/

/*
data Summary_2;
	set Summary_2; /*read an observation (row)*/
/*	array a(*) _numeric_; /*turm the row into an array*/
/*	do i=1 to dim(a); /*go through the array, find and change null to 0*/
/*	if a(i) = . then a(i) = 0;
	end;
	drop i;
*/
/*Combine dyad 1 and dyad 2 together*/

proc sql;
	create table Summary as 
	select D1.*, D2.* 
		from WORK.Summary_1 D1	
		full join WORK.Summary_2 D2 on D1.Dyad = D2.Dyad;
quit;	

/*--------------------------------------Summary of the data-------------------------------------------*/

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var TotalDurationAroundLog1 TotalDurationAroundLog2 TotalDurationFaceLog1 TotalDurationFaceLog2
		TotalDurationMonitorLog1 TotalDurationMonitorLog2 TotalDurationKeyboardLog1 TotalDurationKeyboardLog2;
   title 'Summary of Total gaze time in 4 categories and 2 conversation';
run;

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var MeanDurationAroundLog1 MeanDurationAroundLog2 MeanDurationFaceLog1 MeanDurationFaceLog2
		MeanDurationMonitorLog1 MeanDurationMonitorLog2 MeanDurationKeyboardLog1 MeanDurationKeyboardLog2;
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
   paired TotalDurationAroundLog1*TotalDurationAroundLog2 TotalDurationFaceLog1*TotalDurationFaceLog2
		TotalDurationMonitorLog1*TotalDurationMonitorLog2 TotalDurationKeyboardLog1*TotalDurationKeyboardLog2
		MeanDurationAroundLog1*MeanDurationAroundLog2 MeanDurationFaceLog1*MeanDurationFaceLog2
		MeanDurationMonitorLog1*MeanDurationMonitorLog2 MeanDurationKeyboardLog1*MeanDurationKeyboardLog2
		FrequencyAround1*FrequencyAround2 FrequencyFace1*FrequencyFace2
		FrequencyMonitor1*FrequencyMonitor2 FrequencyKeyboard1*FrequencyKeyboard2;
run;

/*------------------------------Running the Correlation Test------------------------------------------*/
proc corr data=Summary;
	var TotalDurationAroundLog1 ;
	with TotalDurationAroundLog2 ;
run;

proc corr data=Summary;
	var TotalDurationFaceLog1 ;
	with TotalDurationFaceLog2 ;
run;

proc corr data=Summary;
	var TotalDurationMonitorLog1 ;
	with TotalDurationMonitorLog2 ;
run;

proc corr data=Summary;
	var TotalDurationKeyboardLog1;
	with TotalDurationKeyboardLog2;
run;

proc corr data=Summary;
	var MeanDurationAroundLog1 ;
	with MeanDurationAroundLog2 ;
run;

proc corr data=Summary;
	var MeanDurationFaceLog1 ;
	with MeanDurationFaceLog2 ;
run;

proc corr data=Summary;
	var MeanDurationMonitorLog1 ;
	with MeanDurationMonitorLog2 ;
run;

proc corr data=Summary;
	var MeanDurationKeyboardLog1;
	with MeanDurationKeyboardLog2;
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


/*--------------------------------Draw plot-box -----------------------------------------------------*/
/*create new column in order to create new table for doing box-plot */
proc sql; /*adding new column*/
      alter table Summary
      ADD AroundID char format = $6.
      ADD FaceID char format = $4.
      ADD MonitorID char format = $7.
      ADD KeyboardID char format = $3.
      ADD Cov1 char format = $4.
      ADD Cov2 char format = $4.;
   update Summary
   set AroundID='Around', FaceID='Face', MonitorID='Monitor', KeyboardID='Key',
	   Cov1 = 'Con1', Cov2 = 'Con2'; /*set initial values for those column*/
quit;

proc sql;/*create new table for box-plot*/
create table Summary_box_plot as 
	select AroundID as GazeType, Cov1 as Conversation,
			TotalDurationAroundLog1 as TotalDurationLog, MeanDurationAroundLog1 as MeanDurationLog ,
			FrequencyAround1 as Frequency from Summary
	union join
	select AroundID,Cov2, TotalDurationAroundLog2 , MeanDurationAroundLog2, FrequencyAround2  from Summary
	union join
	select FaceID,Cov1, TotalDurationFaceLog1, MeanDurationFaceLog1, FrequencyFace1  from Summary
	union join
	select FaceID,Cov2, TotalDurationFaceLog2, MeanDurationFaceLog2, FrequencyFace2 from Summary
	union join
	select MonitorID, Cov1, TotalDurationMonitorLog1, MeanDurationMonitorLog1, FrequencyMonitor1  from Summary
	union join
	select MonitorID, Cov2, TotalDurationMonitorLog2, MeanDurationMonitorLog2, FrequencyMonitor2  from Summary
	union join
	select KeyboardID, Cov1, TotalDurationKeyboardLog1, MeanDurationKeyboardLog1, FrequencyKeyboard1  from Summary
	union join
	select KeyboardID, Cov2, TotalDurationKeyboardLog2, MeanDurationKeyboardLog2, FrequencyKeyboard2  from Summary;
quit;

title 'Box Plot for Total Duration Log of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox TotalDurationLog / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log log(seconds)';
  run;
title 'Box Plot for Mean Duration Log of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox MeanDurationLog / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration Log log(seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;

title 'Box Plot for Total Duration Log of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox TotalDurationLog / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;
title 'Box Plot for Mean Duration Log of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox MeanDurationLog / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration (seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;



/*--------------------------------------Draw histogram plot-------------------------------------------*/
title 'Histogram for Total Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Monitor Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Monitor");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Keyboard Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Key");       /* restrict to two groups */
	histogram TotalDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDurationLog / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=GazeType;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDurationLog / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDurationLog / type= kernel group=GazeType;/* overlay density estimates */
run;
/*MEAN*/
title 'Histogram for Mean Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Monitor Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Monitor");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Keyboard Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Key");       /* restrict to two groups */
	histogram MeanDurationLog / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDurationLog / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=GazeType;/* overlay density estimates */
run;
title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDurationLog / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDurationLog / type= kernel group=GazeType;/* overlay density estimates */
run;

/*--------Frequency---------------*/

title 'Histogram for Frequency Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Frequency Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Frequency Monitor Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Monitor");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Frequency Keyboard Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Key");       /* restrict to two groups */
	histogram Frequency / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Frequency Around Gaze and Frequency Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram Frequency / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=GazeType;/* overlay density estimates */
run;
title 'Histogram for Frequency Around Gaze and Frequency Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram Frequency / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density Frequency / type= kernel group=GazeType;/* overlay density estimates */
run;

/*----------------------------READING THE EMOTIONAL DATA-----------------------------------------------------------*/


FILENAME REFFILE '/folders/myfolders/gaze analysys/personal trait data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT2; RUN;
/*
data Rating;
   set WORK.IMPORT2 (keep = Dyad Cov Duration GazeType);
	where Cov = 1;
run;
*/

