Prérequis : 
BaseX v8 obligatoire (release en février 2015)
XSLT v2 (cf saxonHE9) 

Arborescence de la webapp SynopsX :

webapp
    /static
    /synopsx
        /_restxq        # tous les modules correspondants aux différents points d'entrée dont webapp.xqm est le principal. Par ex. tester avec le path suivant http://localhost:8984/corpus 
        /models         # tous les modules correspondants à l'accès au données (calculs, accès, traitement ...)
        /search         # un module lié à des fonctions de recherche (NB : déterminer un lieu commun ou pas à d'autres cas similaires ?)
        /templates      # tous les modèles de sorties (ex : html, xml : ead, tei ...). NB : A définir pour chaque projet.
        /mapping        # tous les modules controleurs, chargé de faire le lien entre les données d'entrées (models) et les données sorties (templates)
 globals.xqm            fichier qui définit des variables globales de l'application
