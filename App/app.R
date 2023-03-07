#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(tidyverse)
library(data.table)

#read data 
pathogen_data <- read_delim("IHME.csv")

# Define UI for application
ui <- fluidPage(
  tabsetPanel(
    #About page 
    tabPanel("About", 
      h1("Pathogen Data App"), 
      h2("Data Summary"), 
      p("The pathogen data used to create this app is from researchers at the ", em("Institute for Health Metrics and Evaluation"),"in", strong("2019"), ". It provides estimates of deaths due to various infections caused by 33 different pathogens across the world in ", strong("204"), "different countries. These estimates were made based on 343 millions of individual records and come from sources like hospital discharges, tissue samples,literature review, and microbiology lab results from national and multi-national surveillance systems. We hope to use this data to provide health professionals with a better understanding of fatal pathogens to increase the quality of care they are able to provide."),
      p("\n While my app for the problem set does not analyze the death values, the app made for the final project will include components that analyze the death rate. This app focuses more on data collection in relation to location and age groups since the quality of data(# of observations) is also important to decision making based on such data."),
      h2("Figure"),
      p("This data contains a total of 267,375 observations and 5 different variables regarding the different pathogens, age groups, infections/symptoms, and their associated deaths."),
      p("\n Below is a small random sample of the pathogen data set where val is equal to the # of estimated deaths."), 
      tableOutput("sample"), 
      ), 
    #Plot page
    tabPanel("Plot",
      sidebarLayout(
        sidebarPanel(
          p("Use the widgets below to select different subsets of data based on certain age groups, or certain combinations of infections/symptoms"),
          radioButtons("visual", "Plot type", c("Bar Graph", "Dot plot")),
          uiOutput("age"),
          uiOutput("symptoms")), 
        mainPanel(
          textOutput("react_plot"),
          plotOutput("plot")),
      ),  
    ), 
    #Table page
    tabPanel("Table",
      sidebarLayout(
        sidebarPanel(
          p("Select a country using the radio buttons below to see the number of observations for each age group and symptom type."),
          uiOutput("locations")), 
        mainPanel(
          textOutput("react_table"),
          dataTableOutput("table"))),
    ), 
  ),
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  #sample output
  output$sample <- renderTable({
    sample <- sample_n(pathogen_data,5)
    #setnames(sample,old = c("location_name","age_group_name","infectious_syndrome","pathogen","val"), new = c("Location","Age Group","Symptoms","Pathogen","# Estimated Deaths"))
    sample
  })
  
  #Options, vectors 
    options_age <- as.list(unique(pathogen_data$age_group_name))
    options_symptoms <- as.list(unique(pathogen_data$infectious_syndrome))
    options_locations <- as.list(unique(pathogen_data$location_name)) 
  #Age options
    output$age <- renderUI({
      selectInput("age", label = "Select Age Group", choices = options_age, selected = "All Ages")
    })
  #Symptoms options
    output$symptoms <- renderUI({
      checkboxGroupInput("symptoms", label = "Select Symptoms", choices = options_symptoms, selected = options_symptoms) 
    })
  #Location options
    output$locations <- renderUI({
      radioButtons("locations", label = "Select Country", choices = options_locations, selected = "China")
    })
    
  #visual options 
    output$visual <- renderUI({
      radioButtons("Plot type", label = "Plot type", choices = c("Bar Graph", "Dot Plot")) 
    })
    
 # Plot output 
    output$plot <- renderPlot({
      #Data filter by age 
      if(input$age == "All Ages"){
        df <- pathogen_data %>% select(age_group_name,infectious_syndrome,pathogen) %>% filter(infectious_syndrome %in% input$symptoms) %>% group_by(age_group_name, infectious_syndrome) %>%  summarize(num = n()) 
      }
      else{
        df <- pathogen_data %>% select(age_group_name,infectious_syndrome,pathogen) %>% filter(age_group_name %in% input$age, infectious_syndrome %in% input$symptoms) %>% group_by(age_group_name,infectious_syndrome) %>%  summarize(num = n())
      }
      output$react_plot <- renderText({
        n_sum <- sum(df$num)
        paste("There are",toString(n_sum),"total observations in the subset you have selected")
      })
      #Plot creation 
      if(input$visual == "Bar Graph"){
        ggplot(df, aes(num, color = infectious_syndrome))+ 
          geom_bar(position = "Dodge", fill = "white")+
            ggtitle("Symptoms Instances by Age Group")+
              labs(x = "Number of Observations", y = "# Age groups", color = "Symptoms")
      } 
      else{
        ggplot(df, aes(age_group_name,num, color = infectious_syndrome))+ 
          geom_count()+
            ggtitle("Symptoms Instances by Age Group")+
              labs(x = "Age Group", y = "# of Observations", color = "Symptoms")
      }
    })
  
  #Table output
    #Table creation 
    output$table <- renderDataTable({
      table <- pathogen_data %>% select(age_group_name,infectious_syndrome,location_name, pathogen) %>% filter(location_name == input$locations) %>% group_by(age_group_name,infectious_syndrome) %>% summarize(observations = n())
      setnames(table,old = c("age_group_name","infectious_syndrome","observations"), new = c("Age group","Symptoms","Observations"))
      table
    })
    #Reactive text creation 
    output$react_table <- renderText({
      table_d <- pathogen_data %>% select(age_group_name,infectious_syndrome,location_name, pathogen,val) %>% filter(location_name == input$locations) %>% group_by(age_group_name,infectious_syndrome)
      mean_d <- mean(table_d$val)
      paste("The average number of deaths across all infections and age groups is ",toString(round(mean_d,3)),"in", input$locations)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
