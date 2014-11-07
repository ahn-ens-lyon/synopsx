module namespace synopsx.models.tei = 'synopsx.models.tei';
(:~
 : Module for TEI models
 : @author: synopsx team 
 :)
 
(: This is the default namespace:)
declare default function namespace 'synopsx.models.tei';

(: Add namespaces:)
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; 

(: dbname TODO choose an implementation :)
declare variable $synopsx.models.tei:db := "hyperdonat";

(:~
 : tei function, decides what to do wether config data and database already exist or not for this project
 :)
 
(: return the corpus title:)
declare function synopsx.models.tei:title() as element(){ 
  (db:open($synopsx.models.tei:db)//tei:titleStmt/tei:title)[1]
}; 
 
(: return a titles list :)
declare function synopsx.models.tei:listItems() as element()* { 
  db:open($synopsx.models.tei:db)//tei:titleStmt/tei:title
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:listCorpus() {
  let $corpus := db:open($synopsx.models.tei:db) (: openning the database:)
  let $meta as map(*) := {'title' : 'Liste des corpus'} (: title page:)
  let $content as map(*) :=  map:merge(
    for $item in $corpus//tei:TEI/tei:teiHeader (: every teiHeader is add to the map with arbitrary key and the result of  corpusHeader() function apply to this teiHeader:)
      return  map:entry(fn:generate-id($item), corpusHeader($item)) 
    )
  return  map{
    'meta' : $meta,
    'content' : $content
  }
};

(:~
 : this function creates a map with headers within a corpus
 :)
declare function corpusHeader($teiHeader) as map(*) {
 map {
    'title' : $teiHeader//tei:titleStmt/tei:title/text(),
    'date' : $teiHeader//tei:titleStmt/tei:date/text(),
    'principal' : $teiHeader//tei:titleStmt/tei:principal/text()
  }
};