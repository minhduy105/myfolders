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

FILENAME REFFILE '/folders/myfolders/gaze analysys/data_analysis/PersonalTraitData.csv';

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
	select *, case
			when hxboxexp <= 2 then 2
			when hxboxexp >= 4 then 4
            else 3
            end as hxboxshorten
      from Summary_1;
quit;
	
PROC FREQ DATA=Summary;
  TABLES ssex hxboxexp BothSex hxboxshorten;
RUN;

proc ttest data=Summary cochran ci=equal umpu;
	class ssex;
	var TotalDurationAroundLog1_0s TotalDurationAroundLog1_200s 
   		TotalDurationAroundLog2_0s TotalDurationAroundLog2_200s 
   			
   		TotalDurationFaceLog1_0s TotalDurationFaceLog1_200s 
   		TotalDurationFaceLog2_0s TotalDurationFaceLog2_200s 
   			   			
		MeanDurationAroundLog1_0s MeanDurationAroundLog1_200s  
		MeanDurationAroundLog2_0s MeanDurationAroundLog2_200s 
			
		MeanDurationFaceLog1_0s MeanDurationFaceLog1_200s 
		MeanDurationFaceLog2_0s MeanDurationFaceLog2_200s;
	run;
	
proc ttest data=Summary cochran ci=equal umpu;
	class ssex;
	var DifTotalDurationAround_1S_1E--DifMeanDurationFace_1E_2S;
	run;
	
proc glm data=Summary;
	class hxboxshorten;
	model TotalDurationAroundLog1_0s TotalDurationAroundLog1_200s 
   		TotalDurationAroundLog2_0s TotalDurationAroundLog2_200s 
   			
   		TotalDurationFaceLog1_0s TotalDurationFaceLog1_200s 
   		TotalDurationFaceLog2_0s TotalDurationFaceLog2_200s 
   			   			
		MeanDurationAroundLog1_0s MeanDurationAroundLog1_200s  
		MeanDurationAroundLog2_0s MeanDurationAroundLog2_200s 
			
		MeanDurationFaceLog1_0s MeanDurationFaceLog1_200s 
		MeanDurationFaceLog2_0s MeanDurationFaceLog2_200s = hxboxexp;	
run;

proc glm data=Summary;
	class hxboxshorten;
	model DifTotalDurationAround_1S_1E--DifMeanDurationFace_1E_2S = hxboxexp;	
run;