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

proc means data=Summary n mean max min range std fw=8; /*fw is field width, which is how big the table is gonna be*/
   var Aver_sia1 Aver_sia2
		Aver_hia1 Aver_hia2;
   title 'Summary of Rapport Rating';
run;


proc ttest data=Summary order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
	paired Aver_sia1 * Aver_sia2
			Aver_hia1 * Aver_hia2
			Aver_hia1 * Aver_sia1
			Aver_hia2 * Aver_sia2
			;
run;

data want;
   set Summary;
   method = 'Aver_sia1'; value=Aver_sia1;output;
   method = 'Aver_hia1'; Value=Aver_hia1;output;
   keep method value;
run;

proc ttest data=want alpha=0.05 cochran ci=equal umpu;
  class method;
  var value;
run;

data want;
   set Summary;
   method = 'Aver_sia2'; value=Aver_sia2;output;
   method = 'Aver_hia2'; Value=Aver_hia2;output;
   keep method value;
run;

proc ttest data=want alpha=0.05 cochran ci=equal umpu;
  class method;
  var value;
run;


proc corr data=Summary;
	var  Aver_sia1 Aver_sia2
		Aver_hia1 Aver_hia2;
run;

proc corr data=Summary;
	var  Aver_sia1 Aver_sia2
		Aver_hia1 Aver_hia2;
	partial hsex ssex;	
run;

proc corr data=Summary;
	var Aver_sia2
		Aver_hia2;
	partial hxboxshorten;	
run;

proc corr data=Summary;
	var  Aver_sia2
		Aver_hia2;
	partial hsex ssex hxboxshorten;	
run;



proc ttest data=Summary alpha=0.05 cochran ci=equal umpu;
	class ssex;
	var Aver_sia1 Aver_sia2;
	run;

proc ttest data=Summary alpha=0.05 cochran ci=equal umpu;
	class hsex;
	var Aver_hia1 Aver_hia2;
	run;


proc glm data=Summary;
	class hxboxshorten;
	model
   		Aver_sia2 Aver_hia2 = hxboxshorten;	
		means hxboxshorten /deponly;
		contrast 'Compare 1st, 2nd & 3rd grps' hxboxshorten -2 -1 3;
		contrast 'Compare 1st, 2nd & 3rd grps, with lower weight on 1st' hxboxshorten -1 -2 3;
		contrast 'Compare 1st & 2nd with 3rd grps' hxboxshorten -3 1 2;
run;




/*--------------------------------Draw plot-box -----------------------------------------------------*/
/*create new column in order to create new table for doing box-plot */
proc sql; /*adding new column*/
      alter table Summary
      ADD AU char format = $2.
      ADD CP char format = $2.
      ADD Cov1 char format = $4.
      ADD Cov2 char format = $4.
      ADD AUN num format = 6.2
      ADD CPN num format = 6.2
      ;
   update Summary
   set AU='AU', CP='CP', Cov1 = 'Con1', Cov2 = 'Con2', AUN = 0, CPN = 1; /*set initial values for those column*/
quit;


proc sql;/*create new table for box-plot, need ID or Union will combine similar value*/
create table Summary_Rapport_Gender_1 as 
	select Dyad, hsex as Gender, AUN as Person, Cov1 as Conversation, Aver_hia1 as Rapport from Summary
	union
	select Dyad, ssex, CPN,Cov1, Aver_sia1  from Summary
;
quit;

proc ttest data=Summary_Rapport_Gender_1 alpha=0.05 cochran ci=equal umpu;
  class Gender;
  var Rapport;
run;

proc sql;/*create new table for box-plot, need ID or Union will combine similar value*/
create table Summary_Rapport_Gender_2 as 
	select Dyad, hsex as Gender, AUN as Person, Cov2 as Conversation, Aver_hia2 as Rapport from Summary
	union
	select Dyad, ssex, CPN, Cov2, Aver_sia2  from Summary;
quit;

proc ttest data=Summary_Rapport_Gender_2 alpha=0.05 cochran ci=equal umpu;
  class Gender;
  var Rapport;
run;


proc glm data=Summary_Rapport_Gender_2;
	class Gender Person;
	model
   		Rapport = Gender Person Gender*Person / ss1 ss2 ss3;	
run;

proc sql;/*create new table for box-plot, need ID or Union will combine similar value*/
create table Summary_box_plot as 
	select Dyad, AU as Person, Cov1 as Conversation, Aver_hia1 as Rapport from Summary
	union
	select Dyad, AU, Cov2, Aver_hia2  from Summary
	union
	select Dyad, CP, Cov1, Aver_sia1  from Summary
	union
	select Dyad, CP, Cov2, Aver_sia2  from Summary;
quit;

title 'Box Plot for Rapport Rating between AAC users(AU) and their communicative partner (CP) in Dyad 1 and 2';
proc sgplot data=Summary_box_plot;
  vbox Rapport / category=Person group=Conversation groupdisplay=cluster;
  YAXIS LABEL = 'Rapport';
  run;

