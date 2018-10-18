/*THIS FILE WILL GIVE YOU THE CSV DATA*/

libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_combine/DiscriptiveData_5talks_H_100sec.csv';

FILENAME Outgaze '/folders/myfolders/gaze analysys/data_combine/SummaryGaze.csv';

FILENAME Outtype '/folders/myfolders/gaze analysys/data_combine/SummaryTyping.csv';

%LET talk=2;

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

data WORK.IMPORT;
	set WORK.IMPORT1 (keep = Dyad -- S_BodyOnly_Min);
	where TalkType = &talk;
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
   		sum(S_Around_Overall_Time) as TotalDurationAround1_0s,
   		sum(S_Around_Frequency) as FrequencyAround1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Around_1_0s as
   	select Dyad, TotalDurationAround1_0s as TotalDurationAround1_0s ,
   		TotalDurationAround1_0s*1.0/FrequencyAround1_0s as MeanDurationAround1_0s,
   		FrequencyAround1_0s
		from Around_1_0s_sub;
quit;


proc sql; 
	create table Face_1_0s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFace1_0s,
   		sum(S_Face_Frequency) as FrequencyFace1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Face_1_0s as
   	select Dyad, TotalDurationFace1_0s as TotalDurationFace1_0s ,
   		TotalDurationFace1_0s*1.0/FrequencyFace1_0s as MeanDurationFace1_0s,
   		FrequencyFace1_0s
		from Face_1_0s_sub;
quit;


proc sql; 
	create table Keyboard_1_0s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboard1_0s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_1_0s as
   	select Dyad, TotalDurationKeyboard1_0s as TotalDurationKeyboard1_0s ,
   		TotalDurationKeyboard1_0s*1.0/FrequencyKeyboard1_0s as MeanDurationKeyboard1_0s,
   		FrequencyKeyboard1_0s
		from Keyboard_1_0s_sub;
quit;


proc sql; 
	create table Monitor_1_0s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitor1_0s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor1_0s
		from WORK.Gaze1
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Monitor_1_0s as
   	select Dyad, TotalDurationMonitor1_0s as TotalDurationMonitor1_0s ,
   		TotalDurationMonitor1_0s*1.0/FrequencyMonitor1_0s as MeanDurationMonitor1_0s,
   		FrequencyMonitor1_0s
		from Monitor_1_0s_sub;
quit;


/*---------------------------get the gaze data for the last 100 seconds----------------------------*/

proc sql; 
	create table Around_1_200s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAround1_200s,
   		sum(S_Around_Frequency) as FrequencyAround1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Around_1_200s as
   	select Dyad, TotalDurationAround1_200s as TotalDurationAround1_200s ,
   		TotalDurationAround1_200s*1.0/FrequencyAround1_200s as MeanDurationAround1_200s,
   		FrequencyAround1_200s
		from Around_1_200s_sub;
quit;


proc sql; 
	create table Face_1_200s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFace1_200s,
   		sum(S_Face_Frequency) as FrequencyFace1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Face_1_200s as
   	select Dyad, TotalDurationFace1_200s as TotalDurationFace1_200s ,
   		TotalDurationFace1_200s*1.0/FrequencyFace1_200s as MeanDurationFace1_200s,
   		FrequencyFace1_200s
		from Face_1_200s_sub;
quit;


proc sql; 
	create table Keyboard_1_200s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboard1_200s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_1_200s as
   	select Dyad, TotalDurationKeyboard1_200s as TotalDurationKeyboard1_200s ,
   		TotalDurationKeyboard1_200s*1.0/FrequencyKeyboard1_200s as MeanDurationKeyboard1_200s,
   		FrequencyKeyboard1_200s
		from Keyboard_1_200s_sub;
quit;


proc sql; 
	create table Monitor_1_200s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitor1_200s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor1_200s
		from WORK.Gaze1
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Monitor_1_200s as
   	select Dyad, TotalDurationMonitor1_200s as TotalDurationMonitor1_200s ,
   		TotalDurationMonitor1_200s*1.0/FrequencyMonitor1_200s as MeanDurationMonitor1_200s,
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
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAround2_0s,
   		sum(S_Around_Frequency) as FrequencyAround2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Around_2_0s as
   	select Dyad, TotalDurationAround2_0s as TotalDurationAround2_0s ,
   		TotalDurationAround2_0s*1.0/FrequencyAround2_0s as MeanDurationAround2_0s,
   		FrequencyAround2_0s
		from Around_2_0s_sub;
quit;


proc sql; 
	create table Face_2_0s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFace2_0s,
   		sum(S_Face_Frequency) as FrequencyFace2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Face_2_0s as
   	select Dyad, TotalDurationFace2_0s as TotalDurationFace2_0s ,
   		TotalDurationFace2_0s*1.0/FrequencyFace2_0s as MeanDurationFace2_0s,
   		FrequencyFace2_0s
		from Face_2_0s_sub;
quit;


proc sql; 
	create table Keyboard_2_0s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboard2_0s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_2_0s as
   	select Dyad, TotalDurationKeyboard2_0s as TotalDurationKeyboard2_0s ,
   		TotalDurationKeyboard2_0s*1.0/FrequencyKeyboard2_0s as MeanDurationKeyboard2_0s,
   		FrequencyKeyboard2_0s
		from Keyboard_2_0s_sub;
quit;


proc sql; 
	create table Monitor_2_0s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitor2_0s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor2_0s
		from WORK.Gaze2
		where SectionStartTime = 0
		group by Dyad;
