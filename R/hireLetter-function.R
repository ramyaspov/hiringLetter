#' @title hireLetter
#' @description function outputs shiny app consisting filtered data to view and download as a csv file of individuals who pass or fail their age and experience qualifications as well as draft acceptance and rejection letters
#' @param data user inputs their data frame of applicant data

hireLetter <- function(data) {
  require(shiny)
  shinyApp(
    # Create UI
    ui <- fluidPage(
      sidebarLayout(
        sidebarPanel(
          sliderInput(inputId = "age",
                      label = "Minimum Age:",
                      min = 1, max = 100,
                      value = 20),
          sliderInput(inputId = "experience",
                      label = "Minimum Experience:",
                      min = 1, max = 100,
                      value = 2),
          selectInput(inputId = "role",
                      label = "Applying Position:",
                      choices = c("Civil Engineer", "Project Manager", "Professor", "Chef"),
                      selected = "Project Manager"),
          tabsetPanel(
            tabPanel("Accepted Letters", htmlOutput("AcceptL")),
            tabPanel("Rejected Letters", htmlOutput("RejectL"))
          )),

        mainPanel(
          div("Candidates that Passed"),
          downloadButton("download1", "Download candidates who passed in csv format"),
          tableOutput("Pass"),
          div("Candidates that Failed"),
          downloadButton("download2", "Download candidates who failed in csv format"),
          tableOutput("Fail"))

      )),
    server <- function(input, output) {

      # Create table of candidates who have passed and a download csv file
      passData = reactive({
        data %>% filter(age >= input$age & experience >= input$experience & role == input$role) %>% mutate(result = c("P"))
      })

      output$Pass <- renderTable({
        passData()
      })


      output$download1 <- downloadHandler(
        filename = function(){
          paste("passCandidates.csv", sep = "")
        },
        content = function(file){
          write.csv(passData(), file)
        }
      )
      # Create table of candidates who failed and.a download csv file
      failData = reactive({
        data %>% filter((age < input$age | experience < input$experience) &  role == input$role) %>% mutate(result = c("F"))
      })

      output$Fail <- renderTable({
        failData()
      })

      output$download2 <- downloadHandler(
        filename = function(){
          paste("failCandidates.csv", sep = "")
        },
        content = function(file){
          write.csv(failData(), file)
        }
      )

      # Create letter templates
      output$AcceptL <- renderUI({
        if(length(passData() > 0)){
          HTML(paste("Dear",passData()$name, ",<br/>",
                     "We are pleased to offer you a position as a", passData()$role, "!<br/><br/>"))

        }
      })


      output$RejectL <- renderUI({
        if(length(failData() > 0)){
          HTML(paste("Dear", failData()$name, ",<br/>",
                     "We regret to inform you that we have procceded with a different applicant for the position", failData()$role, ".<br/></br>"))
        }
      })

    }
  )

}
