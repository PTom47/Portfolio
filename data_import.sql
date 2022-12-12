--Zaladowanie danych z portalu keggle.com (Student Performance Dataset)

use TEST;
--Utworzenie tabeli (przejsciowej )do importu danych
drop table if exists dbo.Student_Performance_v0;

create table dbo.Student_Performance_v0
(	school nvarchar(5),
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
	failures int,
	schoolsup nvarchar(5),
	famsup nvarchar(5),
	paid nvarchar(5),
	activities nvarchar(5),
	nursery nvarchar(5),
	higher nvarchar(5),
	internet nvarchar(5),
	romantic nvarchar(5),
	famrel int,
	freetime int,
	goout int,
	Dalc int,
	Walc int,
	health int,
	absences int,
	G1 int,
	G2 int,
	G3 int
)
;




--Import danych z pliku csv
bulk insert dbo.Student_Performance_v0 from 'C:\...\student_data.csv'
with
	(DATAFILETYPE = 'char',
	firstrow =2,
	FIELDQUOTE = '\',
	fieldterminator = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK)
	;

--Utworzenie docelowej tabeli z kluczem
drop table if exists dbo.Student_Performance;

create table dbo.Student_Performance (
	keycol int not null identity(1,1)
		constraint PK_Student_Performance primary key,
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
	failures int,
	schoolsup nvarchar(5),
	famsup nvarchar(5),
	paid nvarchar(5),
	activities nvarchar(5),
	nursery nvarchar(5),
	higher nvarchar(5),
	internet nvarchar(5),
	romantic nvarchar(5),
	famrel int,
	freetime int,
	goout int,
	Dalc int,
	Walc int,
	health int,
	absences int,
	G1 int,
	G2 int,
	G3 int
)
;
--Zasilenie tabeli docelowej danymi
insert into dbo.Student_Performance (
								school,
								sex ,
								age,
								address ,
								famsize ,
								Pstatus,
								Medu ,
								Fedu,
								Mjob ,
								Fjob ,
								reason,
								guardian,
								traveltime,
								studytime,
								failures,
								schoolsup,
								famsup,
								paid,
								activities,
								nursery,
								higher,
								internet,
								romantic,
								famrel,
								freetime,
								goout,
								Dalc,
								Walc,
								health,
								absences,
								G1,
								G2,
								G3
								)
select * from dbo.Student_Performance_v0
;

--dodanie nowej kolumny
alter table dbo.Student_Performance
add Pedu numeric(5,2);

--wstawienie danych do nowej kolumny
update dbo.Student_Performance
set Pedu = (1.0 *Medu + Fedu)/2
;