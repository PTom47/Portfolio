
#Import danych z bazy SQL
library(RODBC)
library(DBI)
library(odbc)
con <- dbConnect(odbc(), Driver = "SQL Server", Server = "localhost\\SQLEXPRESS", 
                 Database = "TEST", Trusted_Connection = "True")
Student_Performance <- dbGetQuery(con, "select * from [TEST].[dbo].[Student_Performance]")


#Podstawopwa analiza zbioru
head(Student_Performance)
class(Student_Performance)
dim(Student_Performance)
help(Student_Performance)
str(Student_Performance)

#Przeglad danych w przegladarce
View(head(Student_Performance, n=100))

#Podstawowe parametry statystyczne kolumn liczbowych
apply(Student_Performance[25:35], 2, sum)
apply(Student_Performance[25:35], 2, mean)

#Wizualizacja sum
sum_apl <-  apply(Student_Performance[25:35], 2, sum)
sum_df <- tibble(lab = names(sum_apl), sdata = sum_apl )

ggplot(data = sum_df)+
  geom_point(aes(x=lab, y=sdata))


ggplot(data_apl,aes(x=lab, y= mdata, color="blue"))+
  geom_point()

Mjob_int <- table(Student_Performance$Mjob, Student_Performance$internet) 

