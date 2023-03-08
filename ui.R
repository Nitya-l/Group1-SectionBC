#<<<<<<< HEAD
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
data_i <- read_delim("IHME_Data.csv")
pathogen_data <- data_i %>% select(-sex_id, -sex_name, -metric_id, -upper, -lower, -measure_id, -cause_id, cause_name) %>% filter(!(location_name %in% c(
                                                                                                                                                                          "Southeast Asia, East Asia, and Oceania", 
                                                                                                                                                                          "East Asia", "Democratic People's Republic of Korea",
                                                                                                                                                                          "Southeast Asia", "Lao People's Democratic Republic", "Marshall Islands",
                                                                                                                                                                          "Central Europe, Eastern Europe, and Central Asia", 
                                                                                                                                                                          "Central Asia", "Central Europe", "Eastern Europe", "Republic of Moldova", 
                                                                                                                                                                          "High-income", "High-income Asia Pacific", "Western Europe",
                                                                                                                                                                          "Southern Sub-Saharan Africa", "Southern Latin America", 
                                                                                                                                                                          "High-income North America", "Latin America and Caribbean")),metric_name == "Number")
options_pathogens <- as.list(unique(pathogen_data$pathogen))

# Define UI for application
ui <- fluidPage(
  tabsetPanel(
    #About page 
    tabPanel("About", 
             h1("Pathogen Data App"), 
             h2("Data Summary"), 
             p("The dataset we are working with is one that provides the estimates of deaths and years of life lost due to various bacterial infections, caused by", strong(33),"pathogens across", strong(204), "locations in 2019. The estimates in this dataset were made by using a total of 343 million individual records and 11,361 study location years. These records analyzed data from hospital discharges, cause of death, tissue sampling, literature reviews, microbiology lab results from hospitals nationally as well as muti-national surveillance systems."),
             p("\n The data was collected by researchers at the", em("Institute for Health Metrics and Evaluation (IHME)")," as well as University of Oxford. It is being accessed through the GHDx: Global Health Data Exchange which is a catalog of vital statistics and health related data, available to the public."),
             h2("\n Purpose"),
             p("Our target audience consists mainly of health professionals who may be interested in understanding the underlying causes of deaths occurring globally and what measures they can take/improve upon to prevent these infections from spreading. This group includes clinicians, epidemiologists, and even public health organizations such as the World Health Organization (WHO) or the National Association of Country and City Health Officials (NACCHO)."),
             h2("Figure"),
             p("This data contains a total of 267,375 observations and 10 different variables regarding the different pathogens, age groups, infections/symptoms, and their associated deaths."),
             p("\n Below is a small random sample of the pathogen data set where val is equal to the # of estimated deaths."), 
             tableOutput("sample"), 
    ), 
    #Pathogen and Death Rate
    tabPanel("Pathogen and Associated Number of Deaths by Age",
             fluidRow(
               column(
                 width = 4,
                 p("Select a specific age group to display a table that provides 
                   the type of pathogen and the number of deaths it causes by age."),
                 selectInput(inputId = "age_group", 
                             label = "Select age group", 
                             choices = c(unique(pathogen_data$age_group_name)), selected = "All Ages"),
                 textOutput(outputId = "death_range")
               ),
               column(
                 width = 8,
                 tableOutput(outputId = "pathogen_table")
               )
             ),
    ), 

    #Pathogen and Death rate based on Location 
    tabPanel("Pathogen and Associated Number of Deaths by Location ",
             fluidRow(
               column(
                 width = 4,
                 p("Select a location, various pathogens, and the type of plot to visually 
                   see how many deaths each pathogen causes based on location."),
                 selectInput(inputId = "location", 
                             label = "Select location", 
                             choices = unique(pathogen_data$location_name)),
                 checkboxGroupInput(inputId = "pathogen_checkbox",
                                    label = "Select pathogens to display:",
                                    choices = unique(pathogen_data$pathogen),
                                    selected = unique(pathogen_data$pathogen))
               ),
               column(
                 width = 8,
                 radioButtons(inputId = "plot_type",
                              label = "Select plot type:",
                              choices = c("Bar Graph", "Scatterplot"),
                              selected = "Bar Graph"),
                 plotOutput(outputId = "pathogen_plot", width = "800px"),
                 fluidRow(
                   column(
                     width = 12,
                     textOutput(outputId = "pathogen_max_deaths")
                   )
                 )
               )
             )
    ),
    #Infection and Age group
    tabPanel("Bacterial Infections and Age Groups",
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
    #Pathogen and Bacterial Infections 
    tabPanel("Pathogens and Bacterial Infections", 
             sidebarLayout( 
               sidebarPanel( 
                 checkboxGroupInput("pathogenss", "Select Pathogen", choices = options_pathogens, selected = options_pathogens),
               ),
               mainPanel ( 
                 plotOutput("bars"),
                 textOutput(("react_pathogen"))
               )
             ),
    ),
    
    ), 
  )

# Run the application 
#shinyApp(ui = ui, server = server)
