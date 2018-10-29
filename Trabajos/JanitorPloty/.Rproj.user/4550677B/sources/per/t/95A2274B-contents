#Install Packages
install.packages("janitor")

#Add libraries
library("janitor")
library("tidyverse")

#Leer dataset
#Obtenido de: https://catalog.data.gov/dataset/average-daily-traffic-counts-3968f
dat2<-read.csv("Dataset/Average_Daily_Traffic_Counts.csv")
str(dat2)

🤣#Limpieza de Datos
#Query01: Agrega total en columna
Q01<-add_totals_col(dat2,na.rm = TRUE)

#Query02: Agrega total en fila
Q02<-add_totals_row(dat2 %>% select(Traffic.Volume.Count.Location..Address,
                                   Street,Date.of.Count,Total.Passing.Vehicle.Volume),
                   fill = "-",na.rm = TRUE)

#Query03: Transforma decimales como porcentajes
Q03<-adorn_pct_formatting(dat2,digits = 2, rounding = "half to even", affix_sign = TRUE)

#Query04: Redondea numeros
Q04<-adorn_rounding(dat = dat2, digits = 2, rounding = "half up", skip_first_col = TRUE)

#Query05: Agrega un total en la columna o fila
Q05<-adorn_totals(dat = dat2, where = "row", fill = "--", na.rm = TRUE)

#Query06: Transforma a tabyl
Q06<-as_tabyl(dat = dat2)

#Query07: Da un buen formato a los col_names
Q07<-clean_names(dat = dat2)

#Query8: Convierte fechas codificadas como numeros
Q08<-as_data_frame(excel_numeric_to_date(date_num = 40,date_system = "modern"))
  
#Query09: Obtiene filas con valores identicos
Q09<-get_dupes(dat = dat2 %>% select(Street))

#Query10: Remueve filas o columnas vacias
Q10<-remove_empty(dat = dat2, which = "cols")

#Query11: Remueve filas vacias
Q11<-remove_empty_rows(dat = dat2)

#Query12: Redondea un vector
Q12<-as_data_frame(round_half_up(x = dat2$Latitude,digits = 1))

#Query13
Q13<-top_levels(input_vec = dat2$Traffic.Volume.Count.Location..Address,n = 2,show_na = FALSE)

#Query14: Convierte en recuento de porcentajes
Q14<-adorn_percentages(dat = Q06, denominator = "col")

#Query15: Usando tabyl
Q15<-dat2 %>% tabyl(Street,show_na = FALSE)

#Query16: Usando tabyl
Q16<-dat2 %>% tabyl(Traffic.Volume.Count.Location..Address)

#Query17: Usando tabyl
Q17<-dat2 %>% tabyl(Total.Passing.Vehicle.Volume) %>% adorn_percentages("all") %>% adorn_rounding(digits = 6)

#Query18: Usando tabyl
Q18<-dat2 %>% tabyl(Date.of.Count) %>% adorn_totals()

#Query19: Usando tabyl
Q19<-dat2 %>% tabyl(Location) %>% adorn_crosstab()

#Query20: Usando tabyl
Q20<-dat2 %>% tabyl(Vehicle.Volume.By.Each.Direction.of.Traffic) %>% adorn_ns()
