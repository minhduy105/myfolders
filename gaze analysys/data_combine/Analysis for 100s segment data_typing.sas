/*THIS FILE WILL GIVE YOU THE CSV DATA*/

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
   		sum(S_Around_Overall_Time) as TotalDurationAroundLog1_0s,
   		sum(S_Around_Frequency) as FrequencyAround1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Around_1_0s as
   	select Dyad, TotalDurationAroundLog1_0s as TotalDurationAroundLog1_0s ,
   		TotalDurationAroundLog1_0s*1.0/FrequencyAround1_0s as MeanDurationAroundLog1_0s,
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
   	select Dyad, TotalDurationFaceLog1_0s as TotalDurationFaceLog1_0s ,
   		TotalDurationFaceLog1_0s*1.0/FrequencyFace1_0s as MeanDurationFaceLog1_0s,
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
   	select Dyad, TotalDurationKeyboardLog1_0s as TotalDurationKeyboardLog1_0s ,
   		TotalDurationKeyboardLog1_0s*1.0/FrequencyKeyboard1_0s as MeanDurationKeyboardLog1_0s,
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
   	select Dyad, TotalDurationMonitorLog1_0s as TotalDurationMonitorLog1_0s ,
   		TotalDurationMonitorLog1_0s*1.0/FrequencyMonitor1_0s as MeanDurationMonitorLog1_0s,
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
   	select Dyad, TotalDurationAroundLog1_200s as TotalDurationAroundLog1_200s ,
   		TotalDurationAroundLog1_200s*1.0/FrequencyAround1_200s as MeanDurationAroundLog1_200s,
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
   	select Dyad, TotalDurationFaceLog1_200s as TotalDurationFaceLog1_200s ,
   		TotalDurationFaceLog1_200s*1.0/FrequencyFace1_200s as MeanDurationFaceLog1_200s,
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
   	select Dyad, TotalDurationKeyboardLog1_200s as TotalDurationKeyboardLog1_200s ,
   		TotalDurationKeyboardLog1_200s*1.0/FrequencyKeyboard1_200s as MeanDurationKeyboardLog1_200s,
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
   	select Dyad, TotalDurationMonitorLog1_200s as TotalDurationMonitorLog1_200s ,
   		TotalDurationMonitorLog1_200s*1.0/FrequencyMonitor1_200s as MeanDurationMonitorLog1_200s,
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

/*set all null value to 0*/
data Summary_1;
	set Summary_1;
	array change _numeric_;
		do over change;
			if change=. then change=0;
		end;
run;


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
   	select Dyad, TotalDurationAroundLog2_0s as TotalDurationAroundLog2_0s ,
   		TotalDurationAroundLog2_0s*1.0/FrequencyAround2_0s as MeanDurationAroundLog2_0s,
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
   	select Dyad, TotalDurationFaceLog2_0s as TotalDurationFaceLog2_0s ,
   		TotalDurationFaceLog2_0s*1.0/FrequencyFace2_0s as MeanDurationFaceLog2_0s,
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
   	select Dyad, TotalDurationKeyboardLog2_0s as TotalDurationKeyboardLog2_0s ,
   		TotalDurationKeyboardLog2_0s*1.0/FrequencyKeyboard2_0s as MeanDurationKeyboardLog2_0s,
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
   	select Dyad, TotalDurationMonitorLog2_0s as TotalDurationMonitorLog2_0s ,
   		TotalDurationMonitorLog2_0s*1.0/FrequencyMonitor2_0s as MeanDurationMonitorLog2_0s,
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
   	select Dyad, TotalDurationAroundLog2_200s as TotalDurationAroundLog2_200s ,
   		TotalDurationAroundLog2_200s*1.0/FrequencyAround2_200s as MeanDurationAroundLog2_200s,
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
   	select Dyad, TotalDurationFaceLog2_200s as TotalDurationFaceLog2_200s ,
   		TotalDurationFaceLog2_200s*1.0/FrequencyFace2_200s as MeanDurationFaceLog2_200s,
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
   	select Dyad, TotalDurationKeyboardLog2_200s as TotalDurationKeyboardLog2_200s ,
   		TotalDurationKeyboardLog2_200s*1.0/FrequencyKeyboard2_200s as MeanDurationKeyboardLog2_200s,
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
   	select Dyad, TotalDurationMonitorLog2_200s as TotalDurationMonitorLog2_200s ,
   		TotalDurationMonitorLog2_200s*1.0/FrequencyMonitor2_200s as MeanDurationMonitorLog2_200s,
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


/*exporting data*/
proc export data= SUMMARY
outfile='/folders/myfolders/gaze analysys/Summary.csv'
dbms=csv
replace;
run;
