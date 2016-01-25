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
         downloadButton("report", "Download report")
      )
   )
))


server <- shinyServer(function(input, output) {
  
  # the function we will pass into the R Markdown Report
  makePlot <- function(){
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  }
  
  
  output$distPlot <- renderPlot({
      makePlot() 
   })
   
  output$report <- downloadHandler(
    filename = "report.pdf",
    content = function(filename) {
      rmarkdown::render("Test_Markdown.Rmd",
        rmarkdown::pdf_document(),
        filename,
        params=list(plotFunc=makePlot, inputs=reactiveValuesToList(input))
      )
    }
  )
})

# Run the application 
shinyApp(ui = ui, server = server)

