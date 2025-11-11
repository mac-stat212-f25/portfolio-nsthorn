#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(sf)
library(plotly)

data_by_dist <- read_rds("data/diverse_data_by_dist.rds")
data_by_year <- read_csv("data/diverse_data_by_year.csv")

metro_names <- data_by_dist |> pull(metro_name) |> unique()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Locating neighborhood diversity in the American metropolis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
           selectInput(
            "city",
             label = "Select a metropolitan area",
             choices = metro_names,
             selected = "Dalas-Fort Worth"
           )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # pulling data from selected city
        plot_data <- data_by_dist |> filter(metro_name == input$city)
        # draw the histogram with the specified number of bins
        ggplot(plot_data, aes(x = distmiles, y = entropy))+
          geom_point()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
