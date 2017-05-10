
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 500,
                  max = 2000,
                  value = 500),
      
      selectInput("state", "Choose a state:",
                  list(`East Coast` = c("NY", "NJ", "CT"),
                       `West Coast` = c("WA", "OR", "CA"),
                       `Midwest` = c("MN", "WI", "IA"))
      ),
      
      selectInput("periodo", "Choose a state:",
                  gerarLista(2010,02,2017)
      )
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
