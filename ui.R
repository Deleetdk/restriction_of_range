# ui.R

shinyUI(fluidPage(
  titlePanel(title, windowTitle = title),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Get an intuitive understanding of restriction of range using this interactive plot. The slider below limits the dataset to those within the limits."),
      
      sliderInput("limits",
        label = "Restriction of range",
        min = -5, max = 5, value = c(-5, 5), step=.1),
      
      helpText("Note that these are Z-values. A Z-value of +/- 2 corresponds to the 98th or 2th centile, respectively.")
      ),
    
    
    mainPanel(
      plotOutput("plot"),width=8,
      
      textOutput("text")
      )
  )
))
