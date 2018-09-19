/*----------------------------READING THE EMOTIONAL DATA-----------------------------------------------------------*/


FILENAME REFFILE '/folders/myfolders/gaze analysys/personal trait data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT2; RUN;

proc sql;
create table Rating as
select hdyad as Dyad, hterm as Term, htechint, hcond, hprocadd, hage, hsex, hengspeak, hethnic,	
		hyearosu, hyearsus, hkeyexp, hxboxexp, stechint, scond,	sprocadd, sage,	ssex, sengspeak,
		sethnic, syearosu, syearsus, skeyexp, sxboxexp, srep, srole, ssa1t4 as SSEffort1,
		ssa1m2 as SSIrritation1, ssa1b2 as SSPatient1, ssa1b8 as SSInterested1, ssa1t6 as SSResponsible1,
		ssa1b3 as SSResponsive1, ssa1b2 + ssa1t6 as SSResponsible_Pat1,
		
		ssa2t4 as SSEffort2, ssa2m2 as SSIrritation2, ssa2b2 as SSPatient2, ssa2b8 as SSInterested2, ssa2t6 as SSResponsible2,
		ssa2b3 as SSResponsive2, ssa2b2 + ssa2t6 as SSResponsible_Pat2, 
		
		hpa1t4 as HPEffort1, hpa1m2 as HPIrritation1, hpa1b2 as HPPatient1, hpa1b8 as HPInterested1, hpa1t6 as HPResponsible1,
		hpa1b3 as HPResponsive1, hpa1b2 + ssa1t6 as HPResponsible_Pat1, 
		
		ssa2t4 as HPEffort2, hpa2m2 as HPIrritation2, hpa2b2 as HPPatient2, hpa2b8 as HPInterested2, hpa2t6 as HPResponsible2,
		hpa2b3 as HPResponsive2, hpa2b2 + ssa2t6 as HPResponsible_Pat2
from WORK.IMPORT2;
quit;

/*--------Running t-test ---------------------------------*/

proc ttest data=Rating order=data
           alpha=0.05 test=diff sides=2; /* two-sided test of diff between group means */
   paired SSEffort1*SSEffort2 SSIrritation1*SSIrritation2 SSPatient1*SSPatient2
   		SSInterested1*SSInterested2 SSResponsible1*SSResponsible2 SSResponsive1*SSResponsive2
   		SSResponsible_Pat1*SSResponsible_Pat2
   		HPEffort1*HPEffort2 HPIrritation1*HPIrritation2 HPPatient1*HPPatient2
   		HPInterested1*HPInterested2 HPResponsible1*HPResponsible2 HPResponsive1*HPResponsive2
   		HPResponsible_Pat1*HPResponsible_Pat2;
run;


/*------------Running  correlation test ---------------------------------*/
proc corr data=Rating;
	var	SSEffort1 SSIrritation1 SSPatient1 SSInterested1 SSResponsible1 
		SSResponsive1 SSResponsible_Pat1
		HPEffort2 HPIrritation2 HPPatient2 HPInterested2 HPResponsible2
		HPResponsive2 HPResponsible_Pat2;
	with SSEffort2 SSIrritation2 SSPatient2 SSInterested2 SSResponsible2 
		SSResponsive2 SSResponsible_Pat2
		HPEffort1 HPIrritation1 HPPatient1 HPInterested1 HPResponsible1
		HPResponsive1 HPResponsible_Pat1;  
run;

proc corr data=WORK.IMPORT2;
	var ssa1m1 ssa1m2 ssa1m3 ssa1m4 ssa1m5 ssa1m6 ssa1m7 ssa1m8 ssa1m9 ssa1m10 
		ssa1b1 ssa1b2 ssa1b3 ssa1b4 ssa1b5 ssa1b6 ssa1b7 ssa1b8 ssa1b9 ssa1b10
		ssa1t1 ssa1t2 ssa1t3 ssa1t4 ssa1t5 ssa1t6 ssa1t7 ssa1t8;
run;

proc corr data=WORK.IMPORT2;
	var ssa2m1 ssa2m2 ssa2m3 ssa2m4 ssa2m5 ssa2m6 ssa2m7 ssa2m8 ssa2m9 ssa2m10 
		ssa2b1 ssa2b2 ssa2b3 ssa2b4 ssa2b5 ssa2b6 ssa2b7 ssa2b8 ssa2b9 ssa2b10
		ssa2t1 ssa2t2 ssa2t3 ssa2t4 ssa2t5 ssa2t6 ssa2t7 ssa2t8;
run;

proc corr data=WORK.IMPORT2;
	var hsa1m1 hsa1m2 hsa1m3 hsa1m4 hsa1m5 hsa1m6 hsa1m7 hsa1m8 hsa1m9 hsa1m10 
		hsa1b1 hsa1b2 hsa1b3 hsa1b4 hsa1b5 hsa1b6 hsa1b7 hsa1b8 hsa1b9 hsa1b10
		hsa1t1 hsa1t2 hsa1t3 hsa1t4 hsa1t5 hsa1t6 hsa1t7 hsa1t8;
