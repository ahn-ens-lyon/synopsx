(:~
 : tei function module for SynopsX
 :)
 
module namespace synopsx.models.tei = 'synopsx.models.tei';
import module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping'  at '../views/htmlWrapping.xqm';
declare default function namespace 'synopsx.models.tei';

declare default element namespace 'http://www.tei-c.org/ns/1.0'; 

declare variable $synopsx.models.tei:db := "gdpTei";

(:~
 : tei function, decides what to do wether config data and database already exist or not for this project
 : TODO entièrement
 :)
declare function synopsx.models.tei:title() as element(){ 
  (db:open($synopsx.models.tei:db)//titleStmt/title)[1]
}; 
 
declare function synopsx.models.tei:listItems() as element()* { 
  db:open($synopsx.models.tei:db)//titleStmt/title
};

(:~
 : this function creates a map with a map for each corpus items
 :)
declare function synopsx.models.tei:listCorpus() {
  let $corpus := db:open($synopsx.models.tei:db)//TEI/teiHeader
  let $content as map(*) := {'title' : 'Liste des corpus'}
  for $item in $corpus
    let $content := map:put($content, ($item//idno)[1] , corpusHeader($item))
  return $content
};

(:~
 : this function creates a map for a corpus item
 :)
declare function corpusHeader($item) as map(*) {
  for $teiHeader in $item
  return map {
    'title' : ($teiHeader//titleStmt/title)[1],
    'date' : $teiHeader//titleStmt/date,
    'principal' : $teiHeader//titleStmt/principal
  }
};