quit;
proc sql; 
	create table Monitor_2_0s as
   	select Dyad, TotalDurationMonitor2_0s as TotalDurationMonitor2_0s ,
   		TotalDurationMonitor2_0s*1.0/FrequencyMonitor2_0s as MeanDurationMonitor2_0s,
   		FrequencyMonitor2_0s
		from Monitor_2_0s_sub;
quit;


/*---------------------------get the gaze data for the last 100 seconds----------------------------*/

proc sql; 
	create table Around_2_200s_sub as
   	select Dyad, 
   		sum(S_Around_Mean*S_Around_Frequency) as TotalDurationAround2_200s,
   		sum(S_Around_Frequency) as FrequencyAround2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Around_2_200s as
   	select Dyad, TotalDurationAround2_200s as TotalDurationAround2_200s ,
   		TotalDurationAround2_200s*1.0/FrequencyAround2_200s as MeanDurationAround2_200s,
   		FrequencyAround2_200s
		from Around_2_200s_sub;
quit;


proc sql; 
	create table Face_2_200s_sub as
   	select Dyad, 
   		sum(S_Face_Mean*S_Face_Frequency) as TotalDurationFace2_200s,
   		sum(S_Face_Frequency) as FrequencyFace2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Face_2_200s as
   	select Dyad, TotalDurationFace2_200s as TotalDurationFace2_200s ,
   		TotalDurationFace2_200s*1.0/FrequencyFace2_200s as MeanDurationFace2_200s,
   		FrequencyFace2_200s
		from Face_2_200s_sub;
quit;


proc sql; 
	create table Keyboard_2_200s_sub as
   	select Dyad, 
   		sum(S_Keyboard_Mean*S_Keyboard_Frequency) as TotalDurationKeyboard2_200s,
   		sum(S_Keyboard_Frequency) as FrequencyKeyboard2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Keyboard_2_200s as
   	select Dyad, TotalDurationKeyboard2_200s as TotalDurationKeyboard2_200s ,
   		TotalDurationKeyboard2_200s*1.0/FrequencyKeyboard2_200s as MeanDurationKeyboard2_200s,
   		FrequencyKeyboard2_200s
		from Keyboard_2_200s_sub;
quit;


proc sql; 
	create table Monitor_2_200s_sub as
   	select Dyad, 
   		sum(S_Monitor_Mean*S_Monitor_Frequency) as TotalDurationMonitor2_200s,
   		sum(S_Monitor_Frequency) as FrequencyMonitor2_200s
		from WORK.Gaze2
		where SectionStartTime = 6000
		group by Dyad;
quit;
proc sql; 
	create table Monitor_2_200s as
   	select Dyad, TotalDurationMonitor2_200s as TotalDurationMonitor2_200s ,
   		TotalDurationMonitor2_200s*1.0/FrequencyMonitor2_200s as MeanDurationMonitor2_200s,
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
outfile= Outgaze
dbms=csv
replace;
run;

/*get the typing data alone*/
/*change TalkType for different characteristics of Talk*/
data Typing_sub_1;
	set WORK.IMPORT1 (keep = Dyad -- TalkType);
	where TalkType = &talk;
run;

proc sql; 
	create table Typing_sub_2 as
   	select Dyad, Cov, SectionStartTime, 
   		sum(Duration) as Duration,
   		count(*) as Frequency
		from Typing_sub_1
		group by Dyad, Cov, SectionStartTime ;
quit;
proc sql; 
	create table Typing_sub_3 as
   	select Dyad, Cov, SectionStartTime, Duration as Duration,
   		Duration*1.0/Frequency as Mean,
   		Frequency
		from Typing_sub_2;
quit;

proc sql;
	create table Typing_1_0s as
   	select Dyad, Duration as Duration_1_0s,
   		Mean as Mean_1_0s, Frequency as Frequency_1_0s 
		from Typing_sub_3
		where Cov = 1 and SectionStartTime = 0;
proc sql;
	create table Typing_1_200s as
   	select Dyad, Duration as Duration_1_200s,
   		Mean as Mean_1_200s, Frequency as Frequency_1_200s 
		from Typing_sub_3
		where Cov = 1 and SectionStartTime = 6000;
proc sql;
	create table Typing_2_0s as
   	select Dyad, Duration as Duration_2_0s,
   		Mean as Mean_2_0s, Frequency as Frequency_2_0s 
		from Typing_sub_3
		where Cov = 2 and SectionStartTime = 0;
proc sql;
	create table Typing_2_200s as
   	select Dyad, Duration as Duration_2_200s,
   		Mean as Mean_2_200s, Frequency as Frequency_2_200s 
		from Typing_sub_3
		where Cov = 2 and SectionStartTime = 6000;

proc sql;
	create table Typing as 
	select T10.*, T12.*, T20.*, T22.* 
		from Typing_1_0s T10	
		full join Typing_1_200s T12 on T10.Dyad = T12.Dyad
		full join Typing_2_0s T20 on T10.Dyad = T20.Dyad
		full join Typing_2_200s T22 on T10.Dyad = T22.Dyad;

quit;	


/*exporting data*/
proc export data= Typing
/*outfile='/folders/myfolders/gaze analysys/data_combine/SummaryTyping.csv'*/
outfile=Outtype
dbms=csv
replace;
run;


proc sql; 
	create table Typing_total as
   	select Cov, SectionStartTime, mean(Duration) as AveTotal,
   		std (Duration) as SD
		from Typing_sub_3
		group by Cov, SectionStartTime;
quit;

proc sql; 
	create table Typing_mean as
   	select Cov, SectionStartTime, mean(Mean) as AveMean,
   		std (Mean) as SD
		from Typing_sub_3
		group by Cov, SectionStartTime;
quit;
