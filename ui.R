library(shiny)
library(leaflet)

# Define UI for miles per gallon application
shinyUI(fluidPage(
  
  # Application title
  headerPanel("Social Determinants of Lead Poisoning"),
  
  sidebarPanel(
    helpText("Use the dropdown menu below to adjust the variable that you are mapping. The percentage of elevated blood lead levels comes from Reuters' reporting. Other measures are from the 2010-2015 American Community Survey."),

    selectInput("var", 
                label = "Select Variable for Map:",
                choices = c("% Elevated", "% White", "% Black", "% Poverty"),
                selected = "% Elevated")
  ),
  
  # Show map
  mainPanel(
    leafletOutput("leadMap", width="800", height="600")
    )
    
  )
)