run;

proc corr data=WORK.IMPORT2;
	var hsa2m1 hsa2m2 hsa2m3 hsa2m4 hsa2m5 hsa2m6 hsa2m7 hsa2m8 hsa2m9 hsa2m10 
		hsa2b1 hsa2b2 hsa2b3 hsa2b4 hsa2b5 hsa2b6 hsa2b7 hsa2b8 hsa2b9 hsa2b10
		hsa2t1 hsa2t2 hsa2t3 hsa2t4 hsa2t5 hsa2t6 hsa2t7 hsa2t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var ssa1m1 ssa1m2 ssa1m3 ssa1m4 ssa1m5 ssa1m6 ssa1m7 ssa1m8 ssa1m9 ssa1m10 
	ssa1b1 ssa1b2 ssa1b3 ssa1b4 ssa1b5 ssa1b6 ssa1b7 ssa1b8 ssa1b9 ssa1b10
	ssa1t1 ssa1t2 ssa1t3 ssa1t4 ssa1t5 ssa1t6 ssa1t7 ssa1t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var ssa2m1 ssa2m2 ssa2m3 ssa2m4 ssa2m5 ssa2m6 ssa2m7 ssa2m8 ssa2m9 ssa2m10 
	ssa2b1 ssa2b2 ssa2b3 ssa2b4 ssa2b5 ssa2b6 ssa2b7 ssa2b8 ssa2b9 ssa2b10
	ssa2t1 ssa2t2 ssa2t3 ssa2t4 ssa2t5 ssa2t6 ssa2t7 ssa2t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var spa1m1 spa1m2 spa1m3 spa1m4 spa1m5 spa1m6 spa1m7 spa1m8 spa1m9 spa1m10 
	spa1b1 spa1b2 spa1b3 spa1b4 spa1b5 spa1b6 spa1b7 spa1b8 spa1b9 spa1b10
	spa1t1 spa1t2 spa1t3 spa1t4 spa1t5 spa1t6 spa1t7 spa1t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var spa2m1 spa2m2 spa2m3 spa2m4 spa2m5 spa2m6 spa2m7 spa2m8 spa2m9 spa2m10 
	spa2b1 spa2b2 spa2b3 spa2b4 spa2b5 spa2b6 spa2b7 spa2b8 spa2b9 spa2b10
	spa2t1 spa2t2 spa2t3 spa2t4 spa2t5 spa2t6 spa2t7 spa2t8;
run;


proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var hsa1m1 hsa1m2 hsa1m3 hsa1m4 hsa1m5 hsa1m6 hsa1m7 hsa1m8 hsa1m9 hsa1m10 
	hsa1b1 hsa1b2 hsa1b3 hsa1b4 hsa1b5 hsa1b6 hsa1b7 hsa1b8 hsa1b9 hsa1b10
	hsa1t1 hsa1t2 hsa1t3 hsa1t4 hsa1t5 hsa1t6 hsa1t7 hsa1t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var hsa2m1 hsa2m2 hsa2m3 hsa2m4 hsa2m5 hsa2m6 hsa2m7 hsa2m8 hsa2m9 hsa2m10 
	hsa2b1 hsa2b2 hsa2b3 hsa2b4 hsa2b5 hsa2b6 hsa2b7 hsa2b8 hsa2b9 hsa2b10
	hsa2t1 hsa2t2 hsa2t3 hsa2t4 hsa2t5 hsa2t6 hsa2t7 hsa2t8;
run;


proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var hpa1m1 hpa1m2 hpa1m3 hpa1m4 hpa1m5 hpa1m6 hpa1m7 hpa1m8 hpa1m9 hpa1m10 
	hpa1b1 hpa1b2 hpa1b3 hpa1b4 hpa1b5 hpa1b6 hpa1b7 hpa1b8 hpa1b9 hpa1b10
	hpa1t1 hpa1t2 hpa1t3 hpa1t4 hpa1t5 hpa1t6 hpa1t7 hpa1t8;
run;

proc factor data=WORK.import2
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var hpa2m1 hpa2m2 hpa2m3 hpa2m4 hpa2m5 hpa2m6 hpa2m7 hpa2m8 hpa2m9 hpa2m10 
	hpa2b1 hpa2b2 hpa2b3 hpa2b4 hpa2b5 hpa2b6 hpa2b7 hpa2b8 hpa2b9 hpa2b10
	hpa2t1 hpa2t2 hpa2t3 hpa2t4 hpa2t5 hpa2t6 hpa2t7 hpa2t8;
run;

