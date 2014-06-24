library(shiny)

range_pl <- range(iris$Petal.Length)
range_pw <- range(iris$Petal.Width)
range_sl <- range(iris$Sepal.Length)
range_sw <- range(iris$Sepal.Width)


shinyUI(pageWithSidebar(
  
  headerPanel("THE IRIS GAME: How good can you cluster Iris species using only 2 features?"),
  
  sidebarPanel(
    
    p("Your objective, if you accept it, is to cluster Iris species perfectly using only 2 features."),
    p("Using the following controls, you will try to perfectly cluster each of the Iris species, achieving perfect accuracy, precision and recall."),    
    p("You should quickly be able to cluster perfectly setosa, but let's see what's your best score for versicolor and virginica!"),    
    p("-"),
    
    # Define which species should be displayed
    checkboxGroupInput("species", "1. Select which species you want to play with (and therefore to distinguish between themselves). 
                       They will appear colored in the plot. By default all 3 species are colored. 
                       Species deselected will not be taken into account in the game (which makes it a lot easier!):",
                       c("Setosa" = "setosa","Versicolor" = "versicolor","Virginica" = "virginica"), 
                       selected = c("setosa","versicolor","virginica")),
    
    p("-"),
    
    # Select features to display (x and y axes)
    checkboxGroupInput("features", "2. Select which features you want to display on the axes:", 
                       c("Petal Length" = "Petal.Length","Petal Width" = "Petal.Width",
                         "Sepal Length" = "Sepal.Length","Sepal Width" = "Sepal.Width"),
                       selected = c("Petal.Length","Petal.Width")),
    
    p("Please note that if more than 2 features are selected, only the first 2 values will be considered."),
    p("If you select less than 2 features, you will not be able to play."),
    
    p("-"),
    
    p("3. And now draw your cluster using the sliders for both features you selected at step 2."),
    p("Select minimal et maximal value for each. 
      As you move the minimal and maximal values, you will notice the cluster changing on the plot.
      All iris located out of the cluster are grey"),
    # Sliders to define ranges
    uiOutput("selectRange_x"),
    uiOutput("selectRange_y")
      
  ),
  
  mainPanel(
    
    # Displays the plot 
    # x=feature1, y=feature2, colored by species
    # with a square corresponding to the selected range
    plotOutput("Plot"),
    
    # Displays the name of the isolated species, with the associated accuracy, precision and recall
    p("-"),
    p("You are trying to isolate the following species (at least this is the species most present in the current cluster!): "),
    textOutput("name_isol_species"),
    p("-"),
    p("Your accuracy is (in %): "),
    textOutput("accuracy"),
    p("-"),
    p("Your precision is (in %): "),
    textOutput("precision"),
    p("-"),
    p("Your recall is (in %): "),
    textOutput("recall")
  )

))



