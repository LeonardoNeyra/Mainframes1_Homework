#Install packages
install.packages("lubridate")
install.packages("tidyr")
install.packages("stringr")
install.packages("ggplot2")

#Go to dir
getwd() 

#Add libraries
library("lubridate")
library("tidyr")
library("stringr")
library("ggplot2")
library("dplyr")

#Read dataset
#Fuente: https://catalog.data.gov/dataset/accidental-drug-related-deaths-january-2012-sept-2015
datosOriginal<-read.csv("Datasets/Accidental_Drug_Related_Deaths__2012-2017.csv")

#Preparacion de datos
#Separar columnas
attach(datosOriginal)
#Eliminar fechas en blanco
DateBlank<-datosOriginal %>% filter(Date == "")
datosSinBlancos<-anti_join(datosOriginal,DateBlank)
#Generar datos limpios
datos<-datosSinBlancos %>% separate(data = datosSinBlancos, col = Date, into = c("mes","dia","anio"),
                                    sep = "[/]",remove = TRUE, convert = FALSE,
                                    extra = "warn", fill = "warn")
#Eliminar datasets inutiles
rm(DateBlank,datosSinBlancos)

#---QUERY'S---#
#Graficos de barras, torta, punto, linea, boxplot, histograma
#Cantidad de casos ocurridos por anio
query1<-datos %>% group_by(anio) %>% summarise(n())

#Cantidad de casos ocurridos por mes
query2<-datos %>% group_by(mes) %>% summarise(n())

#Sexo que mas muertes accidentales ha tenido
query3<-datos %>% filter(Sex!="") %>% group_by(Sex) %>% summarise(n())

#Edad en la que mas ocurren los accidentes
query4<-datos %>% filter(Age!="") %>% group_by(Age) %>% summarise(n())

#Raza/etnia con mas accidentes
query5<-datos %>% filter(Race!="") %>% group_by(Race) %>% summarise(n())

#Top 10 de ciudades con mas accidentes
query6<-datos %>% filter(Death.City!="") %>% group_by(Death.City) %>% summarise(cantidad=n()) %>%
        arrange(desc(cantidad)) %>% slice(1:10)

#¿Cual es el top 8 de lugares donde las personas cometen el atentado?
query7<-datos %>% filter(InjuryPlace!="") %>% group_by(InjuryPlace) %>% summarise(cantidad=n()) %>%
        arrange(desc(cantidad)) %>% slice(1:8)

#Top 5 de causas de accidente
query8<-datos %>% filter(ImmediateCauseA!="") %>% group_by(ImmediateCauseA) %>% summarise(cant=n()) %>%
        arrange(desc(cant)) %>% slice(1:5)

#¿Cuales son las 2 descripciones de accidentes mas comunes?
query9<-datos %>% filter(DescriptionofInjury!="") %>% group_by(DescriptionofInjury) %>% summarise(cant=n()) %>%
        arrange(desc(cant)) %>% slice(1:2)

#En que mes las mujeres tienen mas accidentes mortales
query10<-datos %>% filter(Sex=="Female") %>% group_by(mes) %>% summarise(n())

#Hombres blancos accidentados agrupados por dia del mes
query11<-datos %>% filter(Sex=="Male",Race=="White") %>% group_by(dia) %>% summarise(n())

