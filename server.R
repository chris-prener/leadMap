library(shiny)
library(dplyr)
library(leaflet)
library(sf)

# prepare for join
lead <- read.csv("data/stllead.csv", stringsAsFactors = FALSE)

lead <- lead %>%
  mutate(GEOID = as.character(geoID)) %>%
  mutate(PCTELE = pctElevated*.01) %>%
  mutate(WHITE = (white/totalPop)) %>%
  mutate(BLACK = (black/totalPop)) %>%
  mutate(POVERTY = (povertyTot/totalPop)) %>%
  select(GEOID, PCTELE, WHITE, BLACK, POVERTY)

# load shapefiles
tracts <- st_read("data/DEMOS_Tracts10.shp", stringsAsFactors = FALSE)

# join tabular and geometric data
leadTracts <- left_join(tracts, lead, by = "GEOID")

# remove tabular data frame
rm(lead)
rm(tracts)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {
  
  output$leadMap <- renderLeaflet({
    
    if (input$var == "% Elevated") {

      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("RdPu", PCTELE)(PCTELE),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% White") {
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Blues", WHITE)(WHITE),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% Black") {
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Oranges", BLACK)(BLACK),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% Poverty") {
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Greens", POVERTY)(POVERTY),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    }
    
  })
  
})