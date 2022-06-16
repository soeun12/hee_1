library(flexdashboard)
library(shiny)
library(shinyWidgets)
library(ggplot2)
library(magrittr)
library(plotly)
library(dplyr)
library(palmerpenguins)
library(DT)
library(stringr)
library(shinythemes)

ui = fluidPage(theme = shinytheme("superhero"),
               titlePanel(
                 "펭귄 데이터 분석"
               ),
               
               sidebarLayout(
                 sidebarPanel( 
                   
                   checkboxGroupInput("species", label = h4("펭귄 종류를 선택하세요"),
                                      choices = list("Adelie", "Gentoo", "Chinstrap"), 
                                      selected = 1),
                   
                   selectInput("x", label = h3("x축을 선택하세요."), 
                               choices = list("bill_length_mm","bill_depth_mm" , "flipper_length_mm" , "body_mass_g"), 
                               selected = 'bill_depth_mm'),
                   
                   selectInput("y", label = h3("y축을 선택하세요."), 
                               choices = list("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"), 
                               selected = 'bill_length_mm'),
                   
                   
                   sliderInput(inputId='size',
                               label="점 크기를 선택하세요",
                               min = 1, max =10, value =5)
                   
                   
                 ),
                 
                 mainPanel(
                   dataTableOutput('p_table'),
                   plotOutput('p_plot')
                 )
               )
)

server =function(input,output,session) {
  
  sel_p = reactive({
    penguins %>%
      select(species, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year) %>%
      filter(species %in% input$species)
  })
  
  
  output$p_table = renderDataTable({
    sel_p() %>%
      datatable()
  })
  
  output$p_plot = renderPlot({
    penguins %>%
      ggplot(aes_string(x= input$x, y=input$y)) +
      geom_point(aes(color=species, shape=sex),size=as.numeric(input$size))+
      theme_bw()
  })}

shinyApp(ui, server)