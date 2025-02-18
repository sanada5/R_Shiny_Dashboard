library(shiny)
library(shinydashboard)
library(ggplot2)

# Source the data_importation.R script to load the necessary datasets
source(here::here("R", "data_importation.R"))

server <- function(input, output, session) {
  observe({
    house_types <- unique(price_housetype_year$HouseType)
    house_types_format <- gsub("_", " ", house_types)
    updateSelectInput(session,
                     'houseType1',
                     choices = setNames(house_types, house_types_format),
                     selected = house_types[1])
  })

  # Reactive filtered dataset by house type (for scatter plot and histogram)
  filtered_data1 <- reactive({
    if (is.null(input$houseType1) || length(input$houseType1) == 0) return(price_housetype_year)
    price_housetype_year[price_housetype_year$HouseType == input$houseType1,]
  })

  filtered_data2 <- reactive({
    if (is.null(input$houseType1) || length(input$houseType1) == 0) return(price_housetype_size)
    price_housetype_size[price_housetype_size$HouseType == input$houseType1,]
  })

  filtered_data3 <- reactive({
    data <- size_price_balcony
    if (input$priceRange == "0-0.5M") {
      data <- data[data$PriceMillion < 0.5,]
    } else if (input$priceRange == "0.5-1M") {
      data <- data[data$PriceMillion >= 0.5 & data$PriceMillion < 1,]
    } else if (input$priceRange == "1-1.5M") {
      data <- data[data$PriceMillion >= 1 & data$PriceMillion < 1.5,]
    } else if (input$priceRange == "1.5-2M") {
      data <- data[data$PriceMillion >= 1.5 & data$PriceMillion < 2,]
    } else if (input$priceRange == "2-2.5M") {
      data <- data[data$PriceMillion >= 2 & data$PriceMillion < 2.5,]
    } else if (input$priceRange == "2.5M+") {
      data <- data[data$PriceMillion >= 2.5,]
    }
    data
  })

  filtered_data4 <- reactive({
    price_rooms_loc_space[price_rooms_loc_space$Locality == input$Location,]
  })

  filtered_data5 <- reactive({
    price_loc_size_space_size[price_loc_size_space_size$Locality == input$Location,]
  })

  # Generate scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(filtered_data1(), aes(x = YearBuilt, y = PriceMillion, color = HouseType)) +
      geom_point(size = 3) + geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
      theme_minimal() +
      labs(x = "Year Built",
           y = "Price (Millions)",
           title = "House Prices vs Year Built") +
      scale_color_discrete(labels = function(x) gsub("_", " ", x))
  })

  # Generate histogram
  output$histogram <- renderPlot({
    ggplot(filtered_data1(), aes(x = PriceMillion)) +
      geom_histogram(binwidth = 0.5, fill = "blue", color = "black") +
      theme_minimal() +
      labs(x = "Price (Millions)",
           y = "Frequency",
           title = "Price Distribution") +
      theme(legend.position = "bottom")
  })

  # Histogram for each size: facet
  output$histogramsize <- renderPlot({
    data <- filtered_data2()
    if (nrow(data) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for the selected house type", cex = 1.5)
    } else {
      ggplot(data, aes(x = PriceMillion)) +
        geom_histogram(binwidth = 0.5, fill = "red", color = "black", alpha = 0.7, position = "dodge") +
        theme_minimal() +
        labs(x = "Price (Millions)",
             y = "Frequency",
             title = "Price Distribution for each house size (S: small, M: medium, L: large)") +
        facet_grid(.~Size)
    }
  })

  # Generate bar chart
  output$barchart <- renderPlot({
    data <- filtered_data3()
    if (nrow(data) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for the selected price range", cex = 1.5)
    } else {
      ggplot(data, aes(x = Balcony, fill = Size)) +
        geom_bar(position = "fill") +
        theme_minimal() +
        labs(x = "Balcony",
             y = "Proportion (within category)",
             title = "Price vs Size vs Balcony")
    }
  })

  # Generate scatter plot for price vs living space
  output$scatterplotPriceSpace <- renderPlot({
    data <- filtered_data4()
    if (nrow(data) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for the selected location", cex = 1.5)
    } else {
      ggplot(data, aes(x = LivingSpace, y = PriceMillion, fill = NumberRooms)) +
        geom_point(size = 6, shape = 24) +
        theme_minimal() +
        labs(x = "Living Space",
             y = "Price (Millions)",
             title = "Price vs Living Space vs Number of rooms",
             fill = "Number of rooms") +
        scale_color_discrete(labels = function(x) gsub("_", " ", x))
    }
  })

  # Generate box plot for price distribution
  output$distributionofprices <- renderPlot({
    data <- filtered_data5()
    if (nrow(data) == 0) {
      plot.new()
      text(0.5, 0.5, "No data available for the selected location", cex = 1.5)
    } else {
      ggplot(data, aes(x = Size, y = PriceMillion)) +
        geom_boxplot(fill = "blue", color = "black") +
        theme_minimal() +
        labs(x = "Size of house",
             y = "Price (Millions)",
             title = "Price Distribution") +
        theme(legend.position = "bottom")
    }
  })

  observeEvent(input$stopButton, {
    stopApp()
  })
}