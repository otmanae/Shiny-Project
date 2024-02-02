# Commentaires Projet


**Onglet Tableau d'amortissement :**

Test avec les valeurs suivante :

Durée du crédit (année) = 25
Taux d'assurance : 0.2 %
Montant de l'apport personnel : 50000
Taux d'intérêt : 5 %
Montant du projet : 350000
Revenu de l'emprunteur 1 : 3500
Revenu de l'emprunteur 2 : 2500
Frais de dossier et autres frais bancaires : 0

Résultat : 
- Le Capital restant dû est logique car dans les premières années on paye seulement les intérêts, d'où le fait qu'il ne décroit pas au départ.
- 600 euros d'assurance par mois semble excessif... Ok ils sont deux emprunteurs mais ils empruntent 350000 à deux, ce qui veut dire qu'ils ont un taux de 0.2% chacun sur la moitié de la somme.  Le calcul à la main donne 50 euros d'assurance sur le premier mois.


Test avec les valeurs du site www.cbanque.com/credit/tableau-amortissement.php :

Durée du crédit (année) = 1
Taux d'assurance : 0.35 %
Montant de l'apport personnel : 0
Taux d'intérêt : 5 %
Montant du projet : 10000
Revenu de l'emprunteur 1 : 2500
Revenu de l'emprunteur 2 : 0
Frais de dossier et autres frais bancaires : 0

Résultat : 
- Calcul de l'intérêt mauvais car d'après la présentation, intérêts = (restant dû avant paiement)*intérêt/12. Bon résultat pour la première ligne: 41.67. 
- Comme précédemment, le calcul de l’assurance ne correspond pas


Téléchargement du tableau format html, ne renvoie pas le tableau mais l'onglet entier sans la possibilité de télécharger le tableau ! Il serait préférable de le télécharger en .CSV

Les mensualités augmentent tous les mois : pourquoi ? Le prêt est à taux fixe et les échéances sont tous les mois, on devrait donc avoir des mensualités constantes. De plus, le taux d'assurance est aussi fixe (pas de révision de l'assurance). Erreur de calcul ?

Remarque : Présentation 1 ou 2 (www.cbanque.com/credit/tableau-amortissement.php) ne correspond pas vraiment au tableau d'amortissement du projet . Si la colonne « capital restant dû » est à droite, c'est le capital restant dû APRES paiement, alors que si la colonne est à gauche, c'est le capital restant dû AVANT paiement.


**Onglet Résumé :**
Définition Coût total du Crédit : la différence entre la somme non actualisée des versements pour le remboursement d'un emprunt et le montant de cet emprunt. Ici, pour le coût total du crédit vous avez fait la somme des deux ! L'output "Coût total des Intérêts" correspond donc au coût total du crédit.

Output Coût total de l'assurance : Emprunter 350000 euros, reviendrait à payer 136408 euros d'assurance !? En général pour un taux à 0.2% d'assurance pour un emprunt de 350000 euros sur 25 ans reviendrait à environ 20000 euros d'assurance (calcul à revoir)

** Onglet Capacité d’emprunt : ** 
Dommage que les données d'entrées de l'onglet tableau d'amortissement ne sont pas directement retranscrites dans l'onglet Capacité d'emprunt. On doit remettre toutes les entrées... Peut-être faire en sorte de prendre automatiquement les données que l'utilisateur a entré dans le premier onglet. 

Ergonomie : Il serait préférable de mettre dans le premier onglet, les box du résumé, ce serait plus intuitif et parlant pour l'utilisateur.  Et mettre un onglet tableau d'amortissement dans un autre onglet pour les personnes souhaitant des détails.
De plus, si on veut changer quelques valeurs dans les entrées et voir l'impact globale que les changements apportent (voir les box et graphiques), on est obligé de changer d'onglet, c'est pénible. Peut-être voir pour mettre les données d'entrées dans la sideBar.


** Code ** 
- Calcul de l'assurance mensuelle faux, valeur insensée.
- Le recalcul de la mensualité chaque mois entraîne sûrement des variations, ce qui n'est pas logique pour un prêt à taux fixe.
- Bon calcul du principal mais résultat numérique faux à cause de l'assurance.
- Taux mensuel incorrect 
- commentaire que vous avez fait : "
#' A faire à la fin, on recalculera les mensualités de façon à ce 
#' qu’elles ne varient pas au cours du temps.
" Mais cela n'a pas été fait pour le tableau d’amortissement ?
- Code clair, bon commentaires et explications.
