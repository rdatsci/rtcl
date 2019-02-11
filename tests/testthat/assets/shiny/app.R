library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Test")

)

# Define server logic required to draw a histogram
server <- function(input, output) {

  timeToStop <- reactiveTimer(1000)
  trick <- reactiveValues()
  trick$toFire <- FALSE

  observeEvent(timeToStop(), {
    if (trick$toFire) {
      stopApp()
    } else {
      trick$toFire <- TRUE
    }
  })
  stopApp()
}

# Run the application

shinyApp(ui = ui, server = server)

