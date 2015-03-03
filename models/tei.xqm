xquery version '3.0' ;
module namespace synopsx.models.tei = 'synopsx.models.tei' ;

(:~
 : This module is for TEI models
 :
 : @version 2.0 (Constantia edition)
 : @since 2014-11-10 
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
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)


declare namespace lib.commons = 'synopsx.lib.commons' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:getTextsList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:TEI
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste des textes', 
    'author' : synopsx.models.tei:getAuthors($texts),
    'copyright' : synopsx.models.tei:getCopyright($texts),
    'description' : synopsx.models.tei:getDescription($texts, $lang),
    'subject' : synopsx.models.tei:getKeywords($texts, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    let $corpusId := string($item/@xml:id)
    let $header as map(*) := synopsx.models.tei:getHeader($item)
    return  map:entry( fn:generate-id($item), map:put($header, 'textId', $corpusId) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:getCorpusList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:teiCorpus
  let $lang := 'la'
  let $meta := map{
    'title' : 'Liste des corpus', 
    'author' : synopsx.models.tei:getAuthors($texts),
    'copyright'  : synopsx.models.tei:getCopyright($texts),
    'description' : synopsx.models.tei:getDescription($texts, $lang),
    'subject' : synopsx.models.tei:getKeywords($texts, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    let $corpusId := string($item/@xml:id)
    let $header as map(*) := synopsx.models.tei:getHeader($item)
    return  map:entry( fn:generate-id($item), map:put($header, 'corpusId', $corpusId) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:getBiblList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:bibl
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Bibliographie'
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    order by fn:number(synopsx.models.tei:getBiblDate($item, $lang))
    return  map:entry( fn:generate-id($item), synopsx.models.tei:getBibl($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function synopsx.models.tei:getRespList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:respStmt
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Responsables de l édition'
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), synopsx.models.tei:getResp($item) )
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
declare function synopsx.models.tei:getHeader($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : synopsx.models.tei:getTitles($item/tei:teiHeader, $lang),
    'date' : synopsx.models.tei:getDate($item/tei:teiHeader, $dateFormat),
    'author' : synopsx.models.tei:getAuthors($item/tei:teiHeader),
    'abstract' : synopsx.models.tei:getAbstract($item/tei:teiHeader, $lang)
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function synopsx.models.tei:getBibl($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : synopsx.models.tei:getBiblTitles($item, $lang),
    'date' : synopsx.models.tei:getBiblDate($item, $dateFormat),
    'author' : synopsx.models.tei:getBiblAuthors($item),
    'content' : $item
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function synopsx.models.tei:getResp($item as element()) {
  let $lang := 'fr'
  return map {
    'name' : synopsx.models.tei:getName($item),
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
declare function synopsx.models.tei:getTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:titleStmt//tei:title
    return fn:string-join($title(: (:[fn:starts-with(@xml:lang, $lang)]:) :)), ', ')
};

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function synopsx.models.tei:getBiblTitles($content as element()*, $lang as xs:string){
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
declare function synopsx.models.tei:getAbstract($content as element()*, $lang as xs:string){
  $content//tei:projectDesc//text()
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function synopsx.models.tei:getAuthors($content as element()*){
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
declare function synopsx.models.tei:getBiblAuthors($content as element()*){
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
declare function synopsx.models.tei:getCopyright($content){
  ($content//tei:licence/@target)[1]
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function synopsx.models.tei:getDate($content as element()*, $dateFormat as xs:string){
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
declare function synopsx.models.tei:getBiblDate($content as element()*, $dateFormat as xs:string){
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
declare function synopsx.models.tei:getDescription($content as element()*, $lang as xs:string){
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
declare function synopsx.models.tei:getKeywords($content as element()*, $lang as xs:string){
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
declare function synopsx.models.tei:getName($named as element()*){
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
declare function synopsx.models.tei:getXmlTeiById($queryParams){
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