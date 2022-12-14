
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
apply(Student_Performance[25:35], 2, median)

#Wizualizacja średnich
mean_apl <-  apply(Student_Performance[25:35], 2, mean)
library(tidyverse)
mean_df <- tibble(lab = names(sum_apl), mean_d = mean_apl)

#wektor pomocniczy do ustalenia rosnącej kolejności na wykresie
et1 <- c(arrange(mean_df, mean_d)$lab)


#wykres średnich
library(ggplot2)
ggplot(data = mean_df)+
  geom_point(aes(x=lab, y=mean_d))+
  scale_x_discrete(limits=et1)+
  labs(title = "Student Performance mean")+
  theme_bw()

#wykres zależności G1 i G2
ggplot(Student_Performance,aes(G1, G2))+
  geom_point(color="blue")+
  labs(title = "Student Performance, G1&G2")+
  theme_light()

#Mjob & internet
Mjob_int <- data.frame(table(Student_Performance$Mjob, Student_Performance$internet)) 
Mjob_int_y <- Mjob_int[Mjob_int$Var2=="yes",]

et2 <- c(arrange(Mjob_int_y, Freq)$Var1)

#wykres Mjob & internet
ggplot(Mjob_int_y, aes(Var1, Freq))+
         geom_point()+
         scale_x_discrete(limits=et2)+
          labs(title = "Internet",
               x = "Mother job",
               y = "Freq")+
          theme_minimal()
               


