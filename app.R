library(shiny)
library(rmarkdown)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Test"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         actionButton("knitme", "Knit Me!")
      )
   )
))


server <- shinyServer(function(input, output) {
  
  # the function we will pass into the R Markdown Report
  makePlot <- function(bins){
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  }
  
  
  output$distPlot <- renderPlot({
      makePlot(input$bins)  
   })
   
  observeEvent(input$knitme, {
      bin_num <-input$bins 
      rmarkdown::render("Test_Markdown.Rmd", params=list(func=makePlot, arg=bin_num))
   })
})

# Run the application 
shinyApp(ui = ui, server = server)

