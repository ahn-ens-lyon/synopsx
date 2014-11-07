(:~
 : tei function module for SynopsX
 :)
 
module namespace synopsx.models.tei = 'synopsx.models.tei';
import module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping'  at '../views/htmlWrapping.xqm';
declare default function namespace 'synopsx.models.tei';

declare default element namespace 'http://www.tei-c.org/ns/1.0'; 

declare variable $synopsx.models.tei:db := "hyperdonat";

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
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:listCorpus() {
  let $corpus := db:open($synopsx.models.tei:db)
  let $meta as map(*) := {'title' : 'Liste des corpus'}
  let $content as map(*) :=  map:merge(
    for $item in $corpus//TEI/teiHeader 
      
      return  map:entry(fn:generate-id($item), corpusHeader($item))
    )
  return  map{
    'meta' : $meta,
    'content' : $content
  }
};

(:~
 : this function creates a map for a corpus item
 :)
declare function corpusHeader($teiHeader) as map(*) {
 map {
    (: 'title' : ($teiHeader//*:titleStmt/*:title)[1],
    'date' : ($teiHeader//*:titleStmt/*:date)[1],
    'principal' : ($teiHeader//*:titleStmt/*:principal)[1] :)
    'title' : 'myTitle',
    'date' : 'myDate',
    'principal' : 'myPrincipal'
  }
};