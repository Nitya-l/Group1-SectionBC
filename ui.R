#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
pathogen_data <- read_delim("IHME_Data.CSV")
options_pathogens <- as.list(unique(pathogen_data$pathogen))
 

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
    
    ##Additional Plot Page 
    
    tabPanel("Bar Plot", 
             sidebarLayout( 
               sidebarPanel( 
                 checkboxGroupInput("pathogenss", "Select Pathogen", choices = options_pathogens),
                 ),
               mainPanel ( 
                 plotOutput("bars"),
                 )
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
# Run the application 
#shinyApp(ui = ui, server = server)
