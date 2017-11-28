library(shiny)
library(dplyr)
library(leaflet)
library(sf)
library(htmltools)

# prepare for join
lead <- read.csv("data/stllead.csv", stringsAsFactors = FALSE)

lead <- lead %>%
  mutate(GEOID = as.character(geoID)) %>%
  mutate(PCTELE = round(pctElevated*.01, digits = 2)) %>%
  mutate(WHITE = round((white/totalPop)*100, digits = 2)) %>%
  mutate(BLACK = round((black/totalPop)*100, digits = 2)) %>%
  mutate(POVERTY = round((povertyTot/totalPop)*100, digits = 2)) %>%
  rename(TOTPOP = totalPop) %>%
  select(GEOID, PCTELE, TOTPOP, WHITE, BLACK, POVERTY)

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
      
      # define popup text
      tract_popup <- paste0(leadTracts$NAMELSAD, ": ", 
                            leadTracts$PCTELE, "% elevated")

      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("RdPu", PCTELE)(PCTELE),
                    popup = ~htmlEscape(tract_popup), 
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% White") {
      
      # define popup text
      tract_popup <- paste0(leadTracts$NAMELSAD, ": ",
                            leadTracts$WHITE, "% white")
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Blues", WHITE)(WHITE),
                    popup = ~htmlEscape(tract_popup), 
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% Black") {
      
      # define popup text
      tract_popup <- paste0(leadTracts$NAMELSAD, ": ",
                            leadTracts$BLACK, "% black")
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Oranges", BLACK)(BLACK),
                    popup = ~htmlEscape(tract_popup), 
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    } else if (input$var == "% Poverty") {
      
      # define popup text
      tract_popup <- paste0(leadTracts$NAMELSAD, ": ",
                            leadTracts$POVERTY, "% below poverty line")
      
      # leaflet object
      leaflet(leadTracts) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorQuantile("Greens", POVERTY)(POVERTY),
                    popup = ~htmlEscape(tract_popup), 
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE))
      
    }
    
  })
  
  output$histLead <- renderPlot({
    hist(leadTracts$PCTELE,
         main = "Elevated Blood Lead Level Tests",
         xlab = "Proportion Elevated",
         col = "blue",
         border = 'white')
  })
  
  
  output$scatterLead <- renderPlot({
    
    if (input$var == "% Elevated" | input$var == "% Black") {
      plot(leadTracts$BLACK, 
           leadTracts$PCTELE, 
           col="blue",
           main = "Social Factors and Lead Poisoning",
           ylab = "% Elevated",
           xlab = "% Black")
      abline(lm(leadTracts$PCTELE ~ leadTracts$BLACK), col = "blue", lwd=3)
    } else if (input$var == "% White") {
      plot(leadTracts$WHITE, 
           leadTracts$PCTELE, 
           col="blue",
           main = "Social Factors and Lead Poisoning",
           ylab = "% Elevated",
           xlab = "% White")     
      abline(lm(leadTracts$PCTELE ~ leadTracts$WHITE), col = "blue", lwd=3)
    } else if (input$var == "% Poverty") {
      plot(leadTracts$POVERTY, 
           leadTracts$PCTELE, 
           col="blue",
           main = "Social Factors and Lead Poisoning",
           ylab = "% Elevated",
           xlab = "% Below Poverty Line")
      abline(lm(leadTracts$PCTELE ~ leadTracts$POVERTY), col = "blue", lwd=3)
    }
    
  })
  
  output$leadTable <- DT::renderDataTable({
    leadTracts %>%
      select(NAMELSAD, TOTPOP, PCTELE, WHITE, BLACK, POVERTY) %>%
      rename(`Census Tract` = NAMELSAD) %>%
      rename(`Total Pop.` = TOTPOP) %>%
      mutate(PCTELE = PCTELE*100) %>%
      rename(`% Elevated` = PCTELE) %>%
      rename(`% White` = WHITE) %>%
      rename(`% Black` = BLACK) %>%
      rename(`% Poverty` = POVERTY) -> leadDT
    
    st_geometry(leadDT) <- NULL
    
    DT::datatable(leadDT)
  })
})