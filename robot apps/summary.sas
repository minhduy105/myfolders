
libname sql 'SAS-library';

FILENAME REFFILE '/folders/myfolders/robot apps/SFI.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT
	REPLACE;
	GETNAMES=YES;	
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

proc sql;
	create table Coded as
   	select Participant_number as P_ID, Dialogue_number as D_ID, Setting, Gender, Age, 
   		VAR7 as Q1, Proficiency_in_Swedish as Q2, How_well_do_you_know_the_other_p as Q3,
   		The_robot_asked_one_learner_ques as P1, _Learner_learner_conversation as P2,
   		_The_robot_talked_about_a_topic as P3, Conversation_between_all_three as P4,
   		Rate_the_session_from_a_learning as R1, How_friendly_was_the_robot as R2,
   		Personal_was_the_robot as R3, Who_had_the_initiative_in_the_di as R4,
   		Rate_the_robot_s_behaviour_as_a as R5, Describe_the_robot_s_behaviour_a as R6, 
   		(R1 + R2 + R3 + R5 + R6) as R7
		from WORK.IMPORT
	where Setting in ("interviewer","facilitator","moderator","narrator");
quit;

proc sql; /*adding new column*/
      alter table Coded
      ADD Prop1 char format = $2.
      ADD Prop2 char format = $2.
      ADD Prop3 char format = $2.
      ADD Prop4 char format = $2.;
   update Coded
   set Prop1='P1', Prop2='P2', Prop3='P3', Prop4='P4'; /*set initial values for those column*/
quit;

proc sql;/*create new table for box-plot*/
create table Box_plot_table as 
	select P_ID, D_ID, Gender, Prop1 as Proportion, Setting, P1 as Value from Coded 
	union 
	select P_ID, D_ID, Gender, Prop2, Setting, P2  from Coded
	union 
	select P_ID, D_ID, Gender, Prop3, Setting, P3  from Coded
	union 
	select P_ID, D_ID, Gender, Prop4, Setting,  P4  from Coded
;
quit;



proc sql;
	create table CodedMean as
   	select Setting, mean(P1) as P1, mean(P2) as P2, mean(P3) as P3, mean(P4) as P4,count(*) as Count
		from Coded
		group by Setting;
quit;

proc sql;
	create table CodedMeanM as
   	select Setting, mean(P1) as P1, mean(P2) as P2, mean(P3) as P3, mean(P4) as P4,count(*) as Count
		from Coded
		where Gender = 'Male'
		group by Setting;
quit;

proc sql;
	create table CodedMeanF as
   	select Setting, mean(P1) as P1, mean(P2) as P2, mean(P3) as P3, mean(P4) as P4,count(*) as Count
		from Coded
		where Gender = 'Female'
		group by Setting;
quit;

title"Total";
proc sgplot data=Box_plot_Table;
  vbox Value / category=Proportion group=Setting groupdisplay=cluster;
  YAXIS LABEL = 'Percentage (%)';
  run;  

title"Male";
proc sgplot data=Box_plot_Table;
  where Gender in ('Male');
  vbox Value / category=Proportion group=Setting groupdisplay=cluster;
  YAXIS LABEL = 'Percentage (%)';
  run;  

title"Female";
proc sgplot data=Box_plot_Table;
  where Gender in ('Female');
  vbox Value / category=Proportion group=Setting groupdisplay=cluster;
  YAXIS LABEL = 'Percentage (%)';
  run;  

 
proc corr data=Coded;
	var P1--P4;
	with R1--R7;
	run;
	

proc sql;
	create table Coded_M as
   	select *
		from Coded
	where Gender = 'Male';
quit;

proc sql;
	create table Coded_F as
   	select *
		from Coded
	where Gender = 'Female';
quit;

proc corr data=Coded_M;
	var P1--P4;
	with R1--R7;
	run;

proc corr data=Coded_F;
	var P1--P4;
	with R1--R7;
	run;
	
proc corr data=Coded;
	var R1--R6;
	run;

proc corr data=Coded_M;
	var R1--R6;
	run;

proc corr data=Coded_F;
	var R1--R6;
	run;


proc factor data=Coded
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var R1--R6;
run;
	
proc factor data=Coded_M
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var R1--R6;
run;

proc factor data=Coded_F
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var R1--R6;
run;
/*
proc sort data=Coded
  out=Sorted_coded;
by Setting;

proc univariate all data=Sorted_coded;
	var  P1 -- P4;
	by Setting;
run;

*/
