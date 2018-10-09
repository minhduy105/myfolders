libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/DiscriptiveData_5talks_H_100sec.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

data WORK.IMPORT;
	set WORK.IMPORT1 (keep = Dyad -- S_BodyOnly_Min);
	where TalkType = 2;
run;

/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT (keep = Dyad -- S_BodyOnly_Min);
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

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_1_0s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAroundLog1_0s,
   		sum(S_Around_Frequency) as FrequencyAround1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Around_1_0s as
   	select Dyad, log(TotalDurationAroundLog1_0s + 1.0) as TotalDurationAroundLog1_0s ,
   		log(TotalDurationAroundLog1_0s + 1.0)/FrequencyAround1_0s as MeanDurationAroundLog1_0s,
   		FrequencyAround1_0s
		from Around_1_0s_sub;
quit;


proc sql; 
	create table Face_1_0s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFaceLog1_0s,
   		sum(S_Face_Frequency) as FrequencyFace1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Face_1_0s as
   	select Dyad, log(TotalDurationFaceLog1_0s + 1.0) as TotalDurationFaceLog1_0s ,
   		log(TotalDurationFaceLog1_0s + 1.0)/FrequencyFace1_0s as MeanDurationFaceLog1_0s,
   		FrequencyFace1_0s
		from Face_1_0s_sub;
quit;


proc sql; 
	create table Keyboard_1_0s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboardLog1_0s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_1_0s as
   	select Dyad, log(TotalDurationKeyboardLog1_0s + 1.0) as TotalDurationKeyboardLog1_0s ,
   		log(TotalDurationKeyboardLog1_0s + 1.0)/FrequencyKeyboard1_0s as MeanDurationKeyboardLog1_0s,
   		FrequencyKeyboard1_0s
		from Keyboard_1_0s_sub;
quit;


proc sql; 
	create table Monitor_1_0s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitorLog1_0s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Monitor_1_0s as
   	select Dyad, log(TotalDurationMonitorLog1_0s + 1.0) as TotalDurationMonitorLog1_0s ,
   		log(TotalDurationMonitorLog1_0s + 1.0)/FrequencyMonitor1_0s as MeanDurationMonitorLog1_0s,
   		FrequencyMonitor1_0s
		from Monitor_1_0s_sub;
quit;


/*---------------------------get the gaze data for the last 100 seconds----------------------------*/

proc sql; 
	create table Around_1_200s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAroundLog1_200s,
   		sum(S_Around_Frequency) as FrequencyAround1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Around_1_200s as
   	select Dyad, log(TotalDurationAroundLog1_200s + 1.0) as TotalDurationAroundLog1_200s ,
   		log(TotalDurationAroundLog1_200s + 1.0)/FrequencyAround1_200s as MeanDurationAroundLog1_200s,
   		FrequencyAround1_200s
		from Around_1_200s_sub;
quit;


proc sql; 
	create table Face_1_200s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFaceLog1_200s,
   		sum(S_Face_Frequency) as FrequencyFace1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Face_1_200s as
   	select Dyad, log(TotalDurationFaceLog1_200s + 1.0) as TotalDurationFaceLog1_200s ,
   		log(TotalDurationFaceLog1_200s + 1.0)/FrequencyFace1_200s as MeanDurationFaceLog1_200s,
   		FrequencyFace1_200s
		from Face_1_200s_sub;
quit;


proc sql; 
	create table Keyboard_1_200s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboardLog1_200s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_1_200s as
   	select Dyad, log(TotalDurationKeyboardLog1_200s + 1.0) as TotalDurationKeyboardLog1_200s ,
   		log(TotalDurationKeyboardLog1_200s + 1.0)/FrequencyKeyboard1_200s as MeanDurationKeyboardLog1_200s,
   		FrequencyKeyboard1_200s
		from Keyboard_1_200s_sub;
quit;


proc sql; 
	create table Monitor_1_200s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitorLog1_200s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Monitor_1_200s as
   	select Dyad, log(TotalDurationMonitorLog1_200s + 1.0) as TotalDurationMonitorLog1_200s ,
   		log(TotalDurationMonitorLog1_200s + 1.0)/FrequencyMonitor1_200s as MeanDurationMonitorLog1_200s,
   		FrequencyMonitor1_200s
		from Monitor_1_200s_sub;
quit;

