--Analiza danych

  -- grupowanie
 with TB as (
 select school, sex, famsize, Pstatus, Mjob, Fjob
		,sum(traveltime) as traveltime_sum
 FROM [TEST].[dbo].[Student_Performance_v1]
  where 1=1
  and Mjob in ('at_home', 'services', 'teacher')
  and Fjob <> 'other'
  group by school, sex, famsize, Pstatus, Mjob, Fjob
		)
select * ,
		sum(traveltime_sum) over(partition by Mjob) as trave_Mjob
from TB;

------------------------------------------------
------------------------------------------------
--Laczenie tabel

with TM as (
select Medu, SUM(studytime) as studytime 
FROM [TEST].[dbo].[Student_Performance]
group by Medu
),
TF as (
select Fedu, SUM(studytime) as studytime 
FROM [TEST].[dbo].[Student_Performance]
group by Fedu
)
select TM.Medu as TMedu, TM.studytime as Mstudytime, TF.studytime as Fstudytime
		,round(sqrt(TM.studytime * TF.studytime),3) as stime_gmean
from TM full outer join TF on TM.Medu=TF.Fedu

------------------------------------------------
------------------------------------------------
-- Laczenie dwóch grupowanych tabel
with TM as (
select Medu, SUM(studytime) as studytime 
FROM [TEST].[dbo].[Student_Performance]
group by Medu
),
TF as (
select Fedu, SUM(studytime) as studytime 
FROM [TEST].[dbo].[Student_Performance]
group by Fedu
)
select TM.Medu as TMedu, TM.studytime as Mstudytime, TF.studytime as Fstudytime
		,round(sqrt(TM.studytime * TF.studytime),3) as stime_gmean
from TM full outer join TF on TM.Medu=TF.Fedu
;

------------------------------------------------
------------------------------------------------
--Pivot dla traveltime
select school, sex, age, GT3, LE3  
from (select school, sex, age, famsize, traveltime from [TEST].[dbo].[Student_Performance]) as TD
	pivot(sum(traveltime) for famsize in(GT3, LE3)) as TP

------------------------------------------------
------------------------------------------------
--Funkcje okna

SELECT TOP (1000) [keycol]
      ,[school]
      ,[sex]
      ,[age]
      ,[address]
      ,[famsize]
      ,[Pstatus]
      ,[Medu]
      ,[Fedu]
      ,[Mjob]
      ,[Fjob]
      ,[reason]
      ,[guardian]
      ,[famrel]
      ,[freetime]
	  ,sum(famrel) over(partition by guardian order by keycol 
						rows between unbounded preceding and current row) as guar_window_sum
      ,max(freetime) over(partition by reason) as reason_window_max
	  ,LAG(famrel) over(partition by Fjob order by keycol) as famrel_prev
	  ,LEAD(freetime,3) over(partition by Mjob order by keycol) as freet_next3
  FROM [TEST].[dbo].[Student_Performance]
  order by keycol;


------------------------------------------------
------------------------------------------------
  --Tabela tymczasowa, zmienna tabelaryczna, polaczenie zbiorow w czesci wspolnej

if OBJECT_ID('tempdb.dbo.#StudentTab1') is not null
	drop table dbo.#StudentTab1;
GO

create table #StudentTab1(
	 school nvarchar(5),
		sex  nvarchar(5),
		age int,
		address  nvarchar(5),
		famsize  nvarchar(5),
		Pstatus nvarchar(5),
		Medu  int,
		Fedu int,
		Mjob  nvarchar(15),
		Fjob  nvarchar(15),
		reason nvarchar(15),
		guardian nvarchar(15),
		traveltime int,
		studytime int,
		failures int
);

insert into #StudentTab1 ([school]
						  ,[sex]
						  ,[age]
						  ,[address]
						  ,[famsize]
						  ,[Pstatus]
						  ,[Medu]
						  ,[Fedu]
						  ,[Mjob]
						  ,[Fjob]
						  ,[reason]
						  ,[guardian]
						  ,[traveltime]
						  ,[studytime]
						  ,[failures])
		select [school]
				  ,[sex]
				  ,[age]
				  ,[address]
				  ,[famsize]
				  ,[Pstatus]
				  ,[Medu]
				  ,[Fedu]
				  ,[Mjob]
				  ,[Fjob]
				  ,[reason]
				  ,[guardian]
				  ,[traveltime]
				  ,[studytime]
				  ,[failures]
		from [TEST].[dbo].[Student_Performance]
		 where schoolsup = 'yes'
;

declare @StudentTab2 table
		( school nvarchar(5),
		sex  nvarchar(5),
		age int,
		address  nvarchar(5),
		famsize  nvarchar(5),
		Pstatus nvarchar(5),
		Medu  int,
		Fedu int,
		Mjob  nvarchar(15),
		Fjob  nvarchar(15),
		reason nvarchar(15),
		guardian nvarchar(15),
		traveltime int,
		studytime int,
		failures int
);

insert into @StudentTab2 ([school]
						  ,[sex]
						  ,[age]
						  ,[address]
						  ,[famsize]
						  ,[Pstatus]
						  ,[Medu]
						  ,[Fedu]
						  ,[Mjob]
						  ,[Fjob]
						  ,[reason]
						  ,[guardian]
						  ,[traveltime]
						  ,[studytime]
						  ,[failures])
		select [school]
				  ,[sex]
				  ,[age]
				  ,[address]
				  ,[famsize]
				  ,[Pstatus]
				  ,[Medu]
				  ,[Fedu]
				  ,[Mjob]
				  ,[Fjob]
				  ,[reason]
				  ,[guardian]
				  ,[traveltime]
				  ,[studytime]
				  ,[failures]
		from [TEST].[dbo].[Student_Performance]
		 where famsup = 'yes'
;

with TB as (
select * from #StudentTab1
intersect
select  * from @StudentTab2)
select top(100) * from TB
;
