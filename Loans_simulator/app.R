#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Crédit immobilier"),  ##titre de l app 
  dashboardSidebar(  ###panel de gauche ou on entre les inputs et ou il y a le menu 
    
    ##mettre ici les inputs 
    sidebarMenu(
      #premier onglet avec les résumés (cout du crédit, montant des mensualités,...)
      menuItem("Résumé", tabName = "resume"), 
      ##tableau d'amortissement 
      menuItem("Tableau d'amortissement", tabName = "amortissement")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("resume",
              fluidRow(
                valueBoxOutput("taux_interet"),
                valueBoxOutput("taeg"),
                valueBoxOutput("cout_total"),
                valueBoxOutput("mensualite"),
                valueBoxOutput("cout_credit"),
                valueBoxOutput("cout_interets"),
                valueBoxOutput("cout_assurances"),
                valueBoxOutput("taux_endettement")
                
              )
              
      )###fin du premier onglet 
      ,
      
      tabItem("amortissement", 
              box( 
                width = 12, 
                title = "Tableau d'amortissement"
                ,dataTableOutput("amortissement")  ##tableau d'amortisseemnet
              )
              
              
      ) ##fin amortissement
    ) ##fin tabitems
  )##fin body
)##fin app

server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