/*Join all the gaze data together*/
proc sql;
	create table Summary_1 as 
	select F0.*, M0.*, K0.*, A0.*, F2.*, M2.*, K2.*, A2.* 
		from WORK.Face_1_0s F0	
		full join WORK.Monitor_1_0s M0 on F0.Dyad = M0.Dyad
		full join WORK.Keyboard_1_0s K0 on F0.Dyad = K0.Dyad
		full join WORK.Around_1_0s A0 on F0.Dyad = A0.Dyad

		full join WORK.Face_1_200s F2 on F0.Dyad = F2.Dyad
		full join WORK.Monitor_1_200s M2 on F0.Dyad = M2.Dyad
		full join WORK.Keyboard_1_200s K2 on F0.Dyad = K2.Dyad
		full join WORK.Around_1_200s A2 on F0.Dyad = A2.Dyad;
quit;	


/* -----------------get data for conversation 2-----------------------*/
data Gaze2;
   set WORK.IMPORT (keep = Dyad -- S_BodyOnly_Min);
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

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_2_0s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAroundLog2_0s,
   		sum(S_Around_Frequency) as FrequencyAround2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Around_2_0s as
   	select Dyad, log(TotalDurationAroundLog2_0s + 1.0) as TotalDurationAroundLog2_0s ,
   		log(TotalDurationAroundLog2_0s + 1.0)/FrequencyAround2_0s as MeanDurationAroundLog2_0s,
   		FrequencyAround2_0s
		from Around_2_0s_sub;
quit;


proc sql; 
	create table Face_2_0s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFaceLog2_0s,
   		sum(S_Face_Frequency) as FrequencyFace2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Face_2_0s as
   	select Dyad, log(TotalDurationFaceLog2_0s + 1.0) as TotalDurationFaceLog2_0s ,
   		log(TotalDurationFaceLog2_0s + 1.0)/FrequencyFace2_0s as MeanDurationFaceLog2_0s,
   		FrequencyFace2_0s
		from Face_2_0s_sub;
quit;


proc sql; 
	create table Keyboard_2_0s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboardLog2_0s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_2_0s as
   	select Dyad, log(TotalDurationKeyboardLog2_0s + 1.0) as TotalDurationKeyboardLog2_0s ,
   		log(TotalDurationKeyboardLog2_0s + 1.0)/FrequencyKeyboard2_0s as MeanDurationKeyboardLog2_0s,
   		FrequencyKeyboard2_0s
		from Keyboard_2_0s_sub;
quit;


proc sql; 
	create table Monitor_2_0s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitorLog2_0s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Monitor_2_0s as
   	select Dyad, log(TotalDurationMonitorLog2_0s + 1.0) as TotalDurationMonitorLog2_0s ,
   		log(TotalDurationMonitorLog2_0s + 1.0)/FrequencyMonitor2_0s as MeanDurationMonitorLog2_0s,
   		FrequencyMonitor2_0s
		from Monitor_2_0s_sub;
quit;


/*---------------------------get the gaze data for the last 100 seconds----------------------------*/

proc sql; 
	create table Around_2_200s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAroundLog2_200s,
   		sum(S_Around_Frequency) as FrequencyAround2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Around_2_200s as
   	select Dyad, log(TotalDurationAroundLog2_200s + 1.0) as TotalDurationAroundLog2_200s ,
   		log(TotalDurationAroundLog2_200s + 1.0)/FrequencyAround2_200s as MeanDurationAroundLog2_200s,
   		FrequencyAround2_200s
		from Around_2_200s_sub;
quit;


proc sql; 
	create table Face_2_200s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFaceLog2_200s,
   		sum(S_Face_Frequency) as FrequencyFace2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Face_2_200s as
   	select Dyad, log(TotalDurationFaceLog2_200s + 1.0) as TotalDurationFaceLog2_200s ,
   		log(TotalDurationFaceLog2_200s + 1.0)/FrequencyFace2_200s as MeanDurationFaceLog2_200s,
   		FrequencyFace2_200s
		from Face_2_200s_sub;
quit;


proc sql; 
	create table Keyboard_2_200s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboardLog2_200s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_2_200s as
   	select Dyad, log(TotalDurationKeyboardLog2_200s + 1.0) as TotalDurationKeyboardLog2_200s ,
   		log(TotalDurationKeyboardLog2_200s + 1.0)/FrequencyKeyboard2_200s as MeanDurationKeyboardLog2_200s,
   		FrequencyKeyboard2_200s
		from Keyboard_2_200s_sub;
