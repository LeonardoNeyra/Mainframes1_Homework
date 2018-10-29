#Install packages
#install.packages("shiny")
#install.packages("plotly")
#install.packages("devtools")
#devtools::install_github('ropensci/plotly')
#Add libraries
library("plotly")
library("shiny")
library("dplyr")
library("ggplot2")

#Leer dataset
#Obtenido de:https://catalog.data.gov/dataset/city-employee-salaries-november-2017
dat<-read.csv("Dataset/City_Employee_Salaries_November_2017.csv")

#Limpieza
colnames(dat)<-c("Name","Unit","Department","JobTitle","Annual_RT","HourlyRate","Full_Part","Reg_Temp","FID")
dat<-dat %>% filter(Name!="")

opc<-c("query01","query02","query03","query04","query05","query06","query07","query08","query09","query10",
       "query11","query12","query13","query14","query15","query16","query17","query18","query19","query20")

#Consultas
query01<-dat %>% group_by(Unit) %>% summarise(total=n())
query02<-dat %>% group_by(Full_Part) %>% summarise(total=n())
query03<-dat %>% group_by(Department) %>% summarise(total=n()) %>% arrange(desc(total)) %>% slice(1:5)
query04<-dat %>% filter(Unit=="H&NS") %>% group_by(Department) %>% summarise(total=n())
query05<-dat %>% group_by(JobTitle)%>% summarise(total=n(),mediaDeHora=mean(HourlyRate)) %>%
  arrange(desc(total)) %>% slice(1:8)
query06<-dat %>% group_by(JobTitle)%>% summarise(total=n(),mediaIngreso=mean(Annual_RT)) %>%
  arrange(desc(total)) %>% slice(1:8)
query07<-dat %>% group_by(Reg_Temp) %>% summarise(total=n())
query08<-dat %>% filter(Reg_Temp=="R") %>% group_by(Full_Part) %>% summarise(total=n())
query09<-dat %>% filter(Full_Part=="F") %>% group_by(Reg_Temp) %>% summarise(total=n())
query10<-dat %>% select(HourlyRate)
query11<-dat %>% filter(HourlyRate>=10) %>% group_by(Unit) %>% summarise(total=n(),Horas=max(HourlyRate))
query12<-dat %>% filter(HourlyRate>=20) %>% group_by(Unit) %>% summarise(total=n(),Horas=min(HourlyRate))
query13<-dat %>% select(Annual_RT,HourlyRate)
query14<-dat %>% group_by(Full_Part) %>% summarise(MediaHoras=median(HourlyRate))
query15<-dat %>% group_by(Reg_Temp) %>% summarise(VarIngreso=var(Annual_RT))
query16<-dat %>% filter(JobTitle=="Police Officer") %>% select(JobTitle,HourlyRate)
query17<-dat %>% filter(JobTitle=="Fire Fighter II") %>% select(JobTitle,HourlyRate)
query19<-dat %>% group_by(Department) %>% summarise(total=n()) %>% slice(1:25)
query20<-dat %>% select(Annual_RT,Full_Part)

#---Definicion de UI---#
ui<-fluidPage(
  titlePanel("Consultas con Ploty & Shiny"),
  sidebarPanel(
    titlePanel("Seleccion de Consultas"),
    selectInput(inputId = "entrada",label = "Elige una consulta",choices = opc)
  ),
  mainPanel(
    plotlyOutput("plot")
  )
)

#---Definicion de servidor---#
server<-function(input,output) {
  output$plot<-renderPlotly({
    #datos
    #consulta1<-~get(input$entrada)
    #Renderizado
    if(input$entrada=="query01"){
      plot_ly(query01,x=~Unit,y=~total,color=~Unit,type="bar")
    }
    else if(input$entrada=="query02"){
      plot_ly(query02,labels=~Full_Part,values=~total,type="pie")
    }
    else if(input$entrada=="query03"){
      plot_ly(query03,labels=~Department,values=~total,type="pie")
    }
    else if(input$entrada=="query04"){
      plot_ly(query04,x=~Department,y=~total,type="scatter",mode="lines")
    }
    else if(input$entrada=="query05"){
      plot_ly(query05,x=~JobTitle,y=~total,type="bar",name="cantidad") %>%
        add_trace(y=~mediaDeHora,name="Horas")
    }
    else if(input$entrada=="query06"){
      plot_ly(query06,x=~JobTitle,y=~total,type="bar",name="cantidad") %>%
        add_trace(y=~mediaIngreso,name="ingresos")
    }
    else if(input$entrada=="query07"){
      plot_ly(query07,labels=~Reg_Temp,values=~total,type="pie")
    }
    else if(input$entrada=="query08"){
      plot_ly(query08,labels=~Full_Part,values=~total) %>% 
        add_pie(hole = 0.6) %>%
        layout(title = "Donut chart",  showlegend = F,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    }
    else if(input$entrada=="query09"){
      plot_ly(query09,labels=~Reg_Temp,values=~total,type="pie")
    }
    else if(input$entrada=="query10"){
      x<-c(1:7327)
      plot_ly(query10,x=~x,y=~HourlyRate,type="scatter")
    }
    else if(input$entrada=="query11"){
      plot_ly(query11,x=~total,y=~Unit,type="bar",name="cantidad") %>%
        add_trace(x=~Horas,type="scatter",mode="lines",name="minimoHoras")
    }
    else if(input$entrada=="query12"){
      plot_ly(query12,x=~total,y=~Unit,type="bar",name="cantidad") %>%
        add_trace(x=~Horas,type="scatter",mode="lines",name="minimoHoras")
    }
    else if(input$entrada=="query13"){
      plot_ly(query13,x=~Annual_RT,y=~HourlyRate,type="scatter")
    }
    else if(input$entrada=="query14"){
      plot_ly(query14,labels=~Full_Part,values=~MediaHoras) %>% 
        add_pie(hole = 0.6) %>%
        layout(title = "Donut chart",  showlegend = F,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    }
    else if(input$entrada=="query15"){
      plot_ly(query15,labels=~Reg_Temp,values=~VarIngreso,type="pie")
    }
    else if(input$entrada=="query16"){
      plot_ly(query16,x=~JobTitle,y=~HourlyRate,type="box")
    }
    else if(input$entrada=="query17"){
      plot_ly(query17,x=~JobTitle,y=~HourlyRate,type="box")
    }
    else if(input$entrada=="query18"){
      plot_ly(query16,x=~JobTitle,y=~HourlyRate,type="box",boxpoints = "all", jitter = 0.3,pointpos = -1.8)
    }
    else if(input$entrada=="query19"){
      plot_ly(query19,x=~total,y=~Department,type="scatter",mode="lines")
    }
    else if(input$entrada=="query20"){
      x<-c(1:7327)
      plot_ly(query20,x=~x,y=~Annual_RT,color=~Full_Part,colors="Set1")
    }
  }) 
}

#---Run the application---#
shinyApp(ui,server)


