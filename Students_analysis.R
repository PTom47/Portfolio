
#Import danych z bazy SQL
library(RODBC)
library(DBI)
library(odbc)
library(tidyverse)
library(ggplot2)
library(dplyr)
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
apply(Student_Performance[25:35], 2, median)

#Wizualizacja średnich
mean_apl <-  data.frame(avg_value=apply(Student_Performance[25:35], 2, mean))
mean_apl$category <- row.names(mean_apl)

#Wykresy pudełkowe dla danych liczbowych
col2plot <- c("age", "Medu","Fedu","traveltime", "studytime",  "failures", "famrel",
              "freetime",   "goout", "Dalc", "Walc", "health", "absences", "G1", "G2", "G3",
              "Pedu" )

ggplot(gather( Student_Performance[,col2plot], Category, Value))+
  geom_boxplot(
    mapping = aes(x=reorder(Category, Value, FUN=median), y=Value))+
  labs(x="Category", y="Value")

#Wykres zależności G1 i G2
ggplot(Student_Performance,aes(G1, G2))+
  geom_point(color="blue")+
  labs(title = "Student Performance, G1&G2")+
  theme_light()

#Wykres Mother job & internet
Mjob_int <- data.frame(table(Student_Performance$Mjob, Student_Performance$internet)) 
Mjob_int_y <- Mjob_int[Mjob_int$Var2=="yes",]

et2 <- c(arrange(Mjob_int_y, Freq)$Var1)

ggplot(Mjob_int_y, aes(Var1, Freq))+
         geom_point()+
         scale_x_discrete(limits=et2)+
          labs(title = "Internet",
               x = "Mother job",
               y = "Freq")+
          theme_minimal()

#wykres Mother job & studytime               
ggplot(Student_Performance, aes(x=Mjob, y=studytime))+
  geom_bar(stat="summary", fill = "cornflowerblue")+
  stat_summary(fun.data = mean_se, geom = "errorbar")+
  labs(title = "Studytime",
       x = "Mother job",
       y = "studytime")+
  theme_minimal()



