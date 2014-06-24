library(shiny)

iris$Row <- 1:150

shinyServer(
  function(input, output) {
      
    # Calculates the original range of values taken by each selected feature
    # Used to define range of sliders as well as axis for the plot
    xrange <- reactive({range(iris[,input$features[1]])})
    yrange <- reactive({range(iris[,input$features[2]])})
    
    # renderUI allows to display the sliders according to the features selected
    output$selectRange_x <- renderUI({
      Feature1 <- input$features[1] 
      sliderInput('sel_xrange', paste("Select Range For ",Feature1, ":"),
                  value = xrange(), min = xrange()[1], max = xrange()[2], step = 0.1)
    })
    output$selectRange_y <- renderUI({
      Feature2 <- input$features[2]
      sliderInput('sel_yrange', paste("Select Range For ",Feature2, ":"),
                  value = yrange(), min = yrange()[1], max = yrange()[2], step = 0.1)
    })
    
    # Allows to subset data from the original iris dataset which are in the selected ranges
    iris_subset <- reactive({
      temp <- iris[iris$Species %in% input$species,]
      temp2 <- temp[temp[,input$features[1]] >= input$sel_xrange[1] & temp[,input$features[1]] <= input$sel_xrange[2],]
      temp2[temp2[,input$features[2]] >= input$sel_yrange[1] & temp2[,input$features[2]] <= input$sel_yrange[2],]
    }) 
    
    # Allows to retrieve data from the original iris dataset not in the selected ranges
    iris_not_in_subset <- reactive({
      iris[!(iris$Row %in% iris_subset()$Row),]
    })
    
    # Plotting
    output$Plot <- renderPlot({ 
      plot(iris_subset()[,input$features[1]], iris_subset()[,input$features[2]], col=iris_subset()$Species, 
           xlim=xrange(), ylim=yrange(), xlab = input$features[1], ylab = input$features[2])
      points(iris_not_in_subset()[,input$features[1]], iris_not_in_subset()[,input$features[2]], col="grey")
      abline(v=input$sel_xrange[1])
      abline(v=input$sel_xrange[2])
      abline(h=input$sel_yrange[1])
      abline(h=input$sel_yrange[2])
      legend("topleft", legend=c("setosa","versicolor","virginica"), text.col=seq_along(c("setosa","versicolor","virginica")))  
    })
    
    # Calculates for each species the number of records inside and outside the square 
    table_occ <- reactive({
      species <- levels(iris$Species)
      IN <- sapply(species, f <- function(s) {sum(iris_subset()[,"Species"]==s)})
      OUT <- sapply(species, f <- function(s) {sum(iris_not_in_subset()[,"Species"]==s)})
      df <- rbind(IN, OUT)
      colnames(df) <- species
      df
    })
    
    # Identifies which is the species most represented inside the square
    isolated_species <- reactive({
      names(which.max(table_occ()[1,]))  
    })
    
    # For display
    output$name_isol_species <- renderText({
      isolated_species()
    })
    
    # Computes accuracy
    output$accuracy <- renderText({
      round((table_occ()[1,isolated_species()]+sum(table_occ()[2,])-table_occ()[2,isolated_species()])/sum(table_occ()),3)*100
    })
    
    # Computes precision
    output$precision <- renderText({
      round(table_occ()[1,isolated_species()]/sum(table_occ()[1,]),3)*100
    })
      
    # Computes recall
    output$recall <- renderText({
      round(table_occ()[1,isolated_species()]/sum(table_occ()[,isolated_species()]),3)*100
    })
    
    
  }
)

