#Install packages
install.packages("tidyverse")
install.packages("wakefield")

#Add libraries
library("dplyr")
library("stringr")
library("tidyr")
library("wakefield")

#Go to dir
getwd()

#Fuente: https://catalog.data.gov/dataset/usda-rd-section-538-multifamily-guaranteed-loans-as-of-7-13-2016
#Prestamos activos en el programa de prestamos multifamiliares garantizados de la Seccion 538 del USDA RD
dataset<-read.csv("dataset/USDA_RD_July_2016.CSV")

#Limipiar data. El campo Loan_Amount tiene el formato $x,x y se necesita valores numericos
dataset$Loan_Amount<-gsub(",","",dataset$Loan_Amount)
dataset$Loan_Amount<-gsub("[$]","",dataset$Loan_Amount)
dataset$Loan_Amount<-as.numeric(dataset$Loan_Amount)

#-----DICCIONARIO DE DATOS-----#
#Latitud = Latitude, Longitud = Longitude
#Anio Fiscal = FY.ObligationYear, Prestamista = Lender_Name, Prestatario = Borrower_Name, Nombre de Proyecto = Project.Name
#dirrecciÛn 1, dirrecciÛn 2, dirrecciÛn 3 = Main_Address_line_[1-3]
#Ciudad = City, Abreviacion de la ciudad = State_Abrevation, Codigo ZIP = Zip_Code, Fecha de cierre de prestamo = Date_Loan_Closing
#Monto prestado = Loan_Amount, Costo total de desarrollo = Total_Develoment_Cost, Relacion entre prestamo y costo = Lean_to_Cost
#Indicador de crÈdito fiscal = Tax_Credit_Indicator, Indicador de la existencia de tribus  = Colonias_Tribal_Indicator
#Indicador de Zonas de Empoderamiento/Comunidades Empresariales = EZ.EC_Indicator, Obligacion poblacional = Population_Obligation
#Mediana del ingreso familiar = Median_Household_Income_Obligation, TamaÒo del proyecto = Project_Size, Tipo del proyecto = Project_Type
#Total de unidades del dormitorio 1,2,3,4,5 = Total_[1-5]_Bedroom_Units
#Unidades promedio del contrato del alquiler 1,2,3,4,5 = Br[1-5].Unit.Average.Contract.Rent
#Tipo de construccion = Construction_Type, Id = id


#----------EJEMPLOS----------#

#Lista de todos los prestamistas
Ejem1<-unique(dataset %>% select(Lender_Name))

#Cantidad de prestamos realizados en el anio 2010
Ejem2<-dataset %>% filter(FY.Obligation.Year==2010) %>% summarise(n())

#Ordenar por anio de menor a mayor
Ejem3<-dataset %>% arrange(FY.Obligation.Year)

#Promedio de dinero prestado en la ciudad de KNOXVILLE
Ejem4<-dataset %>% filter(City=="KNOXVILLE") %>% select(City,Loan_Amount) %>% summarise(mean(Loan_Amount))

#Promedio de dinero prestado por cada ciudad
Ejem5<-dataset %>% select(City,Loan_Amount) %>% group_by(City) %>% summarise(mean(Loan_Amount))

#Lista de ciudades en las que BONNEVILLE MORTGAGE COMPANY hizo prestamos
Ejem6<-distinct(dataset %>% filter(Lender_Name=="BONNEVILLE MORTGAGE COMPANY") %>% select(City))

#Determinar la varianza del costo total de desarrollo de los prestamos mayores a dos millones
Ejem7<-dataset %>% filter(Loan_Amount>2000000) %>% select(Total_Development_Cost) %>% summarise(var(Total_Development_Cost))

#Determinar la desviacion estandar de los ingresos en los hogares
Ejem8<-dataset %>% select(Median_Household_Income_Obligation) %>% summarise(sd(Median_Household_Income_Obligation))

#Numero de proyecto de tipo familiar que fueron nuevas construcciones
Ejem9<-dataset %>% filter(Project_Type=="FAMILY",Construction_Type=="NEW CONSTRUCTION") %>% summarise(n())

#Prestamos con indicador de credito fiscal que cubrieron mas del 50% del costo
Ejem10<-dataset %>% filter(Loan_to_Cost>0.50) %>% select(Loan_Amount,Total_Development_Cost,Loan_to_Cost) 

