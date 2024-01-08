library(shiny)
library(shinydashboard)


calcule_mensualite <- function(montant_emprunte, taux_annuel, duree_mois) {
  
  #' Calcule le montant d'une mensualité en fonction du montant à emprunter, du taux d’intérêt et de la durée du prêt.
  #'
  #' @param montant_emprunte Montant à emprunter.
  #' @param taux_annuel Taux d'intérêt annuel en pourcentage.
  #' @param duree_mois Durée du prêt en mois.
  #'
  #' @return Le montant de la mensualité.
  #'
  #' @examples
  #' calcule_mensualite(10000, 5, 36)

  taux_mensuel <- taux_annuel / 12 / 100  # Calcul du taux d'intérêt mensuel en pourcentage
  
  # Calcul de la mensualité en utilisant la formule de calcul des mensualités d'un prêt
  mensualite <- (montant_emprunte * taux_mensuel) / (1 - (1 + taux_mensuel)^-duree_mois)
  
  mensualite
}

tableau_amortissement <- function(montant_emprunte, taux_annuel, duree_mois, assurance) {
  
  #' Génère un tableau d'amortissement pour un prêt en fonction du montant emprunté, du taux d'intérêt, de la durée du prêt et du montant de l'assurance.
  #'
  #' @param montant_emprunte Montant emprunté.
  #' @param taux_annuel Taux d'intérêt annuel en pourcentage.
  #' @param duree_mois Durée du prêt en mois.
  #' @param assurance Montant de l'assurance mensuelle.
  #'
  #' @return Un tableau décrivant l'amortissement du prêt mois par mois.
  #'
  #' @examples
  #' tableau_amortissement(10000, 5, 36, 20)
  
  mensualite <- calcule_mensualite(montant_emprunte, taux_annuel, duree_mois)  # Calcul de la mensualité
  
  capital_restant <- montant_emprunte
  amortissement <- data.frame(Numéro = numeric(),
                              Intérêts = numeric(),
                              Principal = numeric(),
                              Assurance = numeric(),
                              Mensualité = numeric(),
                              `Capital restant dû` = numeric(),
                              stringsAsFactors = FALSE)
  
  for (mois in 1:duree_mois) {
    interets <- capital_restant * taux_mensuel  # Calcul des intérêts pour ce mois
    principal <- mensualite - interets - assurance  # Calcul du montant du principal pour ce mois
    capital_restant <- capital_restant - principal  # Calcul du capital restant après paiement du principal
    
    ligne <- c(mois, interets, principal, assurance, mensualite, capital_restant)
    amortissement <- rbind(amortissement, ligne)
  }
  
  colnames(amortissement) <- c("Numéro", "Intérêts", "Principal", "Assurance", "Mensualité", "Capital restant dû")
  amortissement
}




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
      
      tabItem("amortissement", 
              fluidRow(
                column(6, numericInput("duree_annees", "Durée du crédit (années) :", value = 20)),
                column(6, numericInput("taux_interet", "Taux d'intérêt (%) :", value = 5)),
                column(6, numericInput("taux_assurance", "Taux d'assurance (%) :", value = 0)),
                column(6, numericInput("montant_projet", "Montant du projet :", value = 100000)),
                column(6, numericInput("apport_personnel", "Montant de l'apport personnel :", value = 0)),
                
                #ajouter si on va plus loin 
                
                
                #column(6, numericInput("revenu_emprunteur1", "Revenu de l'emprunteur 1 :", value = 3000)),
                #column(6, numericInput("revenu_emprunteur2", "Revenu de l'emprunteur 2 :", value = 0)),
                #column(6, numericInput("frais_dossier", "Frais de dossier et autres frais bancaires :", value = 1000)),
                
                actionButton("calculer", "Calculer")  # Bouton pour lancer les calculs
              ),
              box( 
                width = 12, 
                title = "Résultats",
                # Outputs pour les résultats
                verbatimTextOutput("mensualites"),
                verbatimTextOutput("taux_endettement"),
                verbatimTextOutput("cout_total"),
                verbatimTextOutput("cout_assurances"),
                verbatimTextOutput("cout_interets"),
                verbatimTextOutput("taeg")
              ),
              box(
                width = 12,
                title = "Tableau d'amortissement",
                dataTableOutput("amortissement")
              ),
              downloadButton("download_amortissement", "Télécharger le tableau d'amortissement")
      )
    )
  )##fin body
)##fin app

#Il faut faire l'ajout du tableau d'amortissement

server <- function(input, output) {
  observeEvent(input$calculer, {
    duree_mois <- input$duree_annees * 12
    montant_emprunte <- input$montant_projet - input$apport_personnel
    
    output$mensualites <- renderPrint({
      calcule_mensualite(montant_emprunte, input$taux_interet, duree_mois)
    })
    
    
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
