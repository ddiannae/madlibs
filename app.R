library(shiny)
library(useself)
library(logger)


log_threshold(DEBUG)
log_info("Script starting up...")
generate_story <- function(noun, verb, adjective, adverb) {
  glue::glue(
    "
    Once upon a time, there was a {adjective} {noun} who loved to
    {verb} {adverb}. It was the funniest thing ever!
  "
  )
}

ui <- fluidPage(
  titlePanel("Mad Libs Game"),
  sidebarLayout(
    sidebarPanel(
      textInput("noun1", "Enter a noun:", ""),
      textInput("verb", "Enter a verb:", ""),
      textInput("adjective", "Enter an adjective:", ""),
      textInput("adverb", "Enter an adverb:", ""),
      actionButton("submit", "Create Story")
    ),
    mainPanel(
      h3("Your Mad Libs Story:"),
      textOutput("story")
    )
  )
)

server <- function(input, output) {
  log_info("Waiting for user input...")
  story <- eventReactive(input$submit, {
    log_info("We got user input, generating story...")

    if(input$noun1=="") {
      log_warn("Noun input is empty, using default value.")
      input$noun1 <- "cat"
    }
    generate_story(input$noun1, input$verb, input$adjective, input$adverb)
  })
  log_info("Setting up output rendering...")
  output$story <- renderText({
    story()
  })
}

shinyApp(ui = ui, server = server)