proc sql;/*create new table for box-plot*/
create table Total_Survey as 
	select ssa1m1 as m1, ssa1m2 as m2, ssa1m3 as m3, ssa1m4 as m4, ssa1m5 as m5, 
		   ssa1m6 as m6, ssa1m7 as m7, ssa1m8 as m8, ssa1m9 as m9, ssa1m10 as m10,
		   ssa1b1 as b1, ssa1b2 as b2, ssa1b3 as b3, ssa1b4 as b4, ssa1b5 as b5,
		   ssa1b6 as b6, ssa1b7 as b7, ssa1b8 as b8, ssa1b9 as b9, ssa1b10 as b10,
		   ssa1t1 as t1, ssa1t2 as t2, ssa1t3 as t3, ssa1t4 as t4, ssa1t5 as t5,
		   ssa1t6 as t6, ssa1t7 as t7, ssa1t8 as t8 from WORK.import2
	union
	select ssa2m1, ssa2m2, ssa2m3, ssa2m4, ssa2m5, ssa2m6, ssa2m7, ssa2m8, ssa2m9, ssa2m10, 
		   ssa2b1, ssa2b2, ssa2b3, ssa2b4, ssa2b5, ssa2b6, ssa2b7, ssa2b8, ssa2b9, ssa2b10,
		   ssa2t1, ssa2t2, ssa2t3, ssa2t4, ssa2t5, ssa2t6, ssa2t7, ssa2t8  from WORK.import2
	union
	select spa1m1, spa1m2, spa1m3, spa1m4, spa1m5, spa1m6, spa1m7, spa1m8, spa1m9, spa1m10, 
		   spa1b1, spa1b2, spa1b3, spa1b4, spa1b5, spa1b6, spa1b7, spa1b8, spa1b9, spa1b10,
		   spa1t1, spa1t2, spa1t3, spa1t4, spa1t5, spa1t6, spa1t7, spa1t8 from WORK.import2
	union
	select spa2m1, spa2m2, spa2m3, spa2m4, spa2m5, spa2m6, spa2m7, spa2m8, spa2m9, spa2m10, 
		   spa2b1, spa2b2, spa2b3, spa2b4, spa2b5, spa2b6, spa2b7, spa2b8, spa2b9, spa2b10,
		   spa2t1, spa2t2, spa2t3, spa2t4, spa2t5, spa2t6, spa2t7, spa2t8 from WORK.import2
	union
	select hsa1m1, hsa1m2, hsa1m3, hsa1m4, hsa1m5, hsa1m6, hsa1m7, hsa1m8, hsa1m9, hsa1m10, 
		   hsa1b1, hsa1b2, hsa1b3, hsa1b4, hsa1b5, hsa1b6, hsa1b7, hsa1b8, hsa1b9, hsa1b10,
		   hsa1t1, hsa1t2, hsa1t3, hsa1t4, hsa1t5, hsa1t6, hsa1t7, hsa1t8  from WORK.import2
	union
	select hsa2m1, hsa2m2, hsa2m3, hsa2m4, hsa2m5, hsa2m6, hsa2m7, hsa2m8, hsa2m9, hsa2m10, 
		   hsa2b1, hsa2b2, hsa2b3, hsa2b4, hsa2b5, hsa2b6, hsa2b7, hsa2b8, hsa2b9, hsa2b10,
		   hsa2t1, hsa2t2, hsa2t3, hsa2t4, hsa2t5, hsa2t6, hsa2t7, hsa2t8  from WORK.import2
	union
	select hpa1m1, hpa1m2, hpa1m3, hpa1m4, hpa1m5, hpa1m6, hpa1m7, hpa1m8, hpa1m9, hpa1m10, 
		   hpa1b1, hpa1b2, hpa1b3, hpa1b4, hpa1b5, hpa1b6, hpa1b7, hpa1b8, hpa1b9, hpa1b10,
		   hpa1t1, hpa1t2, hpa1t3, hpa1t4, hpa1t5, hpa1t6, hpa1t7, hpa1t8  from WORK.import2
	union
	select hpa2m1, hpa2m2, hpa2m3, hpa2m4, hpa2m5, hpa2m6, hpa2m7, hpa2m8, hpa2m9, hpa2m10, 
		   hpa2b1, hpa2b2, hpa2b3, hpa2b4, hpa2b5, hpa2b6, hpa2b7, hpa2b8, hpa2b9, hpa2b10,
		   hpa2t1, hpa2t2, hpa2t3, hpa2t4, hpa2t5, hpa2t6, hpa2t7, hpa2t8  from WORK.import2;
quit;

proc factor data=Total_Survey
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 
	b1 b2 b3 b4 b5 b6 b7 b8 b9 b10
	t1 t2 t3 t4 t5 t6 t7 t8;
run;

proc factor data=Total_Survey
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 
	b1 b2 b3 b4 b5 b6 b7 b8 b9 b10
	t1 t2 t3 t4 t5 t6 t7 t8;
run;


proc factor data=Total_Survey
	simple
	method=prin
	priors=one
	mineigen=1
	scree
	rotate=v
	round
	flag=.40;
var m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 
	b1 b2 b3 b4 b5 b6 b7 b8 b9 b10
	t1 t2 t3 t4 t5 t6 t7 t8;
run;