#Install Packages
install.packages("sqldf")
install.packages("data.table")

#Import Libraries
library("sqldf")
library("data.table")

#Ubicandonos en le directorio
setwd("D:/TrabajoParcial")

#Creando directorio de proyecto
if(!dir.exists("dataset"))
  dir.create("dataset")

#Import, Clean and Save Data
#Deuda : Saldo de Deuda Publica por Tipo de Instrumento en Millones de US Dolares
#Deuda2: Saldo de Deuda Publica por Fuente de Financiamiento en Millones de US Dolares
deuda<-read.csv("C:/Users/USER/Downloads/Adeud 2005 al III TRIM 2016_Tipo Instrum.csv", header = TRUE, sep = ",", dec = ".", quote = "\"")
colnames(deuda)<-c("Ano","Trimestre","Creditos","Bonos","Total")
write.csv(deuda,file = "dataset/DeudaTipoInstrumento.csv")
deuda2<-read.csv("C:/Users/USER/Downloads/Adeud 2005 al III TRIM 2016_Financiamiento.csv",sep = ",",quote = "\"", header = TRUE)
colnames(deuda2)<-c("Ano","Trimestre","OrganismosInternacionales","ClubdeParis","BonosExternos","BonosInternos","Banca","OtrasFuentes","Total")
write.csv(deuda,file = "dataset/DeudaFinanciamiento.csv")



######################################################################################
#-------------------------------------Using SQLdf------------------------------------#
######################################################################################

#Pregunta 1 - A (select and as)
uno_a_1<-sqldf("SELECT Ano FROM deuda")
uno_a_2<-sqldf("SELECT Ano as Anio, Total as todo FROM deuda")

#Pregunta 1 - B (subconsultas)
uno_b_1<-sqldf("SELECT *
               FROM deuda
               WHERE Ano IN(SELECT Ano FROM deuda2 WHERE Total >= 38000)")
uno_b_2<-sqldf("SELECT Ano, Trimestre
               FROM deuda2
               WHERE Ano = 2009
               AND BonosInternos>(SELECT BonosExternos FROM deuda2 WHERE Ano = 2009)")

#Pregunta 1 - C (group by)
uno_c_1<-sqldf("SELECT * 
               FROM deuda 
               GROUP BY Ano")
uno_c_2<-sqldf("SELECT Ano,SUM(Total) 
               FROM deuda 
               GROUP BY Ano")

#Pregunta 1 - D (order by)
uno_d_1<-sqldf("SELECT * 
               FROM deuda 
               ORDER BY creditos")
uno_d_2<-sqldf("SELECT Ano as anio,Bonos 
               FROM deuda 
               WHERE Bonos >= '28000' 
               ORDER BY Bonos")

#Pregunta 1 - E (like)
uno_e_1<-sqldf("SELECT * 
               FROM deuda 
               WHERE Total LIKE '28%'")
uno_e_2<-sqldf("SELECT AVG(Total) as promedioTotal 
               FROM deuda 
               WHERE Ano LIKE '201%'")

#Pregunta 1 - F (join)
#Se hará uso de los dos dataset elegidos para generar la unión
uno_f_1<-sqldf("SELECT DISTINCT a.Ano, b.Banca
               FROM deuda a
               JOIN deuda2 b
               ON a.Ano=b.Ano
               WHERE a.Ano=='2005'")
uno_f_2<-sqldf("SELECT DISTINCT a.Ano, b.Trimestre
               FROM deuda a
               JOIN deuda2 b
               ON a.Ano=b.Ano AND a.Trimestre=b.Trimestre
               WHERE a.Creditos >= 13000")

#Pregunta 1 - G (insert, update, delete)
deuda<-sqldf(c("INSERT INTO deuda (Ano,Trimestre,Creditos,Bonos,Total) VALUES (2017,1,100,200,300)",
               "SELECT * FROM deuda"))
deuda<-sqldf(c("DELETE FROM deuda WHERE Ano LIKE '2017'",
               "SELECT * FROM deuda"))



######################################################################################
#-----------------------------------Using data.table---------------------------------#
######################################################################################

#Creating a data.table
deudaDT<-as.data.table(deuda2)

#Removing Characters like ","
deudaDT$OrganismosInternacionales<-gsub(",","",deudaDT$OrganismosInternacionales)
deudaDT$OrganismosInternacionales<-as.numeric(deudaDT$OrganismosInternacionales)

deudaDT$ClubdeParis<-gsub(",","",deudaDT$ClubdeParis)
deudaDT$ClubdeParis<-as.numeric(deudaDT$ClubdeParis)

deudaDT$BonosExternos<-gsub(",","",deudaDT$BonosExternos)
deudaDT$BonosExternos<-as.numeric(deudaDT$BonosExternos)

deudaDT$BonosInternos<-gsub(",","",deudaDT$BonosInternos)
deudaDT$BonosInternos<-as.numeric(deudaDT$BonosInternos)

deudaDT$Banca<-gsub(",","",deudaDT$Banca)
deudaDT$Banca<-as.numeric(deudaDT$Banca)

deudaDT$OtrasFuentes<-gsub(",","",deudaDT$OtrasFuentes)
deudaDT$OtrasFuentes<-as.numeric(deudaDT$OtrasFuentes)

deudaDT$Total<-gsub(",","",deudaDT$Total)
deudaDT$Total<-as.numeric(deudaDT$Total)

write.csv(deuda,file = "dataset/DeudaFinanciamientoLimpio.csv")

#Pregunta 2 - A (queries and alias)
dos_a_1<-deudaDT[,.(Ano, Trimestre, BonosExternos, Total)]
dos_a_2<-deudaDT[Ano == '2010',.(Internacionales = OrganismosInternacionales,Total)]

#Pregunta 2 - B (sub-queries)
dos_b_1<-deudaDT[, .(BonosExternos), Total>40000]
dos_b_2<-deudaDT[Ano == 2007, .(Interno = BonosInternos), Total>40000]

#Pregunta 2 - C (agrupamiento)
dos_c_1<-deudaDT[,.(Interno=BonosInternos,Externo=BonosExternos),by = .(Trimestre,Ano)] 
dos_c_2<-deudaDT[,.(Interno=sum(BonosInternos),Externo=mean(BonosExternos)),by = Ano]

#Pregunta 2 - D (ordenamiento)
dos_d_1<-deudaDT[order(Banca)]
dos_d_2<-deudaDT[order(Ano,-BonosExternos)]

#Pregunta 2 - E (filtros)
dos_e_1<-subset(deudaDT, Ano == 2009)
dos_e_2<-subset(deudaDT[order(Ano)],Total <= 28000)
dos_e_3<-deudaDT[Ano %like% '09']
dos_e_4<-deudaDT[Ano %like% '09',Total, (Ano)]

#Pregunta 2 - F (union)
#dos_f_1<-deudaDT[Total > 29000]
deudita2DT<-deudaDT[OrganismosInternacionales > 7500]
dos_f<-funion(deudita2DT,deuditaDT,TRUE)
