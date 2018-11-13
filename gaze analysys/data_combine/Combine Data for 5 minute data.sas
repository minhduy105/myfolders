/*DO NOT HAVE EXPORT CSV IN THIS FILE*/
/*For the "fancy" graph at the end, need to be version 9.4 or above to run*/

libname sql 'SAS-library';
FILENAME REFFILE '/folders/myfolders/gaze analysys/data_combine/DiscriptiveData_4gazes_5mins.csv';

FILENAME Outgaze '/folders/myfolders/gaze analysys/data_combine/SummaryGaze5min.csv';



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
   	select Dyad, sum(Duration)  as TotalDurationAround1,
   		mean(Duration)  as MeanDurationAround1,
   		count(*) as FrequencyAround1
		from WORK.Gaze1
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_1 as
   	select Dyad, sum(Duration)  as TotalDurationMonitor1,
   		mean(Duration)  as MeanDurationMonitor1,
   		count(*) as FrequencyMonitor1
		from WORK.Gaze1
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_1 as
   	select Dyad, sum(Duration)  as TotalDurationKeyboard1,
   		mean(Duration)  as MeanDurationKeyboard1,
   		count(*) as FrequencyKeyboard1
		from WORK.Gaze1
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_1 as
   	select Dyad, sum(Duration)  as TotalDurationFace1,
   		mean(Duration)  as MeanDurationFace1,
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
data Summary_1;
	set Summary_1; /*read an observation (row)*/
	array a(*) _numeric_; /*turm the row into an array*/
	do i=1 to dim(a); /*go through the array, find and change null to 0*/
	if a(i) = . then a(i) = 0;
	end;
	drop i;


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
   	select Dyad, sum(Duration)  as TotalDurationAround2,
   		mean(Duration)  as MeanDurationAround2,
   		count(*) as FrequencyAround2
		from WORK.Gaze2
		where GazeType = 1
		group by Dyad;
quit;

proc sql;
	create table Monitor_2 as
   	select Dyad, sum(Duration)  as TotalDurationMonitor2,
   		mean(Duration)  as MeanDurationMonitor2,
   		count(*) as FrequencyMonitor2
		from WORK.Gaze2
		where GazeType = 2
		group by Dyad;
quit;

proc sql;
	create table Keyboard_2 as 
   	select Dyad, sum(Duration)  as TotalDurationKeyboard2,
   		mean(Duration)   as MeanDurationKeyboard2,
   		count(*) as FrequencyKeyboard2
		from WORK.Gaze2
		where GazeType = 3
		group by Dyad;
quit;

proc sql;
	create table Face_2 as
   	select Dyad, sum(Duration)  as TotalDurationFace2,
   		mean(Duration)  as MeanDurationFace2,
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

