# ui.R

shinyUI(fluidPage(
  titlePanel(title, windowTitle = title),
  
  sidebarLayout(
    sidebarPanel(
      #population correlation
      sliderInput("cor",
                  label = "Population correlation",
                  min = 0,
                  max = 1,
                  value = .5,
                  step = .05
      ),
      
      #restriction method
      selectInput("method",
                  label = "Restriction method",
                  selected = "Direct",
                  choices = c("Direct", "Indirect")
                    
      ),
      

      #Range for direct restriction
      conditionalPanel(
        condition = "input.method == 'Direct'",
        sliderInput("limits",
                    label = "Restriction of range",
                    min = -5,
                    max = 5,
                    value = c(-2, 5),
                    step = .1)
        
      ),
      
      #mean for CDF indirect restriction
      conditionalPanel(
        condition = "input.method == 'Indirect'",
        numericInput("mean",
                    label = "Mean of restriction function",
                    min = -5,
                    max = 5,
                    value = -2,
                    step = .1
                    )
        
      ),
      
      conditionalPanel(
        condition = "input.method == 'Indirect'",
        numericInput("sd",
                     label = "Standard deviation of restriction function",
                     min = 0,
                     value = .3,
                     step = .1
                     )
        
      )
      
    ),
    
    
    mainPanel(
      #The text with statistical information about the results.
      p("Studies of cognitive ability often use samples that are not representative of the population. This is especially salient if the subjects are university students, a highly selected group. This practice means that correlations with cognitive ability found in studies using students are too low if they are meant as an estimate of the effect size in the general population. Fortunately, methods exist that can correct for this bias, see ", a(href = "https://www.goodreads.com/book/show/895784.Methods_of_Meta_Analysis", em("Methods of Meta-analysis")), " by Frank Schmidt and John Hunter."),
        p("Two methods for restricting the range are provided. In direct restriction, we select only cases within two cutoffs and leave everything else out. This scenario can happen when using IQ tests as a hiring tool in top-down selection. However, it is more commonly the case that cognitive abiltiy is not the sole criterion or that its influence is only probabilistic. In indirect restriction, each case has a probability of being excluded based on a function. Direct restriction is a special case of indirect restriction where the sd of the restriction function is 0."),
      p("The figure below visualizes the effect by color-coding the excluded datapoints and showing the correlation in the population, the sample, the reduction in the correlation in %, and the reduction in variance in %."),
      
      #the plot
      plotOutput("plot"),
      hr(),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available <a href='https://github.com/Deleetdk/restriction_of_range'>on Github</a>.")
      )
  )
))
