/*DO NOT HAVE EXPORT CSV IN THIS FILE*/

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_combine/DiscriptiveData_4gazes_100sec.csv';
FILENAME Outgaze '/folders/myfolders/gaze analysys/data_combine/SummaryGaze_100s_all.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT
	REPLACE;
	GETNAMES=YES;	
RUN;


PROC CONTENTS DATA=WORK.IMPORT; RUN;

/* -----------------get data for conversation 1-----------------------*/
data Gaze1;
   set WORK.IMPORT (keep = Dyad Cov SectionStartTime Duration GazeType);
	where Cov = 1;
run;


/*
Get the total, mean, and frequency of the four gaze
Divide to 1.0 to get the time to float

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_1_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationAround1_0s,
   		mean(Duration) / 1.0 as MeanDurationAround1_0s,
   		count(*) as FrequencyAround1_0s
		from WORK.Gaze1
		where GazeType = 1 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Monitor_1_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationMonitor1_0s,
   		mean(Duration) / 1.0 as MeanDurationMonitor1_0s,
   		count(*) as FrequencyMonitor1_0s
		from WORK.Gaze1
		where GazeType = 2 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationKeyboard1_0s,
   		mean(Duration) / 1.0 as MeanDurationKeyboard1_0s,
   		count(*) as FrequencyKeyboard1_0s
		from WORK.Gaze1
		where GazeType = 3 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Face_1_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationFace1_0s,
   		mean(Duration) / 1.0 as MeanDurationFace1_0s,
   		count(*) as FrequencyFace1_0s
		from WORK.Gaze1
		where GazeType = 4 and SectionStartTime = 0
		group by Dyad;
quit;

/*---------------------------get the gaze data for the last 100 seconds----------------------------*/
proc sql; 
	create table Around_1_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationAround1_200s,
   		mean(Duration) / 1.0 as MeanDurationAround1_200s,
   		count(*) as FrequencyAround1_200s
		from WORK.Gaze1
		where GazeType = 1 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Monitor_1_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationMonitor1_200s,
   		mean(Duration) / 1.0 as MeanDurationMonitor1_200s,
   		count(*) as FrequencyMonitor1_200s
		from WORK.Gaze1
		where GazeType = 2 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationKeyboard1_200s,
   		mean(Duration) / 1.0 as MeanDurationKeyboard1_200s,
   		count(*) as FrequencyKeyboard1_200s
		from WORK.Gaze1
		where GazeType = 3 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Face_1_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationFace1_200s,
   		mean(Duration) / 1.0 as MeanDurationFace1_200s,
   		count(*) as FrequencyFace1_200s
		from WORK.Gaze1
		where GazeType = 4 and SectionStartTime = 6000
		group by Dyad;
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

/*set all the null value to 0*/
data Summary_1;
	set Summary_1; /*read an observation (row)*/
	array a(*) _numeric_; /*turm the row into an array*/
	do i=1 to dim(a); /*go through the array, find and change null to 0*/
	if a(i) = . then a(i) = 0;
	end;
	drop i;
/* -----------------get data for conversation 2-----------------------*/
data Gaze2;
   set WORK.IMPORT (keep = Dyad Cov SectionStartTime Duration GazeType);
	where Cov = 2;
run;


/*
Get the total, mean, and frequency of the four gaze
Divide to 1.0 to get the time in second

Gaze Type ID:
Around = 1
Monitor = 2
Keyboard = 3
Face = 4
*/

/*---------------------------get the gaze data for the first 100 seconds----------------------------*/
proc sql; 
	create table Around_2_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationAround2_0s,
   		mean(Duration) / 1.0 as MeanDurationAround2_0s,
   		count(*) as FrequencyAround2_0s
		from WORK.Gaze2
		where GazeType = 1 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Monitor_2_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationMonitor2_0s,
   		mean(Duration) / 1.0 as MeanDurationMonitor2_0s,
   		count(*) as FrequencyMonitor2_0s
		from WORK.Gaze2
		where GazeType = 2 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationKeyboard2_0s,
   		mean(Duration) / 1.0 as MeanDurationKeyboard2_0s,
   		count(*) as FrequencyKeyboard2_0s
		from WORK.Gaze2
		where GazeType = 3 and SectionStartTime = 0
		group by Dyad;
quit;

proc sql;
	create table Face_2_0s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationFace2_0s,
   		mean(Duration) / 1.0 as MeanDurationFace2_0s,
   		count(*) as FrequencyFace2_0s
		from WORK.Gaze2
		where GazeType = 4 and SectionStartTime = 0
		group by Dyad;
quit;

/*---------------------------get the gaze data for the last 100 seconds----------------------------*/
proc sql; 
	create table Around_2_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationAround2_200s,
   		mean(Duration) / 1.0 as MeanDurationAround2_200s,
   		count(*) as FrequencyAround2_200s
		from WORK.Gaze2
		where GazeType = 1 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Monitor_2_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationMonitor2_200s,
   		mean(Duration) / 1.0 as MeanDurationMonitor2_200s,
   		count(*) as FrequencyMonitor2_200s
		from WORK.Gaze2
		where GazeType = 2 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationKeyboard2_200s,
   		mean(Duration) / 1.0 as MeanDurationKeyboard2_200s,
   		count(*) as FrequencyKeyboard2_200s
		from WORK.Gaze2
		where GazeType = 3 and SectionStartTime = 6000
		group by Dyad;
quit;

proc sql;
	create table Face_2_200s as
   	select Dyad, sum(Duration) / 1.0 as TotalDurationFace2_200s,
   		mean(Duration) / 1.0 as MeanDurationFace2_200s,
   		count(*) as FrequencyFace2_200s
		from WORK.Gaze2
		where GazeType = 4 and SectionStartTime = 6000
		group by Dyad;
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

/*set all the null value to 0*/
data Summary_2;
	set Summary_2; /*read an observation (row)*/
	array a(*) _numeric_; /*turm the row into an array*/
	do i=1 to dim(a); /*go through the array, find and change null to 0*/
	if a(i) = . then a(i) = 0;
	end;
	drop i;
	
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