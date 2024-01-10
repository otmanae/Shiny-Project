library(shiny)
library(shinydashboard)

library(dplyr)
source("function1.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Crédit immobilier"),  ##titre de l app 
  dashboardSidebar(  ###panel de gauche ou on entre les inputs et ou il y a le menu 
    
    ##mettre ici les inputs 
    sidebarMenu(
      #premier onglet avec les résumés (cout du crédit, montant des mensualités,...)
      menuItem("Résumé", tabName = "resume"), 
      ##tableau d'amortissement 
      menuItem("Tableau d'amortissement", tabName = "amortissement"),
      menuItem("Capacité d'emprunt", tabName = "capacite_emprunt_item")
    )
  ),
  dashboardBody(
    tabItems(
      
      tabItem("amortissement", 
              fluidRow(
                column(6, numericInput("duree_annees", "Durée du crédit (années) :", value = 20)),
                column(6, numericInput("taux_interet", "Taux d'intérêt (%) :", value = 5)),
                column(6, numericInput("taux_assurance", "Taux d'assurance (%) :", value = 0.2)),
                column(6, numericInput("montant_projet", "Montant du projet :", value = 100000)),
                column(6, numericInput("apport_personnel", "Montant de l'apport personnel :", value = 0)),
                column(6, numericInput("revenu_emprunteur1", "Revenu de l'emprunteur 1 :", value = 3000)),
                column(6, numericInput("revenu_emprunteur2", "Revenu de l'emprunteur 2 :", value = 0)),
                column(6, numericInput("frais_dossier", "Frais de dossier et autres frais bancaires :", value = 1000)),
                
                actionButton("calculer", "Calculer")  # Bouton pour lancer les calculs
              ),
              box(
                width = 12,
                title = "Tableau d'amortissement",
                dataTableOutput("amortissement")
              ),
              downloadButton("download_amortissement", "Télécharger le tableau d'amortissement")
      ), 
      tabItem("capacite_emprunt_item", 
              fluidRow(
                column(6, numericInput("duree_annees_emprunt", "Durée du crédit (années) :", value = 20)),
                column(6, numericInput("taux_endettement_max_emprunt", "Taux d'endettement max (%) :", value = 30)),
                column(6, numericInput("revenu_emprunteur1_emprunt", "Revenu de l'emprunteur 1 :", value = 3000)),
                column(6, numericInput("revenu_emprunteur2_emprunt", "Revenu de l'emprunteur 2 :", value = 0)),
                column(6, numericInput("apport_personnel_emprunt", "Montant de l'apport personnel :", value = 0)),
                column(6, numericInput("taux_assurance_emprunt", "Taux d'assurance (%) :", value = 0)),
                column(6, numericInput("frais_dossier_emprunt", "Frais de dossier et autres frais bancaires :", value = 1000)),
                
                actionButton("calculer_emprunt", "Calculer"),  # Bouton pour lancer les calculs
                verbatimTextOutput("capacite_emprunt")
              )
      )
    )
  )##fin body
)##fin app



server <- function(input, output) {
  observeEvent(input$calculer, {
    duree_mois <- input$duree_annees * 12
    montant_emprunte <- input$montant_projet - input$apport_personnel
    
    output$amortissement <- renderDataTable({
      tableau_amortissement(montant_emprunte, input$apport_personnel_emprunt, input$taux_interet, duree_mois,
                            input$taux_assurance,input$frais_dossier_emprunt)
    })
    
    
  })
  observeEvent(input$calculer_emprunt, {
    output$capacite_emprunt <- renderPrint({
      calcul_capacite_emprunt(12*input$duree_annees_emprunt,
                              input$revenu_emprunteur1_emprunt+input$revenu_emprunteur2_emprunt,
                              input$taux_endettement_max_emprunt/100, input$apport_personnel_emprunt,
                              input$taux_assurance_emprunt)
    })
  })
}


# Run the application 
shinyApp(ui = ui, server = server)