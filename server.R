# server.R

shinyServer(
  function(input, output) {
    
    #Reactive function that updates the data object based on user input
    #this is necessary because both the text and the plot depends on this object
    reac_data  = reactive({
      #seed
      set.seed(1)
      
      #generate data
      data = MASS::mvrnorm(n = 1e4,
                           mu = rep(0, 2),
                           Sigma = matrix(c(1, input$cor, input$cor, 1), ncol = 2),
                           empirical = T
                           ) %>% 
        as.data.frame %>% 
        set_colnames(c("X", "Y"))
      
      #fork based on direct or indirect restriction
      if (input$method == "Direct") {
        
        #limits
        lower_limit = input$limits[1]  #lower limit
        upper_limit = input$limits[2]  #upper limit
        
        #add copy of X
        data$X_restricted = data$X #copy X
        
        #remove cases outside range
        data[data$X < lower_limit | data$X > upper_limit, "X_restricted"] = NA #remove values
        
        #add grouping variable based on NA status
        data$group = rep("Included", nrow(data)) %>% 
          factor(levels = c("Included","Excluded"))
        
        #recode based on NA status
        data$group[is.na(data$X_restricted)] = "Excluded"
      }
      
      if (input$method == "Indirect") {
        
        #add copy of X
        data$X_restricted = data$X #copy X
        
        #add grouping variable
        #assume all included initially
        data$group = rep("Included", nrow(data)) %>% 
          factor(levels = c("Included","Excluded"))
        
        #probability of each case being included
        data$included_prob = pnorm(q = data$X, mean = input$mean, sd = input$sd)
        
        #generate status
        set.seed(1)
        data$group[!sapply(data$included_prob, purrr::rbernoulli, n = 1)] = "Excluded"
        
        #remove values from restricted vector
        data$X_restricted[data$group == "Excluded"] = NA #remove values
      }
      
      #return
      data
    })
    
    #Reactive function that returns the correlation in the sample.
    #It will call the reac_data() function.
    reac_cor = reactive({
      #get correlation in sample
      cors = cor(reac_data()[1:3], use = "pairwise")
      
      sprintf("%.2f", cors[2, 3])
    })
    
    #How much is correlation reduced?
    reac_cor_precent_reduced = reactive({
      #get correlation in sample
      cors = cor(reac_data()[1:3], use = "pairwise")
    
      sample_r = cors[2, 3]
      pop_r = cors[2, 1]
      
      sprintf("%.1f%%", ((pop_r - sample_r) / pop_r) * 100)
    })
    
    #Reaction function that returns the proportion of variance in the sample as opposed
    #to the population
    #It will call the reac_data() function.
    reac_var_precent_reduced = reactive({
      #the sample variance in X
      var_sample = (reac_data()[, 1])
      
      #rows
      .which.rows = reac_data()["group"] == "Included" #the rows to include
      
      #
      var_sample = var_sample[.which.rows] #subset of included values
      
      #the percent reduced by
      var_percent_reduced = (1 - var(var_sample)) * 100
      #we know the variance in orig. data is 1
      
      #format
      sprintf("%.1f%%", var_percent_reduced)
    })
    
    
    #This function makes the text to add to the plot
    #It will call the reac_cor() function to get the value.
    reac_text_object = reactive({

      #make the text
      text = str_c(sprintf("Population correlation = %.2f\n", input$cor),
                   "Sample correlation = ", reac_cor(), "\n",
                   "Correlation reduced by ", reac_cor_precent_reduced(), "\n",
                   "Variance reduced by ", reac_var_precent_reduced()
                   )
      #make the text object
      text_object = grobTree(textGrob(text, x=.02,  y=.98, hjust=0, vjust = 1), #text position
                             gp = gpar(fontsize=11)) #text size
      
      text_object
    })
    
    #This function makes the text to add to the plot
    #It will call the reac_cor() function to get the value.
#     reac_text_object_2 = reactive({
#       #make the text
#       text = str_c("Variance reduced by: ", reac_var_proportion())
#       #make the text object
#       text_object = grobTree(textGrob(text, x=.98,  y=.02, hjust=1, vjust = 0), #text position
#                              gp = gpar(fontsize=11)) #text size
#       return(text_object)
#     })
    
    
    #The plot output
    output$plot <- renderPlot({
      
      #plot
      ggplot(data = reac_data(), aes(x = X, y = Y)) + #set up
        theme_bw() +
        geom_point(aes(color=group)) + #points
        geom_smooth(method=lm, se=F, color="darkblue") + #regression line
        annotation_custom(reac_text_object()) # + #add the text object
        #annotation_custom(reac_text_object_2()) #add the second text object
    })

  }
)
