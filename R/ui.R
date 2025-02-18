library(shiny)
library(shinydashboard)
library(ggplot2)

ui <- dashboardPage(
  dashboardHeader(title = "Swiss Houses"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Price distribution (per house type)", tabName = "scatterPlot"),
      menuItem("Distribution of prices vs. size", tabName = "barchart"),
      menuItem("Price distribution vs. living space", tabName = "Region")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "scatterPlot",
        fluidRow(
          box(
            status = "primary",
            solidHeader = TRUE,
            width = 7,
            selectInput("houseType1",
                        "Select House Type:",
                        choices = NULL,  
                        multiple = FALSE, 
                        selected = NULL)
          )
        ),
        fluidRow(
          box(
            title = "House Prices vs Year Built (per house type)",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("scatterPlot", height = "300px"),
            p("This shows the relationship between house prices and the year built for a specific house type.")
          ),
          box(
            title = 'Histogram: Price Distribution (per house type)',
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("histogram", height = "300px"),
            p("This shows the general distribution of house prices for a specific house type.")
          )
        ),
        fluidRow(
          box(
            title = "Price Distribution for each house size (S: small, M: medium, L: large)",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotOutput("histogramsize", height = "300px"),
            p("This shows the distribution of prices for each house size for a specific house type.")
          )
        )
      ),
      tabItem(tabName = "barchart",
        fluidRow(
          box(
            status = "primary",
            solidHeader = TRUE,
            width = 7,
            selectInput("priceRange",
                        "Select price range:",
                        choices = c("0-0.5M", "0.5-1M", "1-1.5M", "1.5-2M", "2-2.5M", "2.5M+"),  
                        multiple = FALSE, 
                        selected = "1.5-2M")
          )
        ),
        fluidRow(
          box(
            title = "Price vs Size vs Balcony",
            status = "primary",
            solidHeader = TRUE,
            width = 10,
            plotOutput("barchart", height = "400px"),
            p("This shows the proportion of each house size in the data points (which have or do not have a balcony), for a preselected price range.")
          )
        )
      ),
      tabItem(tabName = "Region",
        fluidRow(
          box(
            status = "primary",
            solidHeader = TRUE,
            width = 7,
            selectInput("Location",
                        "Select location:",
                        choices = c('Lugano', 'Zürich', 'Basel', 'Lausanne', 'Sion'),  
                        multiple = FALSE, 
                        selected = "Lugano")
          )
        ),
        fluidRow(
          box(
            title = "Price vs Living Space",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("scatterplotPriceSpace", height = "400px"),
            p("This shows the relationship between house prices and living space in a preselected region of Switzerland.")
          ),
          box(
            title = "Price Distribution",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("distributionofprices", height = "400px"),
            p("This shows the boxplot of the price for each of the available house sizes (if any), for a preselected region in Switzerland.")
          )
        )
      )
    )
  )
)