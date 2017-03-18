#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Page Analytics"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    textInput("token", "Get your User Access Token:", ""),
    numericInput("facebook.id", "Insert here Facebook ID:", 298917980283437),
    dateRangeInput("date.range", "Please, provide the timerange:"),
    actionButton("goButton", "Go!")
  ),
  
  # export data
  mainPanel(
    htmlOutput("report.title"),
    textOutput("date.range.text"),
    htmlOutput("top.posts.title"),
    tableOutput("table"),
    br(),
    htmlOutput("types.of.posts.title"),
    plotOutput("plot"),
    br(),
    htmlOutput("links.shared.title"),
    dataTableOutput("link.table")
  )
))
