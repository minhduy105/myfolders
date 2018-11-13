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

proc sql;
	create table Summary as
	select *, 
			case
			when htechexposure <= 7 then 7
			when htechexposure >= 9 then 9
            else 8
            end as htechshorten
      from Summary;
quit;
	
PROC FREQ DATA=Summary;
  TABLES ssex hxboxexp hkeyexp BothSex hxboxshorten htechexposure htechshorten;
RUN;

proc sql;
	create table Freq_1 as
	select hsex, htechexposure, count(*) as fre
	from Summary
	group by hsex, htechexposure;
quit;

proc sql;
	create table Freq_BothSex as
	select BothSex, count(*) as fre
	from Summary
	group by BothSex;
quit;


proc ttest data=Summary cochran ci=equal umpu;
	class ssex;
	var TotalDurationAround1_0s TotalDurationAround1_200s 
   		TotalDurationAround2_0s TotalDurationAround2_200s 
   			
   		TotalDurationFace1_0s TotalDurationFace1_200s 
   		TotalDurationFace2_0s TotalDurationFace2_200s 
   			   			
		MeanDurationAround1_0s MeanDurationAround1_200s  
		MeanDurationAround2_0s MeanDurationAround2_200s 
			
		MeanDurationFace1_0s MeanDurationFace1_200s 
		MeanDurationFace2_0s MeanDurationFace2_200s;
	run;
	
proc ttest data=Summary cochran ci=equal umpu;
	class ssex;
	var DifTotalDurationAround_1S_1E--DifMeanDurationFace_1E_2S;
	run;
	
	
proc glm data=Summary;
	class hxboxshorten;
	model
   		TotalDurationAround2_0s TotalDurationAround2_200s 
   		TotalDurationFace2_0s TotalDurationFace2_200s 
   			   			
		MeanDurationAround2_0s MeanDurationAround2_200s 
		MeanDurationFace2_0s MeanDurationFace2_200s = hxboxshorten;	
		means hxboxshorten /deponly;
		contrast 'Compare 1st, 2nd & 3rd grps' hxboxshorten -2 -1 3;
		contrast 'Compare 1st, 2nd & 3rd grps, with lower weight on 1st' hxboxshorten -1 -2 3;
		contrast 'Compare 1st & 2nd with 3rd grps' hxboxshorten -3 1 2;
run;


proc glm data=Summary;
	class hxboxshorten;
	model DifTotalDurationAround_1S_1E--DifMeanDurationFace_1E_2S = hxboxshorten;	
	means hxboxshorten /deponly;
	contrast 'Compare 1st with 2nd & 3rd grps' hxboxexp -2 -1 3;
	contrast 'Compare 1st, 2nd & 3rd grps, with lower weight on 1st' hxboxexp -1 -2 3;
	contrast 'Compare 1st & 2nd with 3rd grps' hxboxexp -3 1 2;
run;

/*
		
	
proc glm data=Summary;
	class htechshorten;
	model TotalDurationAround1_0s TotalDurationAround1_200s 
   		TotalDurationAround2_0s TotalDurationAround2_200s 
   			
   		TotalDurationFace1_0s TotalDurationFace1_200s 
   		TotalDurationFace2_0s TotalDurationFace2_200s 
   			   			
		MeanDurationAround1_0s MeanDurationAround1_200s  
		MeanDurationAround2_0s MeanDurationAround2_200s 
			
		MeanDurationFace1_0s MeanDurationFace1_200s 
		MeanDurationFace2_0s MeanDurationFace2_200s = htechshorten;	
		means htechshorten /deponly;
		contrast 'Compare 1st, 2nd & 3rd grps' htechshorten -2 -1 3;
		contrast 'Compare 1st, 2nd & 3rd grps, with lower weight on 1st' htechshorten -1 -2 3;
		contrast 'Compare 1st & 2nd with 3rd grps' htechshorten -3 1 2;
run;


proc glm data=Summary;
	class htechshorten;
	model DifTotalDurationAround_1S_1E--DifMeanDurationFace_1E_2S = htechshorten;	
	means htechshorten /deponly;
	contrast 'Compare 1st with 2nd & 3rd grps' htechshorten -2 -1 3;
	contrast 'Compare 1st, 2nd & 3rd grps, with lower weight on 1st' htechshorten -1 -2 3;
	contrast 'Compare 1st & 2nd with 3rd grps' htechshorten -3 1 2;
run;

	