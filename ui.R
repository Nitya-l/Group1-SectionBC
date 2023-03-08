<<<<<<< HEAD
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
             p("The pathogen data used to create this app is from researchers at the ", em("Institute for Health Metrics and Evaluation"),"in", strong("2019"), ". It provides estimates of deaths due to various infections caused by 33 different pathogens across the world in ", strong("204"), "different countries. These estimates were made based on 343 millions of individual records and come from sources like hospital discharges, tissue samples,literature review, and microbiology lab results from national and multi-national surveillance systems. We hope to use this data to provide health professionals with a better understanding of fatal pathogens to increase the quality of care they are able to provide."),
             p("\n While my app for the problem set does not analyze the death values, the app made for the final project will include components that analyze the death rate. This app focuses more on data collection in relation to location and age groups since the quality of data(# of observations) is also important to decision making based on such data."),
             h2("Figure"),
             p("This data contains a total of 267,375 observations and 5 different variables regarding the different pathogens, age groups, infections/symptoms, and their associated deaths."),
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
                             choices = c("All Ages", unique(pathogen_data$age_group_name)), selected = "All Ages"),
                 textOutput(outputId = "death_range")
               ),
               column(
                 width = 8,
                 tableOutput(outputId = "pathogen_table")
               )
             ),
    ), 

    #Pathogen and Death rate based on Location 
    tabPanel("Pathogen and Associated Death Rate by Location ",
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
=======
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
>>>>>>> 63e0f441145c6c0f80f9bd66b3e2e44d6ed46021