#¿Cual es la causa de muerte por accidente mas comun?
query12<-bind_rows(datos %>% filter(Heroin=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="heroin"),
                   datos %>% filter(Cocaine=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="cocain"),
                   datos %>% filter(Fentanyl=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Fentanyl"),
                   datos %>% filter(Oxycodone=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Oxycodone"),
                   datos %>% filter(Oxymorphone=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Oxymorphone"),
                   datos %>% filter(EtOH=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="EtOH"),
                   datos %>% filter(Hydrocodone=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Hydrocodone"),
                   datos %>% filter(Benzodiazepine=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Benzodiazepine"),
                   datos %>% filter(Methadone=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Methadone"),
                   datos %>% filter(Amphet=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Amphet"),
                   datos %>% filter(Tramad=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Tramad"),
                   datos %>% filter(Morphine..not.heroin.=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Morphine not heroin"),
                   datos %>% filter(Any.Opioid=="Y") %>% summarise(cantidad=n()) %>% mutate(causa="Any Opioid"))

#¿Cuales son las dos sustancias que mas causan muertes por accidente a los hombres?
query13<-bind_rows(datos %>% filter(Heroin=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="heroina"),
                   datos %>% filter(Cocaine=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="cacaina"),
                   datos %>% filter(Fentanyl=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Fentanyl"),
                   datos %>% filter(Oxycodone=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Oxycodone"),
                   datos %>% filter(Oxymorphone=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Oxymorphone"),
                   datos %>% filter(EtOH=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="EtOH"),
                   datos %>% filter(Hydrocodone=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Hydrocodone"),
                   datos %>% filter(Benzodiazepine=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Benzodiazepine"),
                   datos %>% filter(Methadone=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Methadone"),
                   datos %>% filter(Amphet=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Amphet"),
                   datos %>% filter(Tramad=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Tramad"),
                   datos %>% filter(Morphine..not.heroin.=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Morphine not heroin"),
                   datos %>% filter(Any.Opioid=="Y",Sex=="Male") %>% summarise(cantidad=n()) %>% mutate(causa="Any Opioid"))

#Cantidad de hombres y mujeres que consumen heroina
query14<-datos %>% filter(Heroin=="Y") %>% group_by(Sex) %>% summarise(cant=n())

#Las 4 razas/etnicas que mas consumen cacaine
query15<-datos %>% filter(Cocaine=="Y",Race!="") %>% group_by(Race) %>% summarise(cant=n()) %>%
        arrange(desc(cant)) %>% slice(1:4)

  #10 ciudades donde provienen las personas que mas se consumen Fentanyl
query16<-datos %>% filter(Fentanyl=="Y",Residence.City!="") %>% group_by(Residence.City) %>% summarise(cant=n()) %>%
  arrange(desc(cant)) %>% slice(1:10)

#10 ciudades donde mas han muerto por consumo de Benzodiazepine
query17<-datos %>% filter(Benzodiazepine=="Y",Death.City!="") %>% group_by(Death.City) %>% summarise(cant=n()) %>%
  arrange(desc(cant)) %>% slice(1:10)

#Lugar donde mas personas murieron accidentalmente por consumo de drogas
query18<-datos %>% filter(Location!="") %>% group_by(Location) %>% summarise(cant=n()) %>% arrange(desc(cant))

#¿Cuales son las 5 otras sustancias mas comunes que causan estas muertes?
query19<-datos %>% filter(Other!="") %>% group_by(Other) %>% summarise(cant=n()) %>% 
  arrange(desc(cant)) %>% slice(1:5)

#Las 5 causas de muerte relacionadas al consumo de EtOH
query20<-datos %>% filter(ImmediateCauseA!="",EtOH=="Y") %>% group_by(ImmediateCauseA) %>% summarise(cant=n()) %>% 
  arrange(desc(cant)) %>% slice(1:5)

#Cantidad de muertes por pais de residencia, top 10
query21<-datos %>% filter(Residence.County!="") %>% group_by(Residence.County) %>% summarise(cant=n()) %>% 
  arrange(desc(cant)) %>% slice(1:10)

#¿Cual es cantidad de muertos por accidente que consumieron cocaina por anio en un hospital
query22<-datos %>% filter(Location=="Hospital",Cocaine=="Y") %>% group_by(anio) %>% summarise(cant=n())

#Lista de meses donde mas se consume heroin
query23<-datos %>% filter(Heroin=="Y") %>% group_by(mes) %>% summarise(cant=n())

#¿En que lugares fallecen negros?
query24<-datos %>% filter(Race=="Black",Location!="") %>% group_by(Location) %>% summarise(cant=n())

#¿Que es lo que mas consumen los Hispanic, cocaina o heroina?
query25<-bind_rows(datos %>% filter(str_detect(Race,"Hispanic"),Cocaine=="Y") %>% summarise(cant=n()) %>% mutate(causa="Cocaina"),
                   datos %>% filter(str_detect(Race,"Hispanic"),Heroin=="Y") %>% summarise(cant=n()) %>% mutate(causa="Heroina"))

#¿Que dias los hospitales tienen mas pacientes por accidentes por consumo de drogas?
query26<-datos %>% filter(Location=="Hospital") %>% group_by(dia) %>% summarise(cant=n())

#Personas que fallecieron en su residencia segun meses del anio 2017
query27<-datos %>% filter(Location=="Residence",anio==2017) %>% group_by(mes) %>% summarise(cant=n())

#Lugares donde mas se consume Oxycodone
query28<-datos %>% filter(Oxycodone=="Y",Residence.City!="") %>% group_by(Residence.City) %>%
  summarise(cant=n()) %>% arrange(desc(cant)) %>% slice(1:10)

#Top 10 causas de accidente en el anio 2016
query29<-datos %>% filter(ImmediateCauseA!="",anio==2016) %>% group_by(ImmediateCauseA) %>% summarise(cant=n()) %>%
  arrange(desc(cant)) %>% slice(1:10)

