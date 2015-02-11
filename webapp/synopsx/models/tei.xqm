xquery version "3.0" ;
module namespace synopsx.models.tei = 'synopsx.models.tei';
(:~
 : This module is for TEI models
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 :)

(: import module namespace G = "synopsx.globals" at '../globals.xqm'; :)

declare namespace tei = 'http://www.tei-c.org/ns/1.0';

declare default function namespace 'synopsx.models.tei';

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getTextsList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:TEI/tei:teiHeader
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste des textes', 
    'author' : getAuthors($texts),
    'copyright' : getCopyright($texts),
    'description' : getDescription($texts, $lang),
    'keywords' : getKeywords($texts, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getCorpusList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:teiCorpus/tei:teiHeader
  let $lang := 'la'
  let $meta := map{
    'title' : 'Liste de corpus', 
    'author' : getAuthors($texts),
    'copyright'  : getCopyright($texts),
    'description' : getDescription($texts, $lang),
    'subject' : getKeywords($texts, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBiblStructList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:listBibl
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Bibliographie'
    }
  let $content as map(*) := map:merge(
    for $item in $texts/tei:biblStruct
    order by fn:number(getBiblDate($item, $lang))
    return  map:entry( fn:generate-id($item), getBiblStruct($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getRespList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:respStmt
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Responsables de l édition'
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), getResp($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getHeader($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : getTitles($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item),
    'abstract' : getAbstract($item, $lang)
    (: ', teiAbstract' : getAbstract($item, $lang) :)
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getBiblStruct($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : getBiblTitles($item, $lang),
    'date' : getBiblDate($item, $dateFormat),
    'author' : getBiblAuthors($item),
    'tei' : $item
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getResp($item as element()) {
  let $lang := 'fr'
  return map {
    'name' : getName($item),
    'resp' : $item//tei:resp/text()
  }
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei builders
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:titleStmt//tei:title
    return fn:normalize-space($title(: (:[fn:starts-with(@xml:lang, $lang)]:) :)),
    ', ')
};

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getBiblTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:title
    return fn:normalize-space($title(: (:[fn:starts-with(@xml:lang, $lang)]:) :)),
    ', ')
};

(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*, $lang as xs:string){
  $content//tei:projectDesc//text()
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:titleStmt//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getBiblAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};

(:~
 : this function get the licence url
 : @param $content texts to process
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better !
 :)
declare function getCopyright($content){
  ($content//tei:licence/@target)[1]
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getDate($content as element()*, $dateFormat as xs:string){
  fn:normalize-space(
    $content//tei:publicationStmt/tei:date
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblDate($content as element()*, $dateFormat as xs:string){
  fn:normalize-space(
    $content//tei:imprint/tei:date
  )
};

(:~
 : this function get description
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getDescription($content as element()*, $lang as xs:string){
  fn:string-join(
    for $abstract in $content//tei:div[parent::tei:div(:[fn:starts-with(@xml:lang, $lang)]:)][@type='abstract']/tei:p 
    return fn:substring(fn:normalize-space($abstract), 0, 90),
    ', ')
};

(:~
 : this function get keywords
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of values
 :)
declare function getKeywords($content as element()*, $lang as xs:string){
  fn:string-join(
    for $terms in fn:distinct-values($content//tei:keywords(:[fn:starts-with(@xml:lang, $lang)]:)/tei:term) 
    return fn:normalize-space($terms), 
    ', ')
};

(:~
 : this function serialize persName
 : @param $named named content to process
 : @return concatenate forename and surname
 :)
declare function getName($named as element()*){
  fn:normalize-space(
    for $person in $named/tei:persName 
    return ($person/tei:forename || ' ' || $person/tei:surname)
    )
};

(:~
 : this function get tei doc by id
 : @param $id documents id to retrieve
 : @return a plain xml-tei document
 :)
declare function getXmlTeiById($queryParams){
  db:open(map:get($queryParams, 'dbName'))//tei:TEI[//tei:sourceDesc[@xml-id = map:get($queryParams, 'value')]]
}; 

(: (:~
 : this function get url
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 : @todo print the real uri
 :)
declare function getUrl($content as element()*, $lang as xs:string){
  $G:PROJECTBLOGROOT || $content//tei:sourceDesc/@xml:id
}; :)