#Cantidad de proyectos senior de tamano mayor a 60 que tengan menos de 45 unidades de dormitorio N2
Ejem11<-dataset %>% filter(Project_Type=="SENIOR",Project_Size>60,Total_2_Bedroom_Units<45) %>% summarise(n())

#Minimo financiamiento realizado en el 2009
Ejem12<-dataset %>% filter(FY.Obligation.Year==2009) %>% summarise(min(Loan_Amount)) 

#Media de prestamos que no se han hecho en zonas de empoderamiento y comunidades empresariales (EZ.EC) por tipo de construccion
Ejem13<-dataset %>% filter(EZ.EC_Indicator=="N") %>% group_by(Construction_Type) %>% summarise(median(Loan_Amount))

#Minimo (diferente de cero) y maximo de precio medio de la unidad de alquier N1 y N2 respectivamente
#para pr√©stamos con indicador de cr√©dito fiscal
Ejem14<-dataset %>% filter(Tax_Credit_Indicator=='Y', Br1.Unit.Average.Contract.Rent!=0) %>% 
                    summarise(min(Br1.Unit.Average.Contract.Rent),max(Br2.Unit.Average.Contract.Rent))

#Anio del prestamo mas antiguo realizado
Ejem15<-dataset %>% select(FY.Obligation.Year) %>% arrange(FY.Obligation.Year) %>% summarise(first(FY.Obligation.Year))

#Media del tamano del proyecto por tipo de proyecto
Ejem16<-dataset %>% select(Project_Type,Project_Size) %>% group_by(Project_Type) %>% summarise(median(Project_Size))

#Prestamos realizados antes del anio 2000 en prestatarios con proyecto de tamano entre 40 y 50
Ejem17<-dataset %>% filter(FY.Obligation.Year<2000, Project_Size>40 & Project_Size<50) 

#Cantidad de prestamos en LONDON sin indicador tribal
Ejem18<-dataset %>% filter(City=="LONDON",Colonias_Tribal_Indicator=='N')

#Demostrar que el costo de prestamos entre el costo total de desarrollo es igual al prestamo sobre costo
Ejem19<-dataset %>% select(Loan_Amount,Total_Development_Cost,Loan_to_Cost) %>% filter(Loan_Amount/Total_Development_Cost==Loan_to_Cost)

#Proyectos que no tienen dormitorios N5
Ejem20<-dataset %>% filter(Total_5_Bedroom_Units==0)

#Numero de proyectos que solo tienen dormitorios N1 y N2
Ejem21<-dataset %>% filter(Total_1_Bedroom_Units!=0, Total_2_Bedroom_Units!=0, Total_3_Bedroom_Units==0,Total_4_Bedroom_Units==0,Total_5_Bedroom_Units==0) %>% 
                    summarise(n())

#Comprobar que si existe un dormitorio N3 debe existir un precio medio de la unidad de alquier N3
Ejem22<-dataset %>% filter(Total_3_Bedroom_Units!=0,Br3.Unit.Average.Contract.Rent!=0) %>% select(Total_3_Bedroom_Units,Br3.Unit.Average.Contract.Rent)

#Creamos otro dataset para generar join's
dataset$id=1:NROW(dataset)
dt<-data.frame()
datos<-function(n) {
  id=sample(1:789,n,replace = FALSE) 
  quebro=sample(c('Y','N'),n,replace = TRUE)
  nombre=wakefield::name(n)
  dt<-data.frame(id,quebro,nombre)
  return(dt)
}
datitos<-datos(428)

#Generar un left join y nombrar a los prestamistas
Ejem23<-left_join(dataset,datitos,by=c("id"="id")) %>% select(Lender_Name)

#Generar un right join y mostrar la cantida de proyectos REHAB/REPAIR que fueron exitosos
Ejem24<-right_join(dataset,datitos,by=c("id"="id")) %>% filter(Construction_Type=="REHAB/REPAIR",quebro=='N')

#Generar un inner join y aquellos proyectos que fracasaron
Ejem25<-inner_join(dataset,datitos,by=c("id"="id")) %>% filter(quebro=='Y') %>% select(Lender_Name,quebro)
