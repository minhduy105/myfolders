libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/LogTimeGaze5min.csv';


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
			TotalDurationAround1 as TotalDuration, MeanDurationAround1 as MeanDuration ,
			FrequencyAround1 as Frequency from Summary
	union 
	select AroundID,Cov2, TotalDurationAround2 , MeanDurationAround2, FrequencyAround2  from Summary
	union 
	select FaceID,Cov1, TotalDurationFace1, MeanDurationFace1, FrequencyFace1  from Summary
	union 
	select FaceID,Cov2, TotalDurationFace2, MeanDurationFace2, FrequencyFace2 from Summary
	union 
	select MonitorID, Cov1, TotalDurationMonitor1, MeanDurationMonitor1, FrequencyMonitor1  from Summary
	union 
	select MonitorID, Cov2, TotalDurationMonitor2, MeanDurationMonitor2, FrequencyMonitor2  from Summary
	union 
	select KeyboardID, Cov1, TotalDurationKeyboard1, MeanDurationKeyboard1, FrequencyKeyboard1  from Summary
	union 
	select KeyboardID, Cov2, TotalDurationKeyboard2, MeanDurationKeyboard2, FrequencyKeyboard2  from Summary;
quit;

proc corr data = Summary_box_plot;
	var TotalDuration;
	by GazeType Conversation;
quit;	


title 'Box Plot for Total Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Mean Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;


title 'Box Plot for Total Duration of Gazes in Conversation 1 and 2 ';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Mean Duration of Gazes in Conversation 1 and 2 ';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2 ';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;




/*--------------------------------------Draw histogram plot-------------------------------------------*/
title 'Histogram for Total Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Monitor Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Monitor");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Keyboard Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Key");       /* restrict to two groups */
	histogram TotalDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=Conversation;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram TotalDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=GazeType;/* overlay density estimates */
run;

title 'Histogram for Total Around Gaze and Total Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram TotalDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density TotalDuration / type= kernel group=GazeType;/* overlay density estimates */
run;
/*MEAN*/
title 'Histogram for Mean Around Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Face Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Face");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Monitor Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Monitor");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Keyboard Gaze with kernel fitting Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Key");       /* restrict to two groups */
	histogram MeanDuration / group=Conversation transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=Conversation;/* overlay density estimates */
run;
title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 1';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con1");       /* restrict to two groups */
	histogram MeanDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=GazeType;/* overlay density estimates */
run;
title 'Histogram for Mean Around Gaze and Mean Face Gaze with kernel fitting in Conversation 2';
proc sgplot data=Summary_box_plot;
	where GazeType in ("Around","Face") and Conversation in ("Con2");       /* restrict to two groups */
	histogram MeanDuration / group=GazeType transparency=0.5;       /* SAS 9.4m2 */
	density MeanDuration / type= kernel group=GazeType;/* overlay density estimates */
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
			TotalDurationAround1 as TotalDuration, MeanDurationAround1 as MeanDuration ,
			FrequencyAround1 as Frequency from Summary
	union 
	select AroundID,Cov2, TotalDurationAround2 , MeanDurationAround2, FrequencyAround2  from Summary
	union 
	select FaceID,Cov1, TotalDurationFace1, MeanDurationFace1, FrequencyFace1  from Summary
	union 
	select FaceID,Cov2, TotalDurationFace2, MeanDurationFace2, FrequencyFace2 from Summary
	union 
	select MonitorID, Cov1, TotalDurationMonitor1, MeanDurationMonitor1, FrequencyMonitor1  from Summary
	union 
	select MonitorID, Cov2, TotalDurationMonitor2, MeanDurationMonitor2, FrequencyMonitor2  from Summary
	union 
	select KeyboardID, Cov1, TotalDurationKeyboard1, MeanDurationKeyboard1, FrequencyKeyboard1  from Summary
	union 
	select KeyboardID, Cov2, TotalDurationKeyboard2, MeanDurationKeyboard2, FrequencyKeyboard2  from Summary;
quit;

proc corr data = Summary_box_plot;
	var TotalDuration;
	by GazeType Conversation;
quit;	


title 'Box Plot for Total Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Mean Duration of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category=Conversation group=GazeType groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;


title 'Box Plot for Total Duration of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox TotalDuration / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Mean Duration of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox MeanDuration / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Total Duration log(seconds)';
  run;
title 'Box Plot for Frequency of Gazes in Conversation 1 and 2 v2';
proc sgplot data=Summary_box_plot;
  vbox Frequency / category= GazeType group= Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Frequency';
  run;


