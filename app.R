
library(shiny)


ui <- fluidPage(
  
  titlePanel(
             div(
               h1("Tesla Stock Data"),
               img(src = "tesla_logo.png", height = "120px"),
               p("Tesla Company Logo, Courtesy of Sushilkrpro", style = "font-size: 10px")
               )
             ),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("selectvar", label = h3("Choose a variable to be plotted over time"),
                  choices = list("Select variable" = 0, "Open price" = 1, "Close price" = 2, 
                                 "Volume traded" = 3, "Range of price" = 4,
                                 "Day of week" = 5), 
                  selected = 0),
      
      radioButtons("radio", label = h3("Color of plot:"),
                   choices = list("Black" = "black","Red" = "red", 
                                "Green" = "green", "Blue" = "blue",
                                "Gray" = "gray"), 
                   selected = "black"),
      
      uiOutput("slider"),
      uiOutput("dateSlider"),
   
      checkboxInput("checkbox", label = "Display descriptive statistics", value = FALSE),
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      hr(),
      conditionalPanel(
        condition = "input.checkbox == TRUE && input.selectvar <= 4",
        verbatimTextOutput("stat"),
      ),
      
      conditionalPanel(
        condition = "input.checkbox == TRUE && input.selectvar == 5",
        tableOutput("weekdaysKable")
      )

      
    )
    
  )
)


server <- function(input, output) {
  library(tidyverse)
  library(ggplot2)
  library(kableExtra)
  library(lubridate)
  
  tsla <- read_csv("TSLA.csv")
  
  tsla <- tsla %>% 
    rename("date" = "Date",
           "open" = "Open",
           "high" = "High",
           "low" = "Low",
           "close" = "Close",
           "adjClose" = "Adj Close",
           "volume" = "Volume",
    )
  
  #Convert date variable to date format
  tsla <- mutate(tsla, date = mdy(date))
  
  #Make new variable of weekday
  tsla <- mutate(tsla, weekday = weekdays(date, abbreviate = FALSE))
  
  #Make new variable of max range
  tsla <- mutate(tsla, maxRange = high - low, 2)
  
  tsla <- mutate(tsla, date_numeric = as.numeric(difftime(date, min(date), units = "days")))
  
  tsla$weekday <- factor(tsla$weekday, 
                         levels = c("Monday", 
                                    "Tuesday", 
                                    "Wednesday", 
                                    "Thursday", 
                                    "Friday"))
  
  
  output$distPlot <- renderPlot({

    if(input$selectvar == 1) {
      plot(tsla$date, tsla$open, pch = 20, 
           xlim = c(input$dateRange[1], input$dateRange[2]),
           ylim = c(input$openRange[1], input$openRange[2]),
           main = "Scatterplot of Open Price over Time",
           xlab = "Time", ylab = "Price (USD)",
           col = input$radio)
    }
    
    else if(input$selectvar == 2) {
      plot(tsla$date, tsla$close, pch = 20, 
           xlim = c(input$dateRange[1], input$dateRange[2]),
           ylim = c(input$priceRange[1], input$priceRange[2]),
           main = "Scatterplot of Close Price over Time",
           xlab = "Time", ylab = "Price (USD)",
           col = input$radio)
    }
    
    else if(input$selectvar == 3) {
      plot(tsla$date, tsla$volume / 1000000, pch = 20,
           xlim = c(input$dateRange[1], input$dateRange[2]),
           ylim = c(input$volumeRange[1], input$volumeRange[2]),
           main = "Scatterplot of Volume Traded over Time",
           xlab = "Time", ylab = "Volume (in millions)",
           col = input$radio)
    }
    
    else if(input$selectvar == 4) {
      plot(tsla$date, tsla$maxRange, pch = 20,
           xlim = c(input$dateRange[1], input$dateRange[2]),
           ylim = c(input$diffRange[1], input$diffRange[2]),
           main = "Scatterplot of Difference between Open and Close Price over Time",
           xlab = "Time", ylab = "Difference in Price (USD)",
           col = input$radio)
    }
    
    else if(input$selectvar == 5) {
      barplot(table(tsla$weekday),
              main = "Frequency of Tesla Stock Data by Day of Week",
              xlab = "Day of Week", ylab = "Frequency",
              col = input$radio)
    }
    
    
  })
  
  output$weekdaysKable <- function() {
    if(input$selectvar == 5 && input$checkbox == TRUE) {
      paste("Table of proportions: ", kbl(round(prop.table(table(tsla$weekday)), 2), 
          col.names = c("Day of Week", "Proportion")) %>% kable_styling())
    }
  }
  
  output$stat <- renderPrint({
    if(input$checkbox == TRUE & input$selectvar == 1) {
      print(paste("Correlation: ", round(cor(tsla$date_numeric, tsla$open, 
                                             use = "complete.obs"), 2)))
    }
    
    else if(input$checkbox == TRUE & input$selectvar == 2) {
      print(paste("Correlation: ", round(cor(tsla$date_numeric, tsla$close, 
                                             use = "complete.obs"), 2)))
    }
    
    else if(input$checkbox == TRUE & input$selectvar == 3) {
      print(paste("Correlation: ", round(cor(tsla$date_numeric, tsla$volume, 
                                             use = "complete.obs"), 2)))
    }
    
    else if(input$checkbox == TRUE & input$selectvar == 4) {
      print(paste("Correlation: ", round(cor(tsla$date_numeric, tsla$maxRange, 
                                             use = "complete.obs"), 2)))
    }
  })

  output$slider <- renderUI({
    if(input$selectvar == 1) {
      lower <- round(min(tsla$open), 0) - 1 
      upper <- round(max(tsla$open), 0) + 1
      sliderInput("openRange", "Price range: ",
                  min = lower, max = upper,
                  value = c(lower, upper))
    }
    
    else if(input$selectvar == 2) {
      lower <- round(min(tsla$close), 0) - 1 
      upper <- round(max(tsla$close), 0) + 1
      sliderInput("closeRange", "Price range: ",
                  min = lower, max = upper,
                  value = c(lower, upper))
    }
    
    else if(input$selectvar == 3) {
      lower <- round(min(tsla$volume) / 1000000, 0) - 1 
      upper <- round(max(tsla$volume) / 1000000, 0) + 1
      sliderInput("volumeRange", "Volume range: ",
                  min = lower, max = upper,
                  value = c(lower, upper))
    }
    
    else if(input$selectvar == 4) {
      lower <- round(min(tsla$maxRange), 0) - 1 
      upper <- round(max(tsla$maxRange), 0) + 1
      sliderInput("diffRange", "Price range: ",
                  min = lower, max = upper,
                  value = c(lower, upper))
    }
  })
  

  output$dateSlider <- renderUI({
    if(input$selectvar <= 4) {
      lower <- min(tsla$date)
      upper <- max(tsla$date)
      sliderInput("dateRange", "Timeline: ",
                  min = lower, max = upper,
                  value = c(lower, upper))
    }
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
