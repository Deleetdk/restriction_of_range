# server.R

shinyServer(
  function(input, output) {
    output$plot <- renderPlot({
      #limits
      lower.limit = input$limits[1] #lower limit
      upper.limit = input$limits[2]  #upper limit
      
      #adjust data object
      data["X.restricted"] = data["X"] #copy X
      data[data[,1]<lower.limit | data[,1]>upper.limit,"X.restricted"] = NA #remove values
      group = data.frame(rep("Included",nrow(data))) #create group var
      colnames(group) = "group" #rename
      levels(group$group) = c("Included","Excluded") #add second factor level
      group[is.na(data["X.restricted"])] = "Excluded" #is NA?
      data["group"] = group #add to data
      
      #plot
      xyplot(Y ~ X, data, type=c("p","r"), col.line = "darkorange", lwd = 1,
             group=group, auto.key = TRUE)
    })
    
    output$text <- renderPrint({
      #limits
      lower.limit = input$limits[1] #lower limit
      upper.limit = input$limits[2]  #upper limit
      
      #adjust data object
      data["X.restricted"] = data["X"] #copy X
      data[data[,1]<lower.limit | data[,1]>upper.limit,"X.restricted"] = NA #remove values
      group = data.frame(rep("Included",nrow(data))) #create group var
      colnames(group) = "group" #rename
      levels(group$group) = c("Included","Excluded") #add second factor level
      group[is.na(data["X.restricted"])] = "Excluded" #is NA?
      data["group"] = group #add to data
      
      #correlations
      cors = cor(data[1:3], use="pairwise")
      r = round(cors[3,2],2)
      #print output
      str = paste0("The correlation in the full dataset is .50, the correlation in the restricted dataset is ",r)
      print(str)
    })
    
  }
)
