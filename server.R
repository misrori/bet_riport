library(shiny)
library(DT)
library(plotly)
library(data.table)



function(input, output, session) {
  source('my_functions.R')
  
  
  adat <- data.table(read.csv('adat.csv'))
  names(adat) <- c('ticker', 'Date', 'Close', 'ammount')
  
  adat$Date<- as.Date(adat$Date, '%Y.%m.%d')
  adat <- adat[complete.cases(adat),]
  
  my_list <- unique(adat$ticker)

  my_plot <- reactive({
    tozsde_plot(number_of_days = input$integer, my_adatom = adat, list_of_markets =my_list )
  })
  
  output$summary_plot <- renderPlotly({
    my_plot()
  })
  
}
