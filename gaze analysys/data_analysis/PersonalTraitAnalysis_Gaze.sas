libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/LogTimeDiff.csv';
/*This is for the normal time*/
/*FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/NormalTimeDiff.csv';*/


PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;


/*set all null value to 0*/

data WORK.IMPORT1;
	set WORK.IMPORT1;
	array change _numeric_;
		do over change;
			if change=. then change=0;
		end;
run;

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/PersonalWithRapport.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT2
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT2; RUN;


/*Join all the gaze data together*/
proc sql;
	create table Summary_sub as 
	select Gaze.*, Char.* 
		from WORK.IMPORT1 Gaze	
		inner join WORK.IMPORT2 Char on Gaze.Dyad = Char.hdyad;
quit;	

/* 
0 is male (H) - male (S)
1 is male (H) - female (S)
2 is female (H) - make (S)
3 is female (H) - female (S)
*/

proc sql; 
	create table Summary_1 as
   	select *, (hsex * 2) + ssex as BothSex
   		from WORK.Summary_sub;
quit;

proc sql;
	create table Summary as
	select *, hxboxexp + hkeyexp as htechexposure,
			case
			when hxboxexp <= 2 then 2
			when hxboxexp >= 4 then 4
            else 3
            end as hxboxshorten,
            case
			when hkeyexp <= 3 then 3
            end as hkeyshorten
      from Summary_1;
quit;


/*analysis the data*/

proc corr data=Summary plots=scatter;
	var  Aver_sia2  Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   			
   			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
run;

proc corr data=Summary plots=scatter;
	var  Aver_sia1 Aver_hia1 ;
	with TotalDurationAround1_0s TotalDurationAround1_200s
   			TotalDurationAround2_0s TotalDurationAround2_200s 
   			
   			TotalDurationFace1_0s TotalDurationFace1_200s
   			TotalDurationFace2_0s TotalDurationFace2_200s

   			MeanDurationAround1_0s MeanDurationAround1_200s 
			MeanDurationAround2_0s MeanDurationAround2_200s

			MeanDurationFace1_0s MeanDurationFace1_200s
			MeanDurationFace2_0s MeanDurationFace2_200s ;
run;

/*
proc corr data=Summary plots=scatter;
	var  Aver_sia2  Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   			
   			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
	partial hsex;

run;

proc corr data=Summary plots=scatter;
	var  Aver_sia1 Aver_hia1 ;
	with TotalDurationAround1_0s TotalDurationAround1_200s
   			TotalDurationAround2_0s 
   			
   			TotalDurationFace1_0s TotalDurationFace1_200s
   			TotalDurationFace2_0s 

   			MeanDurationAround1_0s MeanDurationAround1_200s 
			MeanDurationAround2_0s 

			MeanDurationFace1_0s MeanDurationFace1_200s
			MeanDurationFace2_0s ;
	partial hsex;
run;


proc corr data=Summary plots=scatter;
	var  Aver_sia2  Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   			
   			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
	partial ssex;

run;

proc corr data=Summary plots=scatter;
	var  Aver_sia1 Aver_hia1 ;
	with TotalDurationAround1_0s TotalDurationAround1_200s
   			TotalDurationAround2_0s 
   			
   			TotalDurationFace1_0s TotalDurationFace1_200s
   			TotalDurationFace2_0s 

   			MeanDurationAround1_0s MeanDurationAround1_200s 
			MeanDurationAround2_0s 

			MeanDurationFace1_0s MeanDurationFace1_200s
			MeanDurationFace2_0s ;
	partial ssex;
run;
*/
proc corr data=Summary plots=scatter;
	var  Aver_sia2  Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   			
   			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
	partial hsex ssex;

run;

proc corr data=Summary plots=scatter;
	var  Aver_sia1 Aver_hia1 ;
	with TotalDurationAround1_0s TotalDurationAround1_200s
   			TotalDurationAround2_0s TotalDurationAround2_200s 
   			
   			TotalDurationFace1_0s TotalDurationFace1_200s
   			TotalDurationFace2_0s TotalDurationFace2_200s

   			MeanDurationAround1_0s MeanDurationAround1_200s 
			MeanDurationAround2_0s MeanDurationAround2_200s

			MeanDurationFace1_0s MeanDurationFace1_200s
			MeanDurationFace2_0s MeanDurationFace2_200s ;
	partial hsex ssex;
run;



proc corr data=Summary;
	var  Aver_sia2 Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   		
   			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
	partial hxboxshorten;
run;

proc corr data=Summary;
	var  Aver_sia2 Aver_hia2;
	with 	TotalDurationAround2_0s TotalDurationAround2_200s
   			
   			TotalDurationFace2_0s TotalDurationFace2_200s
   			
 			MeanDurationAround2_0s MeanDurationAround2_200s
			
			MeanDurationFace2_0s MeanDurationFace2_200s
			;
	partial hsex ssex hxboxshorten;
run;
