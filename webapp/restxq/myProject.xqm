(:
This file is part of SynopsX.
    created by AHN team (http://ahn.ens-lyon.fr)
    release 0.1, 2014-01-28
    
SynopsX is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

SynopsX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with SynopsX.  
If not, see <http://www.gnu.org/licenses/>
:)

module namespace myProject = 'http://ahn.ens-lyon.fr/myProject';

import module namespace webapp = 'http://ahn.ens-lyon.fr/webapp' at 'webapp.xqm';

(:-- récupérer les fichiers "equivalences.xml", "myproject.xml", ... dans la base "myProject"-->:)

declare variable $myProject:rubriques :=
<rubriques>
    <rubrique n="1" path="dictionary/it">
        <title>Dictionnaire italien</title>
        <file>dictionary_it.xml</file>
    </rubrique>
    <rubrique n="2" path="dictionary/fr">
        <title>Dictionnaire français</title>
        <file>dictionary_frm.xml</file>
    </rubrique>
    <rubrique n="3" path="equivalences/it-fr">
        <title>Equivalences (italien - français)</title>
        <file>equivalences.xml</file>
    </rubrique>
    <rubrique n="4" path="equivalences/fr-it">
        <title>Equivalences (français - italien)</title>
        <file>equivalences.xml</file>
    </rubrique>
    <rubrique n="5" path="parallel">
        <title>Corpus parallèle</title>
        <file>corpus.xml</file>
    </rubrique>
    <rubrique n="6" path="hypermachiavel">
        <title>Logiciel Hypermachiavel</title>
        <file></file>
    </rubrique>
</rubriques>;

declare function myProject:primary-nav($params){
    
    <div class="container navbar" id="primary-nav">
    <ul class="navigation">
        {
        for $item in $myProject:rubriques/rubrique
            return 
               if (concat(concat(map:get($params,"datatype"),"/"),map:get($params,"value")) eq $item/string(@path))
                then <li class="nav-accueil active"><a href="{$item/string(@path)}">{$item/title/text()}</a></li>
                else <li class="nav-entree"><a href="{$item/string(@path)}">{$item/title/text()}</a></li>
        }
    </ul>
  </div>(: <!-- end primary-nav --> :)
};

declare function myProject:secondary($params){
          <div id="secondary" class="col-4 col-sm-4 col-lg-4">
            <ul class="navigation">
              <div class="well sidebar-nav">
                <h2>Les versions du Prince</h2>
                  <ul class="nav">
                    {myProject:listTitles($params)}      
                  </ul>
                <h2>Vues parallèles</h2>
                  <ul class="nav">
                    <li>ON VA VOIR</li>
                  </ul> <!--/.end nav-->
              </div><!--/.well -->
            </ul><!--/navigation-->
          <!--secondary--> </div>
};

declare function myProject:listTitles($params) {
   for $tei in db:open(map:get($params,"project"),$myProject:rubriques/rubrique[@n="5"]/file)//*:TEI
        return <li>{$tei//*:sourceDesc//*:editor/text()} - {$tei//*:sourceDesc//*:date/text()}</li>
}; 
(:<li>{$tei//*:sourceDesc//*:title/text()} - {$tei//*:sourceDesc//*:editor/text()} - {$tei//*:sourceDesc//*:date/text()}</li>:)


declare function myProject:listEquivEntries($params) {
   let $value := map:get($params,"value")
   let $option := map:get($params,"option")
   return 
    if($option != '')
    then myProject:listEquivEntries-for-lemma($params)
    else ()
    
    (:abbandonare 	
    - formes it : abbandonato (2) 	
    - formes fr : abandonnera (Ch9, Ch10) ; abandonne (Ch11) ; abandonné (Ch5) 	
    
    Visualisation en camembert ou en graphes !!! Rechercher toutes les occurrences fr, group by auteur
    puis 
    <tr>
       <th width="15%">{$eq/word[@refText="f3"]/text/text()}</th>
       <th width="15%">{$eq/word[@refText="f5"]/text/text()}</th>
       <th width="15%">{$eq/word[@refText="f6"]/text/text()}</th>
       <th width="15%">{$eq/word[@refText="f1"]/text/text()}</th>
                                <th width="15%">{$eq/word[@refText="f7"]/text/text()}</th>
                           </tr>
    :)
};
   
declare function myProject:listEquivEntries-for-lemma($params) {
   let $value := map:get($params,"value")
   let $option := map:get($params,"option")
    
        for $eq in db:open(map:get($params,"project"),$myProject:rubriques/rubrique[@n="4"]/file)//equivalence
        where $eq/word[@refText="i1"]/text/text() = $option
        order by substring-before($eq/string(@loc),'-')
            return if ($value = "it-fr")
                    then 
                        if ($eq/word[@refText="i1"]/text/text() = $option)
                        then (:<li>{$option} - {$eq/word[@refText="i1"]/text/text()}</li>:)
                            <tr>
                                <th width="15%"><a href="/myProject/corpus/parallel/{substring-before($eq/string(@loc),'-')}">{$eq/string(@loc)}</a></th>
                                <th width="15%">{$eq/word[@refText="f3"]/text/text()}</th>
                                <th width="15%">{$eq/word[@refText="f5"]/text/text()}</th>
                                <th width="15%">{$eq/word[@refText="f6"]/text/text()}</th>
                                <th width="15%">{$eq/word[@refText="f1"]/text/text()}</th>
                                <th width="15%">{$eq/word[@refText="f7"]/text/text()}</th>
                           </tr>
                        else ()
                        (:if ($eq/word[@refText="i1"]/text/text() = $option)
                        then <li>{$eq/word[@refText="i1"]/text/text()}</li>
                        else <li>RIEN en it</li>:)
                    else if ($eq/word[starts-with(@refText,'f')]/text/text() = $option)
                        then 
                            <tr>
                                <th width="15%">{$eq/string(@loc)}</th>
                                <th width="75%">{$eq/word[@refText="i1"]/text/text()}</th>  
                           </tr>
                        else ()
     
        (: group by $eq/word[@refText="i1"]/text/text():)
};

declare function myProject:listDicoAlphaIndex($params) {
    let $dataType := map:get($params,"dataType")
    let $value := map:get($params,"value")
    let $option := map:get($params,"option")
   
    return <p><span><a href="../{$dataType}/{$value}/A">A</a></span>
    <span><a href="../{$dataType}/{$value}/B">B</a></span>
    <span><a href="../{$dataType}/{$value}/C">C</a></span>
    <span><a href="../{$dataType}/{$value}/D">D</a></span>
    <span><a href="../{$dataType}/{$value}/E">E</a></span>
    <span><a href="../{$dataType}/{$value}/F">F</a></span>
    </p>
};

declare function myProject:listDicoEntries($params) {
    let $value := map:get($params,"value")
    let $option := map:get($params,"option")
    
     (:- rubrique[@path="concat(concat($value,"/"),$option)"]/file  --:)
    for $lemma in db:open(map:get($params,"project"),$myProject:rubriques/rubrique[@path="dictionary/it"]/file)//*:entry
    where starts-with(lower-case($lemma/form/orth[@type="lemma"]/text()),lower-case($option))
        return  
                if(starts-with(lower-case($lemma/form/orth[@type="lemma"]/text()), lower-case($option)))
                then 
                    if ($option eq $lemma/form/orth[@type="lemma"]/text())
                    then 
                     <li><a href="#{$lemma/string(@xml:id)}">{$lemma/form/orth[@type="lemma"]/text()}</a> 
            (<a href="../equivalences/it-fr/{$lemma/form/orth[@type="lemma"]/text()}">voir les équivalences françaises</a>)
                        <ul>
                            {myProject:display-dico-entry($params, $lemma)}
                        </ul>
                    </li>
                else
                    if ($option = "")
                    then <li><a href="../dictionary/it/{$lemma/form/orth[@type="lemma"]/text()}">{$lemma/form/orth[@type="lemma"]/text()}</a></li>
                    else <li><a href="{$lemma/form/orth[@type="lemma"]/text()}">{$lemma/form/orth[@type="lemma"]/text()}</a></li>
                else <li>aucune entrée pour {$option}</li>
};

declare function myProject:display-dico-entry($params, $lemma){
       for $form in $lemma/form/orth
       return <li>{$form/text()}</li>
};

declare function myProject:display-text($params, $id) {
     let $value := map:get($params,"value")
     let $option := map:get($params,"option")
     (: ATTENTION il faut pouvoir prendre en compte $id : 
         <li>{$id}</li> i1
     :)
    let $tei := db:open(map:get($params,"project"),$myProject:rubriques/rubrique[@n="5"]/file)//*:TEI//*:fileDesc/*:sourceDesc/*:biblStruct/*:monogr[@xml:id=$id]/ancestor::TEI
    for $div in $tei//*:div
        let $div_id := $div/substring-after(string(@xml:id),"_")
        return if ($option eq $div_id)
            then <li><a href="../../corpus/{$value}/{$div/substring-after(string(@xml:id),"_")}">{$div/substring-after(string(@xml:id),"_")} : {$div/*:head//text()}</a>
                    <ul>
                        {myProject:display-div($params, $div)}
                    </ul>
                 </li>   
            else
                if ($option = "")
                then <li><a href="../corpus/{$value}/{$div/substring-after(string(@xml:id),"_")}">{$div/substring-after(string(@xml:id),"_")} : {$div/*:head//text()}</a></li>   
                else <li><a href="../../corpus/{$value}/{$div/substring-after(string(@xml:id),"_")}">{$div/substring-after(string(@xml:id),"_")} : {$div/*:head//text()}</a></li>   
};

declare function myProject:display-div($params, $div) {
    let $value := map:get($params,"value")
    let $option := map:get($params,"option")
       
    for $div_div in $div/*:seg
        return <li>{$div_div/substring-after(string(@xml:id),"_")} : {$div_div/text()}</li>   
};

declare function myProject:primary($params){
let $dataType := map:get($params,"dataType")
let $value := map:get($params,"value")
let $option := map:get($params,"option")

return <div id="primary" class="{$dataType}">
         {let $block :=
         
         switch($dataType)
         case "home" return 
                <section>
                    <h1>Bienvenue sur le site du corpus Hyperprince</h1>
                    <p>Ce travail de mise en ligne s'incrit dans le projet ANR guerres 16/17 (2007-2011), piloté par Jean-Louis Fournel.</p>Le corpus est le résultat de la compilation de cinq éditions du Prince mises en parallèle :
                    <ul>
                        <li>la version originale de Machiavel parue en 1532 (Blado)</li>
                        <li>la traduction de Jacques de Vintimille, datée de 1546 (suite à une transcription/édition par Nella Bianchi Bensimon,  mise en ligne par l'ENS (LSH) de Lyon en 2005).</li>
                        <li>la traduction de Guillaume Cappel parue en 1553</li>
                        <li>la traduction de Gaspard d'Auvergne parue en 1553 (version reprise sous la même forme lors de l'édition de 1571 des Discours)</li>
                        <li>la traduction de Jacques Gohory parue en 1571</li>
                    </ul>
                    <p>Vues en parallèle des textes</p>
                </section>
                
         case "dictionary" return  
            switch($value)
                case "fr" return 
                    <section>
                        <h4>Dictionnaire français ({$value})</h4>
                       
                         {myProject:listDicoAlphaIndex($params)}
                  
                         {myProject:listDicoEntries($params)}  
                       
                    </section>
                case "it" return 
                    <section>
                        <h4>Dictionnaire italien ({$value})</h4>
                        {myProject:listDicoAlphaIndex($params)}
                        
                         {myProject:listDicoEntries($params)}  
                    </section>
                default return 
                    <p>Aucun dictionnaire {$value}</p>
                  
         case "equivalences" return                            
            switch($value)
                case "it-fr" return  
                    <section>
                        <h4>Equivalences {$value} pour le concept : {$option}</h4>
                            <div>
                                <p>Liste de ses occurrences</p>
                                <table width="100%" border="1">
                                    <tbody>
                                         <!--<tr>
                                            <th width="25%">Lemme (it)</th>
                                            <th width="25%">Formes fléchies (nb occurrences)</th>
                                            <th width="25%">Equivalents formes (fr)</th>
                                            <th width="25%">Localisations</th>
                                         </tr>-->
                                         <tr>
                                           <th width="15%">Localisation</th>
                                           <th width="15%">Chez Vintimille 1546</th>
                                           <th width="15%">Chez Auvergne 1553</th>
                                           <th width="15%">Chez Cappel 1553</th>
                                           <th width="15%">Chez Gohory 1571</th>
                                           <th width="15%">Chez Houssaie 1694</th>
                                         </tr>
                                            {myProject:listEquivEntries($params)}  
                                    </tbody>
                                </table>
                            </div>
                           </section>
                            
                case "fr-it" return 
                    <section>
                        <h4>Equivalences {$value}</h4>
                            <div>
                                <table width="100%" border="1">
                                    <tbody>
                                        <tr>
                                           <th width="15%">Localisation</th>
                                           <th width="75%">Chez Blado 1532</th>
                                         </tr>
                                             {myProject:listEquivEntries($params)} 
                                    </tbody>
                                </table>
                            </div>
                           </section>
                                         
                          default return 
                                    <p>Aucunes équivalences pour {$value}</p>
               
               
                                      
        case "hypermachiavel" return 
           <section>
                    <h2>Logiciel HyperMachiavel</h2>
                    <h3>Outil d'alignement et de comparaison de traductions, d'annotation lexicale</h3>
                    
                    <p>Dans le contexte de l’édition critique électronique et des corpus numériques, 
                    Hypermachiavel propose diverses fonctionnalités autour de l’établissement d’un corpus 
                    de textes parallèles (par exemple un texte et ses traductions, ou différentes versions 
                    d’édition d’un même texte) et incite l’exploration lexicale, voire conceptuelle, 
                    à l’aide de fonctions de recherche et d’annotation semi-automatique. 
                    Il cherche également à répondre à des problématiques d’études de traduction, 
                    de philologie des textes.</p>
                    
                    <p>Ce logiciel est en cours de développement (voir la fiche Plume).
                        <ul>
                            <li>Contact concepteur : Séverine Gedzelman</li>
                            <li>Système : Windows, Mac</li>
                            <li>Licence libre : CECILL- B</li>
                        </ul>
                    </p>
             </section>
        case "corpus" return
            switch($value)
                case "parallel" return  
                    <section>
                    <h1>Vue parallèle</h1>
                    
                    <!-- Ch6-Seg10-->
                    
                    </section>
                case "blado" return  
                    <section>
                        <h1>Edition de Antonio Blado - 1532</h1>
                        {myProject:display-text($params, "i1")}
                    </section>
                case "vintimille" return  
                    <section>
                        <h1>Edition de Jacques Vintimille - 1546</h1>
                        {myProject:display-text($params, "f3")}
                    </section>
                case "gohory" return  
                    <section>
                        <h1>Edition de Jacques Gohory - 1571</h1>
                        {myProject:display-text($params, "f1")}
                    </section>
                case "cappel" return  
                    <section>
                        <h1>Edition de Guillaume Cappel - 1553</h1>
                        {myProject:display-text($params, "f4")}
                    </section>
                 case "cappel" return  
                    <section>
                        <h1>Edition de Gaspard d'Auvergne - 1532</h1>
                        {myProject:display-text($params, "f4")}
                    </section>
                default return <section>Aucun texte dans le corpus avec un tel nom : {$value}</section>
      default return <section>Page introuvable {$value}</section>
                
      return $block
  }  
  </div> 
};