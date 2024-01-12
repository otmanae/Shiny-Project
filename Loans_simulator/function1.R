debug<-function(obj,message){
  cat(message)
  print(obj)
}

#' Calcule le montant d'une mensualité en fonction du montant à emprunter, 
#' du taux d’intérêt et de la durée du prêt.
#'
#' @param montant_emprunte Montant à emprunter.
#' @param taux_annuel Taux d'intérêt annuel en pourcentage.
#' @param duree_mois Durée du prêt en mois.
#'
#' @return Le montant de la mensualité.
#'
#' @examples
#' calcul_mensualite(10000, 5, 36)

calcul_mensualite <- function(montant_emprunte, taux_annuel, duree_mois) {
  
  taux_mensuel <- taux_annuel / 12 / 100  # Calcul du taux d'intérêt mensuel en pourcentage
  
  # Calcul de la mensualité en utilisant la formule de calcul des mensualités d'un prêt
  mensualite <- (montant_emprunte * taux_mensuel) / (1 - (1 + taux_mensuel)^-duree_mois)
  
  mensualite
}


#' Génère un tableau d'amortissement pour un prêt en fonction du montant emprunté,
#'du taux d'intérêt, de la durée du prêt et du montant de l'assurance.
#'
#' @param montant_emprunte Montant emprunté.
#' @param taux_annuel Taux d'intérêt annuel en pourcentage.
#' @param duree_mois Durée du prêt en mois.
#' @param taux_assurance sur le prêt fixe
#'
#' @return Un tableau décrivant l'amortissement du prêt mois par mois.
#'
#' @examples
#' tableau_amortissement(10000, 5, 36, 20)
#'
#' A faire à la fin, on recalculera les mensualités de façon à ce 
#' qu’elles ne varient pas au cours du temps.

tableau_amortissement <- function(montant_emprunte, 
                                  apport_personnel_emprunt,taux_annuel,
                                  duree_mois, taux_assurance,frais_dossier_emprunt) {
  
  capital_restant <- montant_emprunte-apport_personnel_emprunt+frais_dossier_emprunt
  taux_mensuel<- taux_annuel/12/100
  total_paye<-0
  amortissement <- data.frame(Numéro = numeric(),
                              Intérêts = numeric(),
                              Principal = numeric(),
                              Assurance = numeric(),
                              Mensualité = numeric(),
                              `Capital restant dû` = numeric(),
                              stringsAsFactors = FALSE)
  
  for (mois in 1:duree_mois) {
    if(mois==duree_mois){
      assurance_mensuelle <- capital_restant * taux_assurance/100
      interets <- capital_restant * taux_mensuel
      
      mensualite<-capital_restant+interets+assurance_mensuelle
      principal <- mensualite - interets - assurance_mensuelle  # Calcul du montant du principal pour ce mois
      
      capital_restant <- capital_restant - principal  # Calcul du capital restant après paiement du principal
      total_paye<-total_paye+mensualite
      ligne <- c(mois, round(interets,2), round(principal,2), round(assurance_mensuelle,2), round(mensualite,2), round(capital_restant,2))
      amortissement <- rbind(amortissement, ligne)
      }
      else{
        # Calcul itératif 
        assurance_mensuelle <- capital_restant * taux_assurance/100
        interets <- capital_restant * taux_mensuel
        
        mensualite<-calcul_mensualite(capital_restant,taux_annuel,duree_mois-mois)
        principal <- mensualite - interets - assurance_mensuelle  # Calcul du montant du principal pour ce mois
        total_paye<-total_paye+mensualite
        capital_restant <- capital_restant - principal  # Calcul du capital restant après paiement du principal
        ligne <- c(mois, round(interets,2), round(principal,2), round(assurance_mensuelle,2), round(mensualite,2), round(capital_restant,2))
        amortissement <- rbind(amortissement, ligne)}
  }
  mensualite_moyenne_globale<<-total_paye/duree_mois
  colnames(amortissement) <- c("Numéro", "Intérêts", "Principal", "Assurance", "Mensualité", "Capital restant dû")
  amortissement
}

#' Calcule la capacité d'emprunt en fonction de la durée du prêt, du revenu net,
#'  du taux d'endettement maximum, du montant personnel et du taux d'assurance.
#'
#' @param duree_mois Durée du prêt en mois.
#' @param revenu_net Revenu net mensuel.
#' @param taux_endettement_max Taux d'endettement maximum (en pourcentage du revenu net).
#' @param montant_perso Montant personnel pouvant être ajouté au prêt.
#' @param taux_assurrance Taux d'assurance mensuel.
#'
#' @return Le montant pouvant être emprunté en fonction des paramètres fournis.
#'
#' @examples
#' calcul_capacite_emprunt(36, 5000, 0.3, 10000, 0.02)
#' # Renvoie le montant pouvant être emprunté pour un prêt de 36 mois avec un 
#' revenu net de 5000, un taux d'endettement maximum de 30%, un montant personnel 
#' de 10000, et un taux d'assurance de 2%.

calcul_capacite_emprunt <- function(duree_mois, revenu_net, taux_endettement_max, apport_personnel_emprunt, taux_assurrance){
  
  df_taux_barometre <- data.frame(mois = 12*c(7,10,15,20,25), taux = c(0.032,0.034,0.0385,0.0405,0.042)/12)
  RL_taux_barometre <- lm(data = df_taux_barometre, formula = taux~mois)
  taux_mensuel <- predict(RL_taux_barometre,data.frame(mois = duree_mois))
  mensualite<- revenu_net*taux_endettement_max
  # Calcul de la montant_emprunte en utilisant la formule de calcul des montant_emprunte d'un prêt
  montant_emprunte <- mensualite * (1 - (1 + taux_mensuel)^-duree_mois) / taux_mensuel + apport_personnel_emprunt
  montant_emprunte
}


