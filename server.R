# server.R

shinyServer(
  function(input, output) {
    
    #Reactive function that updates the data object based on user input
    #this is necessary because both the text and the plot depends on this object
    reac_data  = reactive({
     lower.limit = input$limits[1]  #lower limit
     upper.limit = input$limits[2]  #upper limit
     
     #adjust data object
     data["X.restricted"] = data["X"] #copy X
     data[data[, 1] < lower.limit | data[, 1] > upper.limit, "X.restricted"] = NA #remove values
     group = data.frame(rep("Included",nrow(data))) #create group var
     colnames(group) = "group" #rename
     levels(group$group) = c("Included","Excluded") #add second factor level
     group[is.na(data["X.restricted"])] = "Excluded" #is NA?
     data["group"] = group #add to data
     return(data)
    })
    
    #Reactive function that returns the correlation in the sample.
    #It will call the reac_data() function.
    reac_cor = reactive({
      #get correlation in sample
      cors = cor(reac_data()[1:3], use = "pairwise")
      r = round(cors[3,2],2)
      return(r)
    })
    
    #Reaction function that returns the proportion of variance in the sample as opposed
    #to the population
    #It will call the reac_data() function.
    reac_var_precent_reduced = reactive({
      var_sample = (reac_data()[, 1]) #the sample data
      .which.rows = reac_data()["group"] == "Included" #the rows to include
      var_sample = var_sample[.which.rows] #subset of included values
      var_percent_reduced = (1 - var(var_sample)) * 100 #the percent reduced by
      #we know the variance in orig. data is 1
      return(round(var_percent_reduced, 1)) #round and return
    })
    
    
    #This function makes the text to add to the plot
    #It will call the reac_cor() function to get the value.
    reac_text_object = reactive({
      #make the text
      text = str_c("Population correlation = .50",
                   "\nSample correlation = ", reac_cor(),"\n",
                   "Variance reduced by ", reac_var_precent_reduced(), "%")
      #make the text object
      text_object = grobTree(textGrob(text, x=.02,  y=.98, hjust=0, vjust = 1), #text position
                             gp = gpar(fontsize=11)) #text size
      return(text_object)
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
        geom_point(aes(color=group)) + #points
        geom_smooth(method=lm, se=F, color="darkblue") + #regression line
        annotation_custom(reac_text_object()) # + #add the text object
        #annotation_custom(reac_text_object_2()) #add the second text object
    })

  }
)
