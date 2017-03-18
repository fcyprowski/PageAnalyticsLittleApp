#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(Rfacebook)
library(dplyr)
library(ggplot2)
library(stringr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # table of posts that you will get
  datasetInput = eventReactive(input$goButton, {  # these function will run 
                                                  # only when pushed with Go! button
    getPage(input$facebook.id,
            input$token, 
            since = input$date.range[1], 
            until = input$date.range[2],
            n = 50)
  })
  # titles of elements
  getDateRange = eventReactive(input$goButton, {
    date.range.text = paste(as.character(input$date.range[1]),
                            " - ", as.character(input$date.range[2]))
    return(date.range.text) 
  })
  getTopPostsTitle = eventReactive(input$goButton, {
    "Top posts" %>%
      tag("b", .) %>%
      as.character()
  })
  getTypesOfPostsTitle = eventReactive(input$goButton, {
    "Types of posts used by page" %>%
      tag("b", .) %>%
      as.character()
  })
  getLinksSharedTitle = eventReactive(input$goButton, {
    "Most disussed links" %>%
      tag("b", .) %>%
      as.character()
  })
  # ------------------------------- HERE IS WHAT WE GET FROM THIS DATASET
  # htmlOutput("top.posts.title"),
  output$report.title = renderText({
    # title of the page
    page.name = datasetInput()$from_name[1]
    # title = HTML(
    #   paste0("<b>", "Fast Facebook posts report for ", page.name, "</b>")
    #   )
    title = paste0("Fast Facebook posts report for ", page.name) %>%
      h1() %>%
      as.character()
    return(title)
  })
  # textOutput("date.range.text")
  output$date.range.text = renderText({
    getDateRange()
  })
  # htmlOutput("top.posts.title"),
  output$top.posts.title = renderText({
    getTopPostsTitle()
  })
  # tableOutput("table"),
  output$table = renderTable({
    # render table with top 5 posts based on sum of activity
    datasetInput() %>%
      arrange(desc(likes_count + comments_count + shares_count)) %>%
      head(5) %>%
      select(from_name, message, created_time, type, likes_count)
  })
  # htmlOutput("types.of.posts.used"),
  output$types.of.posts.title = renderText({
    getTypesOfPostsTitle()
  })
  # plotOutput("plot")
  output$plot = renderPlot({
    # count data
    dataset.to.plot = datasetInput() %>%
      group_by(type) %>%
      tally() %>%
      arrange(n)
    # create plot
    plot = ggplot() +
      geom_bar(data = dataset.to.plot,
               aes(x = type,
                   y = n),
               stat = 'identity',
               fill = "#F45628") +
      plot.theme
    # print the plot, please (only of ggplot!)
    print(plot)
  })
  # htmlOutput("links.shared.title"),
  output$links.shared.title = renderText({
    getLinksSharedTitle()
  })
  # dataTableOutput("link.table")
  output$link.table = renderDataTable({
    datasetInput() %>%
      showLinks()
  })
})
