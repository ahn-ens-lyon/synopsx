module namespace desanti = 'http://ahn.ens-lyon.fr/desanti';

import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx' at 'synopsx.xqm';
import module namespace ahn_commons = 'http://ahn.ens-lyon.fr/ahn_commons' at 'ahn_commons.xqm';



declare namespace db = 'http://basex.org/modules/db';
(:declare namespace ft = 'http://basex.org/modules/ft';:)
declare namespace json = 'http://basex.org/modules/json';
declare namespace mml="http://www.w3.org/1998/Math/MathML";
declare namespace tei = 'http://www.tei-c.org/ns/1.0/';
declare namespace xslt="http://basex.org/modules/xslt";

declare default collation 'http://basex.org/collation?lang=fr;strength=secondary';

declare variable $desanti:xslt := "/static/xsl/desanti.xsl";




declare function desanti:head($params){
  <head>
        <title>{map:get($params,"project")}</title>
        
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Kit Corpus de l'AHN. Utilise BaseX et RESTXQ" />
        <meta name="author" content="Atelier des Humanités Numériques, ENS de Lyon, France" />
        
        <!-- Bootstrap core CSS -->
        <link href="http://archive.desanti.huma-num.fr/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <link href="http://archive.desanti.huma-num.fr/static/js/tablesorter/themes/blue/style.css" rel="stylesheet" />
        
 
        
         <link rel="stylesheet" type="text/css" href="http://archive.desanti.huma-num.fr/static/js/jqzoom_ev-2.3/css/jquery.jqzoom.css"/>
                

        <!-- CSS spécifiques au corpus -->
        <link href="http://archive.desanti.huma-num.fr/static/css/ahn.css" rel="stylesheet" />
        <link href="http://archive.desanti.huma-num.fr/static/css/desanti.css" rel="stylesheet" media="screen"/>
        
        
     <style type='text/css'>{string('
    
    ')}
  </style>
   
  </head>
};


declare function desanti:scripts_js($params){
  <div id="scripts_js">
     <script  type="text/javascript" src="http://code.jquery.com/jquery-2.1.0.min.js"></script>
     <script src="http://code.jquery.com/jquery-migrate-1.2.1.js"></script>
  <script type='text/javascript' src="http://archive.desanti.huma-num.fr/static/js/jqzoom_ev-2.3/js/jquery.jqzoom-core.js"></script>
  
    <script  type="text/javascript" src="http://archive.desanti.huma-num.fr/static/bootstrap/js/bootstrap.min.js"></script>
    <script  type="text/javascript" src="http://archive.desanti.huma-num.fr/static/js/tablesorter/jquery.tablesorter.min.js"></script>
    
         
    { if(contains(map:get($params,"user-agent"), "Firefox")) 
                then () 
                else <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
     }
        <script type="text/javascript">{string("$(document).ready(function() { 
                    $('.zoom').jqzoom({position: 'left', zoomType: 'innerzoom'}); 
                    $('#catalogue').tablesorter();
                     
        });")}</script>
  
  

   
    </div>
  };



(: Bloc Header :)
declare function desanti:header($params){
<div id="header">
   
              <div id="site-title">
                  <a href="/desanti"><img class="logo" src="http://desanti.tge-adonis.fr/archivenumerique/archive/theme_uploads/d7ec7c6a7d12d6fd2a4fc79d5f41be43.jpg" alt="Accueil" /></a>
                  <div id="logo-partenaire-principal"> 
                    <a href="http://www.ens-lyon.eu" title="Vers le site de l'ENS de Lyon" target="_blank">
                    <img src="http://ara-domu-omeka.ens-lyon.fr/ahn/sites/all/themes/kitahn/img/logo_Partenaire.png" alt="ENS Lyon"/>
                    </a>
                  </div>
             </div>

   {synopsx:function-lookup("header-image",map:get($params,"project"),"xhtml")($params)} 
  </div>

};

declare function desanti:header-image($params){
	<div id="header-image">
            <img src="http://desanti.tge-adonis.fr/archivenumerique/archive/theme_uploads/8f84176a946f1ffe5f53ef85a311408f.png"/>
     </div> 
};

(: Bloc Primary-nav :)
declare function desanti:primary-nav($params){
   <nav class="container navbar" id="primary-nav">
    <ul class="navigation">
      <li class="nav-entree"><a href="/desanti/catalogue">Catalogue des notices</a></li>
     
      <li class="nav-entree"><a href="/desanti/dossiers">{db:open("desanti")//*:teiCorpus[@xml:id = "DST-dossiers"]/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text()}</a></li>
      <!--<li class="nav-entree"><a href="/desanti/dictionnaire">{db:open("desanti")//*[@xml:id = "DST-dictionnaire"]/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text()}</a></li>-->
        <li class="nav-entree"><a href="/desanti/transcriptions">{db:open("desanti")//*:teiCorpus[@xml:id = 'DST-transcriptions']/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text()}</a></li>

      <li class="nav-entree"><a target="_blank" title="Biographie et bibliographies de Jean-Toussaint Desanti sur le site de l'Institut Desanti - ENS de Lyon" href="http://institutdesanti.ens-lyon.fr/spip.php?rubrique25">Autres ressources</a>
       
        </li>
      </ul>
  </nav>
};



declare function desanti:primary($params) {
let $dataType := map:get($params,"dataType")
let $value := map:get($params,"value")
return
  <div id="primary" class="{$dataType}">
         {let $primary-block :=
         
         switch($dataType)
            case "home" return 
                <section>
                 
                 <p><img title="Archive Desanti. Photo © David Wittmann" src="http://desanti.tge-adonis.fr/archivenumerique/archive/theme_uploads/DST-pochette-accueil.png" /></p>
               </section>
    

           (: Bloc catalogue des notices : 
                       si seul le param $dataType=catalogue est passé, renvoie à l'accueil général des notices EAD
                       si les deux params $dataType=catalogue et $value=notice-id sont passé, renvoie la page de la notice EAD correspondante
           :)
           
           
               case "catalogue" return <section>
               {let $block := 
    
                        (: Cas 1 : Pas d'id de notice particulière -> Accueil de toutes les notices :)
                       if(empty($value)) then 
                       (<h1>{count(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c)} notices descriptives</h1>,
                       desanti:display-notices(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c))
                        (: Cas 2 : Affichage de la notice id=$value :)
                       else 
                        for $item in db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c[contains(@id, concat($value, '-EAD'))]
                        
                           return
                            <div>
                           <h3>Pièce n° {$value} - {$item/*:did/*:unittitle//text()}</h3>
                           
                               
                               {xslt:transform($item/*:scopecontent, concat($ahn_commons:url_base, $desanti:xslt))}
                              
                         </div>
                         
                         
                       return $block  
                       }</section>
                   





(: Bloc transcriptions : 
            si seul le param $dataType=transcriptions est passé, renvoie l'accueil général des transcriptions
            si les deux params $dataType=transcriptions et $value=text-id sont passés, renvoie la page de la transcription correspondant à text-id 
:)


            case "transcriptions" return <section>{
                
                let $block := 

                    
                    (: Cas 1 : Pas d'id de transcription particulière -> Accueil de toutes les transcriptions :)
                    if(empty($value)) then
                    <section>
                    <h1>{db:open("desanti")//*[@xml:id = "DST-transcriptions"]/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text()}</h1>
                    <ul>
                    {
                    for $item in db:open("desanti")/*:TEI[contains(@xml:id, "-TEI")][*:teiHeader/*:fileDesc/*:publicationStmt/*:availability[@status='free']]
                    order by $item/@xml:id
                    let $text-id := substring-before(substring-after($item/@xml:id, '-'), '-')
                    let $title := 
                           if (empty($item//*:titleStmt/*:title[@type='main']))
                            then $item//*:titleStmt/*:title/node()
                            else $item//*:titleStmt/*:title[@type='main']/node()
                             
                    return <li>{string($text-id)} - <a href="/desanti/transcriptions/{$text-id}">{$title}</a></li>
                    }
                    </ul>
                   </section>
                    
                    
                    
                    
                    (: Cas 2 : Affichage transcription id=$text :)
                    else 
                    <section>
                     <h6>Ms {$value}</h6>
                     
                    {
                    for $item in db:open("desanti")/*:TEI[contains(@xml:id, concat($value, "-TEI"))]
                                    
                           
                    return <article>
                                {xslt:transform($item, concat($ahn_commons:url_base, $desanti:xslt))}
                            </article>
                    }</section>
                    
                    return $block

                    }</section>
                


(: Bloc dossiers thématiques : 
            si seul le param $dataType=dossiers est passé, renvoie l'accueil général des transcriptions
            si les deux params $dataType=dossiers et $value=dossier-id sont passé, renvoie la page du dossier correspondant
:)


                case "dossiers" return if(empty($value)) 
                                then <section>
                                            <p>
                                            <img title="Archive Desanti. Photo © David Wittmann" src="http://desanti.tge-adonis.fr/archivenumerique/archive/theme_uploads/DST-pochette-accueil.png" />
                                            </p>
                                       </section>
                                else <section>{let $item := db:open("desanti")//*[@xml:id=$value]
                                        return 
                                        (<h1>{$item//*:titleStmt/*:title/text()}</h1>,
                                        <div>{xslt:transform($item//*:text, concat($ahn_commons:url_base, $desanti:xslt))}</div>)
                                        }</section>



(: Bloc Dictionnaire : 
            si seul le param $dataType=dictionnaire est passé, renvoie l'accueil général du dictionnaire
            si les deux params $dataType=dictionnaire et $value=entry-id sont passé, renvoie la page de l'entrée de dictionnaire correspondant à entry-id 
:)

                    case "dictionnaire" return <section><img title="Photo © David Wittmann" src="http://desanti.tge-adonis.fr/archivenumerique/archive/theme_uploads/DST-pochette-accueil.png"/></section>
                    
                    
                   

(: Blocs Concepts et Personnes : 
            si seul le param $dataType=tags est passé, renvoie l'accueil général des subjects/persname
            si les deux params $dataType=tags et $value=tag-id sont passé, renvoie la page du mot-clé correspondant à tag-id 
:)
                    case "concepts" return  <section>{
                   
                       let $block := 
                       
                                    if(empty($value)) then desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:subject, "concepts", "cloud")
         
                                    else 
         
                                        <div>
                                        <b>Notices étiquetées avec : {$value}</b>
                                           {desanti:display-notices(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c[*:controlaccess/*:subject/text() = $value])}  
                                        </div>
                                    return $block
                                     }</section>
                                     
                                     
                                     
                                     
                    case "personnes" return  <section>{
                           let $block := 
                                    if(empty($value)) then desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:persname, "personnes", "cloud")
                                    else
                                        <div>
                                        <h1>Notices étiquetées avec : {$value}</h1>
                                           {desanti:display-notices(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c[*:controlaccess/*:persname/text() = $value])}  
                                        </div>                 
                       return $block
                        }</section>



(: Blocs A propos, Mentions légales, Crédits, Contacts
            
:)
                    case "a-propos" return  
                    <section>{
                                (<h1>À propos</h1>,
                                xslt:transform(db:open("desanti")//*[@xml:id='DST']/*:teiHeader//*:encodingDesc//*:editorialDecl, concat($ahn_commons:url_base, $desanti:xslt)))
                     }</section>
                    case "mentions-legales" return  
                    <section>{
                            (<h1>Mentions légales</h1>,
                            xslt:transform(db:open("desanti")//*[@xml:id='DST']/*:teiHeader//*:publicationStmt//*:availability, concat($ahn_commons:url_base, $desanti:xslt)))
                    }</section>
                    case "credits" return  
                    <section>{
                        (<h1>Crédits</h1>,
                        for $respStmt in db:open("desanti")//*[@xml:id='DST']/*:teiHeader//*:respStmt
                        
                                
                                let $resp := $respStmt/*:resp
                                group by $resp
                                return (<h2>{$resp}</h2>,
                                            for $name in $respStmt/*:name return xslt:transform($name, concat($ahn_commons:url_base, $desanti:xslt))))
                        
                   
                    }</section>
                    case "contacts" return  
                    <section>{
                        (<h1>Contacts</h1>,
                        xslt:transform(db:open("desanti")//*[@xml:id='DST']/*:teiHeader//*:publicationStmt//*:authority, concat($ahn_commons:url_base, $desanti:xslt)),
                        xslt:transform(db:open("desanti")//*[@xml:id='DST']/*:teiHeader//*:publicationStmt//*:address, concat($ahn_commons:url_base, $desanti:xslt)))     
                    }</section>






(:      ******************************
        Gestion de tous les autres cas
        ******************************
:)
                   default return <section>page inconnue</section>
    
    return $primary-block
    }</div>
};










declare function desanti:secondary($params) {

let $dataType := map:get($params,"dataType")
let $value := map:get($params,"value")
return
  <div id="secondary" class="{$dataType}">
         {let $secondary-block :=
         
         switch($dataType)
         
(:      ******************************
                    Home
        ******************************
:)
                        case "home" return 
                        <nav>
                        <p>Sur ce site sont publiées progressivement les valorisations numériques de l archive Desanti : catalogue des notices, transcriptions et facsimilés de manuscrits, dossiers documentaires consacrés à diverses thématiques, dictionnaire pour éclairer les concepts forgés ou investis par Desanti...</p>
                        <p>La conservation de l archive physique est assurée par l IMEC : 
                        <a title="Notice IMEC du fonds Desanti (cote DST)" href="http://www.imec-archives.com/fonds/desanti-jean-toussaint/">Fonds Jean-Toussaint Desanti (1914-2002)</a>
                        <a title="Institut Mémoires de l’édition contemporaine (IMEC)" href="http://www.imec-archives.com/"><img title="IMEC logo" src="http://www.imec-archives.com/wp-content/themes/imec/images/imec_logo_print.png" /></a>
                           </p>
                        </nav>   
 
(:      ******************************
                    Catalogue EAD
        ******************************
:)
                           
                        case "catalogue" return <nav>{
                            let $block := 
                                if(empty($value)) then
                                <span>                            
                        		        {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:subject, "concepts", "list")}                                        
                                        {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:persname, "personnes", "list")}                                           
                                </span>
                                
                                
                                
                                else 
                                <span>
                                
                                            {
                                            
                                            let $c := db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c[contains(@id, concat($value, '-EAD'))]
                                            let $subjects := if($c/*:controlaccess/*:subject) then desanti:display-tags($c/*:controlaccess/*:subject, "concepts", "list") else ()
                                            let $persnames := if($c/*:controlaccess/*:persname) then desanti:display-tags($c/*:controlaccess/*:persname, "personnes", "list") else ()
                                            return ($subjects, $persnames)
                                            }
                                            
                                            <p>{for $tei in db:open("desanti")/*:TEI[contains(@xml:id, concat($value, "-TEI"))]
                                            return <a title="Lire la transcription  de la pièce n°{$value}" href="/desanti/transcriptions/{$value}"><img  class="icone" alt="Lire la transcription de la pièce n°{$value}" src="http://www.tei-c.org/About/Logos/TEI-glow.png"/></a>
                                            }</p>
                                </span>
                                 
                            return $block
                        }</nav>



(:      ******************************
              Transcriptions TEI
        ******************************
:)
                        case "transcriptions" return <nav>{
                            
                            let $block := 
                            
                                if(empty($value)) then
                                <p>
                                {db:open("desanti")/*:teiCorpus//*:teiCorpus[@xml:id ="transcriptions"]//*:profileDesc}
                                </p>
                                
                                
                                else                             
                                 <span>
                                 {
                                for $item in db:open("desanti")/*[contains(@xml:id, concat($value, "-TEI"))]//*:respStmt
                                return <p>{$item//text()}</p>
                                }
                                <p>
                                <a title="Lire la notice de la pièce n°{$value}" href="/desanti/catalogue/{$value}"><img class="icone" alt="Lire la notice de la pièce n°{$value}" src="http://archive.desanti.huma-num.fr/static/img/ead.jpg"/></a>
                                </p>
                                </span>
                                
                            return $block
                        }</nav>


(:      ******************************
            Dossiers documentaires
        ******************************
:)
                         case "dossiers" return 
                               if(empty($value)) then <nav>{
                
                    let $block := 
                        
                       <div>
                        <h1>{string(db:open("desanti")//*[@xml:id = "DST-dossiers"]/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text())}</h1>
                        <ul>
                        {
                        for $item in db:open("desanti")//*[contains(@xml:id, "DST-dossier-")]
                        let $dossier-id := $item/@xml:id
                        let $titles := 
                           for $title in $item//*:titleStmt/*:title
                           return <span>{$title/@type}{$title/text()}</span>
                        return <li><a href="/desanti/dossiers/{$dossier-id}">{$titles}</a></li>
                        }
                        </ul>
                       </div>
                        
                    return $block
                    }</nav>
                               else 
                               <nav>
                               <h6>Lire les transcriptions de ce dossier</h6>
                               {let $item := db:open("desanti")//*[@xml:id=$value]
                               return
                                <ul>{
                                for $tei in $item//*:idno/@n
                                where db:open("desanti")/*[contains(@xml:id, concat($tei, "-TEI"))]
                                let $tei-title := db:open("desanti")/*[contains(@xml:id, concat($tei, "-TEI"))]//*:titleStmt/*:title/text()
                                return <li><a title="Pièce n°{string($tei)} : {$tei-title}" href="/desanti/transcriptions/{$tei}">{string($tei)}</a></li>
                                }</ul>
                                    }
                               </nav>
                                
                                
(:      ******************************
             Dictionnaire
        ******************************
:)                               
                                
                         case "dictionnaire" return
                              <nav> {
                        let $block-title := string(db:open("desanti")//*[@xml:id = "DST-dictionnaire"]/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text())
                        let $block := 
                        
                            if(empty($value)) then
                            <div>
                            <h1>{$block-title}</h1>
                            <ul>
                            {
                            for $item in db:open("desanti")//*:TEI[@xml:id = "DST-dictionnaire"]//*:div/*:p/*:list/*:item
                            return <li><a href="dictionnaire/{$item/@xml:id}">{$item/*:label/text()}</a></li>
                            }
                            </ul>
                            </div>
                            else 
                            <div>
                             <h1>{$block-title} : {$value}</h1>
                             <p>
                            {
                            for $item in db:open("desanti")//*:TEI[@xml:id = "DST-dictionnaire"]//*:div/*:p/*:list/*:item[@xml:id=$value]
                            return xslt:transform($item, concat($ahn_commons:url_base, $desanti:xslt))
                            }
                            </p>
                            </div>
                        return $block
                        }</nav>
                              
                              
                              
(:      ******************************
      Concepts (EAD >> controlaccess > subject)
        ******************************
:)                             
                         case "concepts" return
                            if(empty($value)) then <nav>Concepts indexant <b>au moins deux</b> notices du catalogue.
                            	    <br />Liste complète des concepts sur la page du <a href="/desanti/catalogue">catalogue</a></nav>
                            else
                            <nav>
                                           {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:subject, "concepts", "list")}
                                           
                                           {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:persname, "personnes", "list")}
                                </nav>
                                
                                
(:      ******************************
      Personnes (EAD >> controlaccess > persname)
        ******************************
:)                                  
                           case "personnes" return
                            if(empty($value)) then <nav>Noms de personnes indexant <b>au moins deux</b> notices du catalogue. 
                            	    <br /> Liste complète des noms de personnes sur la page du <a href="/desanti/catalogue">catalogue</a></nav>
                            else
                            <nav>
                                           {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:subject, "concepts", "list")}
                                           
                                           {desanti:display-tags(db:open("desanti")/*:ead/*:archdesc/*:dsc//*:c/*:controlaccess/*:persname, "personnes", "list")}
                                </nav>
                                
                                
(:      ******************************
        Gestion de tous les autres cas
        ******************************
:)                                
                          default  return <nav></nav>
                            
          return $secondary-block
          
          }</div>
};

declare function desanti:display-notices($collection) {
                       <table id="catalogue" class="tablesorter">
                       
                       <thead>
                       <tr><th>N° pièce</th><th>Titre</th><th>Date(s)</th><th>Notice détaillée</th><th>Transcription</th><th>Type</th></tr>
                      </thead>
                      <tbody>
                      {
                       for $item in $collection
                       let $notice-id := substring-before(substring-after($item/@id, '-'), '-')
                       return <tr>
                       <td>{string($notice-id)}</td>
                       <td>{$item/*:did/*:unittitle/text()}</td>
                       <td>{string($item/*:did/*:unitdate/@normal)}</td>
                       <td>
                       {let $detail := 
                       (: Notice détaillée : l item <c/> contient au moins un autre enfant en plus de <did/> :)
                       if($item/*[local-name()="scopecontent"]) then <a  title="Lire la notice détaillée" href="/desanti/catalogue/{$notice-id}">EAD</a>
                       else ''
                       return $detail
                       }</td>
                       <td>{for $tei in db:open("desanti")/*:TEI[contains(@xml:id, concat($notice-id, "-TEI"))]
                               return  
                               if ($tei//*:availability[@status="free"]) then <a  title="Lire la transcription" href="/desanti/transcriptions/{$notice-id}">⚐ TEI</a>
                               else <span title="Accès restreint">⚑ TEI</span>
                               }
                      </td>
                      <td>{$item/*:did/*:unittitle/*:genreform/text()}</td>      
                       </tr>
                       }
                       </tbody>
                       </table>

};
                   
                               
declare function desanti:display-tags($collection, $dataType, $mode){  
  let $label := if($dataType = "concepts") then "Concepts" else "Personnes"
  let $tag := if($dataType = "concepts") then "subject" else "persname"
  return <nav>
  <h3><a title="Voir en nuage de mots" href="/desanti/{ $dataType }">{ $label }</a></h3>
    <div class="{ $mode }">{
      for $term in $collection
      group by $term
      order by $term collation "?lang=fr"
      let $occurrences := count(
        ft:search("desanti", $term)/..[local-name() = $tag][
          ancestor::*:ead/
          parent::document-node()
        ][text() = $term]
      )
      return if($mode = "cloud") then (
      if($occurrences > 1) then
        <span><a style="font-size:{
          $occurrences idiv 10 + 1
        }em;padding:{
          $occurrences idiv 10
        }px;" title="{
          $occurrences
        } notices" href="/desanti/{$dataType}/{$term}">{$term}</a></span>
        else ''
      ) else (
        <span class="{
          $occurrences
        }"><a href="/desanti/{$dataType}/{$term}">{ $term }</a>
          ({ $occurrences })
        </span>
      )
    }</div>
  </nav>
};



declare function desanti:footer($params){  
<footer id="footer">
              <ul class="footer-logo">
                <li>
                  <a title="Atelier des Humanités Numériques" href="http://ahn.ens-lyon.fr"><img src="http://archive.desanti.huma-num.fr/static/img/logo_AHN_sm_blanc.png" alt="Logo de l’AHN"/></a>
                </li>
                <li>
                  <a title="ENS de Lyon" href="http://www.ens-lyon.fr"><img src="http://archive.desanti.huma-num.fr/static/img/logo_ENS_sm_blanc.png" alt="Logo de l’ENS de Lyon"/></a>
                </li>
              </ul>
              <div id="footer-text">
                    Ce site a été réalisé grâce à <a href="http://basex.org/" title="BaseX. The XML Database.">BaseX</a>, à SynopsX et au thème AHN.               
               </div>
</footer>
            
};

(: 
************************************
tests : JSON, etc. 
************************************

declare %restxq:path("{$project}/ead/xml")
        %output:method("xml")
function desanti:ead-to-xml($project) {
    let $ead := <json type="object">
        <items type="array">{
            for $item in db:open('Desanti')//*:ead//*:c
            let $type :=   if($item/@level='otherlevel') then 'insert' else 'pièce'
            let $label := $item/*:did/*:unitid/@identifier   
            let $titre :=   if($item/*:did/*:unittitle) then $item/*:did/*:unittitle/text() else 'pièce sans titre'
            let $node := <item type="object">
                        <type>{$type}</type>
                        <label>{string($label)}</label>
                        <titre>{$titre} </titre>
                        
                    </item>
            return $node
            }</items>
            </json>

   return json:parse('{
  "title": "Talk On Travel Pool",
  "link": "http://www.flickr.com/groups/talkontravel/pool/",
  "description": "Travel and vacation photos from around the world.",
  "modified": "2009-02-02T11:10:27Z",
  "generator": "http://www.flickr.com/"
}')
};

declare %restxq:path("{$project}/ead/json")
        %output:method("json")
function desanti:ead-to-json($project) {
    
    let $ead := desanti:ead-to-xml($project)
   return json:serialize-ml($ead)
};
 
    
   :) 
    
  
