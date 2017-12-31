library(shiny)
library(leaflet)

# Define UI for miles per gallon application
navbarPage("Social Determinants of Lead Poisoning", id="nav",
           
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
                  
                  url1 <- a("Reuters", href="https://www.reuters.com/investigates/special-report/usa-lead-testing/"),
                  url2 <- a("U.S. Census Bureau's", href="https://www.census.gov"),
                  url3 <- a("American Community Survey", href="https://www.census.gov/programs-surveys/acs/"),
                  
                  tags$div(id="cite",
                           tagList("Data via ", url1, " and the", url2, " ", url3)
                  )
            ),
           
           tabPanel("Data table",
              DT::dataTableOutput("leadTable")
           ),
           
           tabPanel("About",
                    h3("Data Sources"),
                    p("Data for this web app were drawn from two sources. The data on lead posioning were obtained from Reuters' study of ",
                      a("lead posioning in the United States", href="https://www.reuters.com/investigates/special-report/usa-lead-testing/"),
                      " and cover the years 2010 through 2015. The demographic data were drawn from the ",
                      a("U.S. Census Bureau's", href="https://www.census.gov"),
                      " five year demographic estimates from the 2010-2015 ",
                      a("American Community Survey", href="https://www.census.gov/programs-surveys/acs/"),
                      "."),
                    br(),
                    h3("Read More"),
                    p("Sampson, Robert J., and Alix S. Winter. 2016. \"",
                      a("The racial ecology of lead poisoning: Toxic inequality in Chicago neighborhoods, 1995-2013", href="https://www.cambridge.org/core/journals/du-bois-review-social-science-research-on-race/article/the-racial-ecology-of-lead-poisoning/F39AF4724258606DCC1CDA369DC08707"),
                      ".\"", 
                      em("Du Bois Review: Social Science Research on Race"),
                      "13(2):261-283.")
           )
)
  
  
  
  
