library(shiny)
library(shinydashboard)
library(here)

# Source the ui and server components
source(here::here("R", "ui.R"))
source(here::here("R", "server.R"))

# Run the application
shinyApp(ui = ui, server = server)