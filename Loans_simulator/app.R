library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinyjs)

source("function1.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Crédit immobilier"),  ##titre de l app 
  dashboardSidebar(  ###panel de gauche ou on entre les inputs et ou il y a le menu 
    
    ##mettre ici les inputs 
    sidebarMenu(
      ##tableau d'amortissement 
      menuItem("Tableau d'amortissement",icon = icon("home"), tabName = "amortissement"),
      menuItem("Résumé", tabName = "resume", icon = icon("info-circle", color = "green")),
      menuItem("Capacité d'emprunt",icon = icon("search"), tabName = "capacite_emprunt_item")
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
                column(6, numericInput("frais_dossier", "Frais de dossier et autres frais bancaires :", value = 0)),
                
                actionButton("calculer",icon = icon("calculator"), "Calculer")  # Bouton pour lancer les calculs
              ),
              box(
                width = 12,
                title = "Tableau d'amortissement",
                dataTableOutput("amortissement")
              ),
              downloadButton("download_amortissement", "Télécharger le tableau d'amortissement"),
              
      ), 
      tabItem("capacite_emprunt_item", 
              fluidRow(
                column(6, numericInput("duree_annees_emprunt", "Durée du crédit (années) :", value = 20)),
                column(6, numericInput("taux_endettement_max_emprunt", "Taux d'endettement max (%) :", value = 30)),
                column(6, numericInput("revenu_emprunteur1_emprunt", "Revenu de l'emprunteur 1 :", value = 3000)),
                column(6, numericInput("revenu_emprunteur2_emprunt", "Revenu de l'emprunteur 2 :", value = 0)),
                column(6, numericInput("apport_personnel_emprunt", "Montant de l'apport personnel :", value = 0)),
                column(6, numericInput("frais_dossier_emprunt", "Frais de dossier et autres frais bancaires :", value = 1000)),
                
                
                box(
                  title = "Capacité d'emprunt",
                  status = "primary",  
                  solidHeader = TRUE,  
                  collapsible = TRUE,  
                  width = 12,  
                  verbatimTextOutput("capacite_emprunt")  # Affichage du texte ici
                )
              )
              
      ),
      tabItem("resume",
              fluidRow(
                column(12, h3("Résumé du Crédit Immobilier", style = "color: #333")),
                box(
                  width = 4,
                  title = "Coût Total du Crédit",
                  valueBoxOutput("cout_credit"),
                  background = "green",  # Couleur de fond pour le coût total du crédit
                  color = "black"  # Couleur du texte
                ),
                box(
                  width = 4,
                  title = "Coût Total de l'Assurance",
                  valueBoxOutput("cout_assurance"),
                  background = "yellow",  # Couleur de fond pour le coût total de l'assurance
                  color = "black"  # Couleur du texte
                ),
                box(
                  width = 4,
                  title = "Coût Total des Intérêts",
                  valueBoxOutput("cout_interets"),
                  background = "blue",  # Couleur de fond pour le coût total des intérêts
                  color = "black"  # Couleur du texte
                ),
                box(
                  width = 4,
                  title = "Mensualité fixe dûe",
                  valueBoxOutput("Mensualite_fixe"),
                  background = "orange",  # Couleur de fond pour le coût total des intérêts
                  color = "black"  # Couleur du texte
                ),
                box(
                  width = 12,
                  title = "Graphique des coûts totaux du crédit",
                  plotlyOutput("couts_totals")
                )
              )
    )
  )##fin body
)##fin app
)

server <- function(input, output, session) {
  amort <- reactiveVal(NULL)
  
  observeEvent(input$calculer, {
    duree_mois <- input$duree_annees * 12
    montant_emprunte <- input$montant_projet - input$apport_personnel
    
    amort_val <- tableau_amortissement(montant_emprunte, input$apport_personnel_emprunt, input$taux_interet, duree_mois,
                                       input$taux_assurance, input$frais_dossier_emprunt)
    amort(amort_val)
    last_month <- nrow(amort_val$Mensualité)
    
    
  })
  
  output$amortissement <- renderDataTable({
    req(amort())
  })
  
  output$couts_totals <- renderPlotly({
    req(amort())
    
    frais_dossier_total <- input$frais_dossier_emprunt
    cout_total_initial <- frais_dossier_total + input$apport_personnel_emprunt
    
    montant_emprunte_initial <- input$montant_projet - input$apport_personnel_emprunt
    
    Couts_Interets <- cumsum(amort()$Intérêts)
    Couts_Assurances <- cumsum(amort()$Assurance)
    Couts_Total <- cumsum(amort()$Mensualité) + cout_total_initial

    output$cout_credit <- renderText({ paste(formatC(Couts_Total[length(Couts_Total)], digits = 2, format = "f"), "€") })
    output$cout_interets <- renderText({ paste(formatC(Couts_Interets[length(Couts_Interets)], digits = 2, format = "f"), "€") })
    output$cout_assurance <- renderText({ paste(formatC(Couts_Assurances[length(Couts_Assurances)], digits = 2, format = "f"), "€") })
    output$Mensualite_fixe <- renderText({ paste(formatC(mensualite_moyenne_globale, digits = 2, format = "f"), "€") })
    
    output$cout_assurance <- renderText({ paste(formatC(Couts_Assurances[length(Couts_Assurances)], digits = 2, format = "f"), "€") })
    plot_ly(x = 1:length(Couts_Interets)) %>%
      add_lines(y = Couts_Interets, name = "Intérêts", line = list(dash = 'dash')) %>%
      add_lines(y = Couts_Assurances, name = "Assurances", line = list(dash = 'dash')) %>%
      add_lines(y = Couts_Total, name = "Total") %>%
      layout(title = "Évolution des coûts totaux du crédit",
             xaxis = list(title = "Mois"),
             yaxis = list(title = "Montant (en euros)"))
  })
  
  
  output$capacite_emprunt <- renderText({
    calcul_capacite_emprunt(12 * input$duree_annees_emprunt,
                            input$revenu_emprunteur1_emprunt + input$revenu_emprunteur2_emprunt,
                            input$taux_endettement_max_emprunt / 100, input$apport_personnel_emprunt,
                            input$taux_assurance_emprunt)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)