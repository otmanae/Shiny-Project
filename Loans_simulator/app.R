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
