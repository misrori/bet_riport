
get_my_data <- function(variables) {
  
  adat <- data.table(read.csv('adat.csv'))
  names(adat) <- c('ticker', 'Date', 'Close', 'ammount')
  
  adat$date<- as.Date(adat$date, '%Y.%m.%d')
  adat <- adat[complete.cases(adat),]
  return(adat)
}

tozsde_plot <- function(number_of_days, my_adatom, list_of_markets){
  
  my_days <- sort(unique(my_adatom$Date), decreasing = T)[c(1:number_of_days)]
  adatom <- data.table(my_adatom[my_adatom$Date %in% my_days,])
  setorder(adatom, ticker, Date)
  
  
  for (i in list_of_markets) {
    baseline <- adatom[ticker == i, Close][1]
    adatom[ticker == i, change := (Close/baseline-1)*100]
  }
  

  f <- list(
    family = "Courier New, monospace",
    size = 18,
    color = "#7f7f7f"
  )
  x <- list(
    title = "Date",
    titlefont = f
  )
  y <- list(
    title = "Change (%)",
    titlefont = f
  )
  
  m <- list(
    l = 100,
    r = 100,
    b = 10,
    t = 150,
    pad = 4
  )
  p<-plot_ly(adatom, x = ~Date, y = ~change, color =~ticker, text= ~Close)%>%
    add_lines()%>%layout(title = paste(number_of_days, 'Days'), xaxis = x, yaxis = y, height = 900, width = 1200)%>%
    subplot(nrows=100, shareX = T )
  
  return(p)
  
}