quit;


proc sql; 
	create table Monitor_2_200s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitorLog2_200s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Monitor_2_200s as
   	select Dyad, log(TotalDurationMonitorLog2_200s + 1.0) as TotalDurationMonitorLog2_200s ,
   		log(TotalDurationMonitorLog2_200s + 1.0)/FrequencyMonitor2_200s as MeanDurationMonitorLog2_200s,
   		FrequencyMonitor2_200s
		from Monitor_2_200s_sub;
quit;


/*Join all the gaze data together*/
proc sql;
	create table Summary_2 as 
	select F0.*, M0.*, K0.*, A0.*, F2.*, M2.*, K2.*, A2.* 
		from WORK.Face_2_0s F0	
		full join WORK.Monitor_2_0s M0 on F0.Dyad = M0.Dyad
		full join WORK.Keyboard_2_0s K0 on F0.Dyad = K0.Dyad
		full join WORK.Around_2_0s A0 on F0.Dyad = A0.Dyad

		full join WORK.Face_2_200s F2 on F0.Dyad = F2.Dyad
		full join WORK.Monitor_2_200s M2 on F0.Dyad = M2.Dyad
		full join WORK.Keyboard_2_200s K2 on F0.Dyad = K2.Dyad
		full join WORK.Around_2_200s A2 on F0.Dyad = A2.Dyad;
quit;	


/*Combine dyad 1 and dyad 2 together*/

proc sql;
	create table Summary as 
	select D1.*, D2.* 
		from WORK.Summary_1 D1	
		full join WORK.Summary_2 D2 on D1.Dyad = D2.Dyad;
quit;	


/*set all null value to 0*/
data Summary;
	set Summary;
	array change _numeric_;
		do over change;
			if change=. then change=0;
		end;
run;

/*check abnormaly*/

proc sql;
	create table Summary_Diff as 
	select Dyad,(TotalDurationAroundLog1_0s-TotalDurationAroundLog1_200s)**2 as DuA_1S_1E,
   				(TotalDurationAroundLog2_0s-TotalDurationAroundLog2_200s)**2 as DuA_2S_2E,
   				(TotalDurationAroundLog1_0s-TotalDurationAroundLog2_0s)**2 as DuA_1S_2S,
				(TotalDurationAroundLog1_200s-TotalDurationAroundLog2_0s)**2 as DuA_1E_2S,
   				(TotalDurationAroundLog1_200s-TotalDurationAroundLog2_200s)**2 as DuA_1E_2E,
   		
   				(TotalDurationFaceLog1_0s-TotalDurationFaceLog1_200s)**2 as DuF_1S_1E,
   				(TotalDurationFaceLog2_0s-TotalDurationFaceLog2_200s)**2 as DuF_2S_2E,
   				(TotalDurationFaceLog1_0s-TotalDurationFaceLog2_0s)**2 as DuF_1S_2S,
   				(TotalDurationFaceLog1_200s-TotalDurationFaceLog2_0s)**2 as DuF_1E_2S,
   				(TotalDurationFaceLog1_200s-TotalDurationFaceLog2_200s)**2 as DuF_1E_2E,
   			
				(MeanDurationAroundLog1_0s-MeanDurationAroundLog1_200s)**2 as AvA_1S_1E,
				(MeanDurationAroundLog2_0s-MeanDurationAroundLog2_200s)**2 as AvA_2S_2E,
				(MeanDurationAroundLog1_0s-MeanDurationAroundLog2_0s)**2 as AvA_1S_2S,
				(MeanDurationAroundLog1_200s-MeanDurationAroundLog2_0s)**2 as AvA_1E_2S,
				(MeanDurationAroundLog1_200s-MeanDurationAroundLog2_200s)**2 as AvA_1E_2E,
			
				(MeanDurationFaceLog1_0s-MeanDurationFaceLog1_200s)**2 as AvF_1S_1E,
				(MeanDurationFaceLog2_0s-MeanDurationFaceLog2_200s) **2 as AvF_2S_2E,
				(MeanDurationFaceLog1_0s-MeanDurationFaceLog2_0s) **2 as AvF_1S_2S,
				(MeanDurationFaceLog1_200s-MeanDurationFaceLog2_0s) **2 as AvF_1E_1S,
				(MeanDurationFaceLog1_200s-MeanDurationFaceLog2_200s) **2 as AvF_1E_2E
			
		from Summary;
quit;	



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
