# ui.R

shinyUI(fluidPage(
  titlePanel(title, windowTitle = title),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Get an intuitive understanding of restriction of range using this interactive plot. The slider below limits the dataset to those within the limits."),
      
      sliderInput("limits",
        label = "Restriction of range",
        min = -5, max = 5, value = c(-2, 5), step=.1),
      
      helpText("Note that these are Z-values. A Z-value of +/- 2 corresponds to the 98th or 2th centile, respectively.")
      ),
    
    
    mainPanel(
      #The text with statistical information about the results.
      p("Studies of cognitive ability often use samples that are not representative of the population. This is especially salient if the subjects are university students, a highly selected group."),
      p("This practice means that correlations found in studies using students are too low if they are meant as an estimate of the effect size in the total population."),
      p("Fortunately, methods exist that can correct for this bias, see ", em("Methods of Meta-analysis"), " by Frank Schmidt and John Hunter."),
      p("The figure below visualizes the effect by color-coding the excluded datapoints and showing the correlation in the sample."),
      
      #the plot
      plotOutput("plot"), width=8
      
      )
  )
))
