
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

#Unikalność danych
head(unique(Student_Performance), n=100)

#Podstawowe parametry statystyczne kolumn liczbowych
apply(Student_Performance[25:35], 2, sum)
apply(Student_Performance[25:35], 2, mean)

#Wizualizacja sum
sum_apl <-  apply(Student_Performance[25:35], 2, sum)
sum_df <- tibble(lab = names(sum_apl), sdata = sum_apl )

#wykresy
ggplot(data = sum_df)+
  geom_point(aes(x=lab, y=sdata))+
  labs(title = "Student Performance I")


ggplot(Student_Performance,aes(G1, G2, color="blue"))+
  geom_point()+
  labs(title = "Student Performance II")

Mjob_int <- data.frame(table(Student_Performance$Mjob, Student_Performance$internet))  

head(Mjob_int[Mjob_int$Var2=="no",])

ggplot(Mjob_int[Mjob_int$Var2=="no",], aes(Var1, Freq))+
         geom_point()+
          labs(title = "Internet",
               x = "Mother job",
               y = "Freq"
               


