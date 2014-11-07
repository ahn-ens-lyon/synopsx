module namespace synopsx.models.tei = 'synopsx.models.tei';
(:~
 : models.tei module for SynopsX
 :)
import module namespace G = "synopsx/globals" at '../globals.xqm';
import module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping'  at '../views/htmlWrapping.xqm';

declare default function namespace 'synopsx.models.tei';
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; 
declare variable $synopsx.models.tei:db := "gdpTei";

(:~
 : tei function, decides what to do wether config data and database already exist or not for this project
 : TODO entièrement
 :)
declare function title() as element(){ 
  (db:open($synopsx.models.tei:db)//titleStmt/title)[1]
}; 
 
declare function listItems() as element()* { 
  db:open($synopsx.models.tei:db)//titleStmt/title
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function listCorpus() {
  let $corpus := db:open($synopsx.models.tei:db)
  let $meta as map(*) := {
    'title' : 'Liste des corpus'
    }
  let $content as map(*) := map:merge(
    for $item in $corpus//tei:TEI/tei:teiHeader 
    return  map:entry(fn:generate-id($item), corpusHeader($item))
    )
  return  map{
    'meta'       : $meta,
    'content'    : $content
  }
};

(:~
 : this function creates a map with teiHeader for a corpus item
 :
 : @param $teiheader 
 :)
declare function corpusHeader($teiHeader) as map(*) {
  let $title as element()* := (
    $teiHeader//tei:titleStmt/tei:title
    )[1]
  let $date as element()* := (
    $teiHeader//tei:titleStmt/tei:date
    )[1]
  let $principal  as element()* := (
    $teiHeader//tei:titleStmt/tei:principal
    )[1]
  return map {
    'title'      : $title ,
    'date'       : $date ,
    'principal'  : $principal
  }
};