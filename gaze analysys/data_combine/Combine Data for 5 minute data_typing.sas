/*THIS FILE WILL GIVE YOU THE CSV DATA*/

libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_combine/DiscriptiveData_5talks_H_5mins.csv';


FILENAME Outtype '/folders/myfolders/gaze analysys/data_combine/SummaryTyping5min.csv';

%LET talk=2;

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;

/*get the typing data alone*/
/*change TalkType for different characteristics of Talk*/
data Typing_sub_1;
	set WORK.IMPORT1 (keep = Dyad -- TalkType);
	where TalkType = &talk;
run;

proc sql; 
	create table Typing_sub_2 as
   	select Dyad, Cov,  
   		sum(Duration) as Duration,
   		count(*) as Frequency
		from Typing_sub_1
		group by Dyad, Cov ;
quit;
proc sql; 
	create table Typing_sub_3 as
   	select Dyad, Cov, Duration as Duration,
   		Duration*1.0/Frequency as Mean,
   		Frequency
		from Typing_sub_2;
quit;

proc sql;
	create table Typing_1 as
   	select Dyad, Duration as Duration_1_0s,
   		Mean as Mean_1_0s, Frequency as Frequency_1_0s 
		from Typing_sub_3
		where Cov = 1 ;

proc sql;
	create table Typing_2 as
   	select Dyad, Duration as Duration_2_0s,
   		Mean as Mean_2_0s, Frequency as Frequency_2_0s 
		from Typing_sub_3
		where Cov = 2 ;

proc sql;
	create table Typing as 
	select T1.*, T2.* 
		from Typing_1 T1	
		full join Typing_2 T2 on T1.Dyad = T2.Dyad;

quit;	


/*exporting data*/
proc export data= Typing
outfile=Outtype
dbms=csv
replace;
run;


