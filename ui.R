library(shiny)
library(leaflet)

# Define UI for miles per gallon application
navbarPage("Social Determainents of Lead Poisoning", id="nav",
           
           tabPanel("Interactive map",
              div(class="outer",
                  
                  tags$head(
                    # Include our custom CSS
                    includeCSS("styles.css")
                  ),
                  
                  # If not using custom CSS, set height of leafletOutput to a number instead of percent
                  leafletOutput("leadMap", width="100%", height="100%"),
                  
                  # Shiny versions prior to 0.11 should use class = "modal" instead.
                  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                width = 330, height = "auto",
                                
                                h2("Lead Data Explorer"),
                                
                                selectInput("var", 
                                            label = "Select Variable for Map:",
                                            choices = c("% Elevated", "% White", "% Black", "% Poverty"),
                                            selected = "% Elevated"),
                                
                                plotOutput("histLead", height = 250),
                                plotOutput("scatterLead", height = 250)
                                )
                  ),
                  
                  tags$div(id="cite",
                           'Citation'
                  )
            ),
           
           tabPanel("Data table",
              DT::dataTableOutput("leadTable")
           )
)
  
  
  
  
