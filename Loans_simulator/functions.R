calcul_mensualite <- function(montant_emprunte, taux_annuel, duree_mois) {
  
  #' Calcule le montant d'une mensualité en fonction du montant à emprunter, du taux d’intérêt et de la durée du prêt.
  #'
  #' @param montant_emprunte Montant à emprunter.
  #' @param taux_annuel Taux d'intérêt annuel en pourcentage.
  #' @param duree_mois Durée du prêt en mois.
  #'
  #' @return Le montant de la mensualité.
  #'
  #' @examples
  #' calcul_mensualite(10000, 5, 36)
  
  taux_mensuel <- taux_annuel / 12 / 100  # Calcul du taux d'intérêt mensuel en pourcentage
  
  # Calcul de la mensualité en utilisant la formule de calcul des mensualités d'un prêt
  mensualite <- (montant_emprunte * taux_mensuel) / (1 - (1 + taux_mensuel)^-duree_mois)
  
  mensualite
}

tableau_amortissement <- function(montant_emprunte, taux_annuel, duree_mois, taux_assurance) {
  
  #' Génère un tableau d'amortissement pour un prêt en fonction du montant emprunté, du taux d'intérêt, de la durée du prêt et du montant de l'assurance.
  #'
  #' @param montant_emprunte Montant emprunté.
  #' @param taux_annuel Taux d'intérêt annuel en pourcentage.
  #' @param duree_mois Durée du prêt en mois.
  #' @param assurance taux de l'assurance mensuelle.
  #'
  #' @return Un tableau décrivant l'amortissement du prêt mois par mois.
  #'
  #' @examples
  #' tableau_amortissement(10000, 5, 36, 20)
  
  mensualite <- calcul_mensualite(montant_emprunte, taux_annuel, duree_mois)  # Calcul de la mensualité
  mensualite <- round(mensualite,2)
  capital_restant <- montant_emprunte
  amortissement <- data.frame(Numéro = numeric(),
                              Intérêts = numeric(),
                              Principal = numeric(),
                              Assurance = numeric(),
                              Mensualité = numeric(),
                              `Capital restant dû` = numeric(),
                              stringsAsFactors = FALSE)
  
  # Calcul du montant de l'assurance 
  
  assurance <- taux_assurance * duree_mois/12 * montant_emprunte
  taux_mensuel <- taux_annuel /12 /100
  
  
  # Ajouter du code pour la dernière mensualité 
  
  for (mois in 1:duree_mois) {
    interets <- capital_restant * taux_mensuel  # Calcul des intérêts pour ce mois
    principal <- mensualite - interets - assurance  # Calcul du montant du principal pour ce mois
    
    # Gérer le dernier mois
    if (mois == duree_mois) {
      mensualite <- capital_restant + interets + assurance
      principal <- capital_restant
      # la mensualité est exactement égale au capital restant dû
      mensualite <- principal + interets + assurance
    }
    
    capital_restant <- capital_restant - principal  # Calcul du capital restant après paiement du principal
    
    ligne <- c(mois, interets, principal, assurance, mensualite, capital_restant)
    amortissement <- rbind(amortissement, ligne)
  }
  
  colnames(amortissement) <- c("Numéro", "Intérêts", "Principal", "Assurance", "Mensualité", "Capital restant dû")
  amortissement
}
debug<-function(obj,message){
  cat(message)
  print(obj)
}
calcul_capacite_emprunt <- function(duree_mois, revenu_net, taux_endettement_max, montant_perso, taux_assu){
  # Pour cacluer le taux veut prendre le taux moyen suivant : 
  # https://www.meilleurtaux.com/credit-immobilier/barometre-des-taux.html
  # pour ce faire on va faire une regression linéraire sur les "bons taux" de 7, 10, 15, 20 et 25 ans 
  # respectivement ayant un taux de 3.2%, 3.4%, 3.85%, 4.05% et 4.2%
  df_taux_barometre <- data.frame(mois = 12*c(7,10,15,20,25), taux = c(0.032,0.034,0.0385,0.0405,0.042)/12)
  RL_taux_barometre <- lm(data = df_taux_barometre, formula = taux~mois)
  taux_mensuel <- predict(RL_taux_barometre,data.frame(mois = duree_mois))
  mensualite<- revenu_net*taux_endettement_max
  # Calcul de la montant_emprunte en utilisant la formule de calcul des montant_emprunte d'un prêt
  montant_emprunte <- mensualite * (1 - (1 + taux_mensuel)^-duree_mois) / taux_mensuel + montant_perso
  montant_emprunte
}
