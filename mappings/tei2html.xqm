xquery version '3.0' ;
module namespace synopsx.mappings.tei2html = 'synopsx.mappings.tei2html' ;

(:~
 : This module is a TEI to html function library for SynopsX
 :
 : @version 2.0 (Constantia edition)
 : @since 2015-02-17 
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
 :)

declare namespace tei = 'http://www.tei-c.org/ns/1.0';

declare default function namespace 'synopsx.mappings.tei2html' ;

(:~
 : this function 
 :)
declare function entry($node as node()*, $options as xs:string) as element() {
  <div>{ dispatch($node, $options) }</div>
};

(:~
 : this function dispatches the treatment of the XML document
 :)
declare function dispatch($node as node()*, $options as xs:string) as item()* {
  typeswitch($node)
    case text() return $node
    case element(tei:teiHeader) return ''
    case element(tei:TEI) return passthru($node, $options)
    case element(tei:text) return passthru($node, $options)
    case element(tei:front) return passthru($node, $options)
    case element(tei:body) return passthru($node, $options)
    case element(tei:back) return passthru($node, $options)
    case element(tei:div) return div($node, $options)
    case element(tei:head) return head($node, $options)
    case element(tei:p) return p($node, $options)
    case element(tei:list) return list($node, $options)
    case element(tei:item) return synopsx.mappings.tei2html:item($node, $options)
    case element(tei:label) return label($node, $options)
    case element(tei:hi) return hi($node, $options)
    case element(tei:ref) return ref($node, $options)
    case element(tei:said) return said($node, $options)
    case element(tei:lb) return <br/>
    case element(tei:figure) return figure($node, $options)
    case element(tei:listBibl) return listBibl($node, $options)
    case element(tei:biblStruct) return biblItem($node, $options)
    case element(tei:bibl) return biblItem($node, $options)
    case element(tei:analytic) return getAnalytic($node, $options)
    case element(tei:monogr) return getMonogr($node, $options)
    case element(tei:edition) return getEdition($node, $options)
    (: case element(tei:author) return getResponsability($node, $options) :)
    (: case element(tei:editor) return getResponsability($node, $options) :)
    case element(tei:persName) return persName($node, $options)
    default return passthru($node, $options)
};

(:~
 : This function pass through child nodes (xsl:apply-templates)
 :)
declare function passthru($nodes as node(), $options) as item()* {
  for $node in $nodes/node()
  return dispatch($node, $options)
};


(:~
 : ~:~:~:~:~:~:~:~:~
 : tei textstructure
 : ~:~:~:~:~:~:~:~:~
 :)

declare function div($node as element(tei:div)+, $options) {
  <div>
    { if ($node/@xml:id) then attribute id { $node/@xml:id } else (),
    passthru($node, $options)}
  </div>
};

declare function head($node as element(tei:head)+, $options) as element() {   
  if ($node/parent::tei:div) then
    let $type := $node/parent::tei:div/@type
    let $level := if (fn:count($node/ancestor::div) > 0) then fn:count($node/ancestor::div) else 1
    return element { 'h' || $level } { passthru($node, $options) }
  else if ($node/parent::tei:figure) then
    if ($node/parent::tei:figure/parent::tei:p) then
      <strong>{ passthru($node, $options) }</strong>
    else <p><strong>{ passthru($node, $options) }</strong></p>
  else if ($node/parent::tei:list) then
    <li>{ passthru($node, $options) }</li>
  else if ($node/parent::tei:table) then
    <th>{ passthru($node, $options) }</th>
  else  passthru($node, $options)
};

declare function p($node as element(tei:p)+, $options) {
  <p>{ passthru($node, $options) }</p>
};

declare function list($node as element(tei:list)+, $options) {
  switch ($node) 
  case $node/@type='ordered' return <ol>{ passthru($node, $options) }</ol>
  case $node[child::tei:label] return <dl>{ passthru($node, $options) }</dl>
  default return <ul>{ passthru($node, $options) }</ul>
};

declare function synopsx.mappings.tei2html:item($node as element(tei:item)+, $options) {
  switch ($node)
  case $node[parent::*/tei:label] return <dd>{ passthru($node, $options) }</dd>
  default return <li>{ passthru($node, $options) }</li>
};

declare function label($node as element(tei:label)+, $options) {
  <dt>{ passthru($node, $options) }</dt>
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei inline
 : ~:~:~:~:~:~:~:~:~
 :)
declare function hi($node as element(tei:hi)+, $options) {
  switch ($node)
  case ($node/@rend='italic' or $node/@rend='it') return <em>{ passthru($node, $options) }</em> 
  case ($node/@rend='bold' or $node/@rend='b') return <strong>{ passthru($node, $options) }</strong>
  case ($node/@rend='superscript' or $node/@rend='sup') return <sup>{ passthru($node, $options) }</sup>
  case ($node/@rend='underscript' or $node/@rend='sub') return <sub>{ passthru($node, $options) }</sub>
  case ($node/@rend='underline' or $node/@rend='u') return <u>{ passthru($node, $options) }</u>
  case ($node/@rend='strikethrough') return <del class="hi">{ passthru($node, $options) }</del>
  case ($node/@rend='caps' or $node/@rend='uppercase') return <span calss="uppercase">{ passthru($node, $options) }</span>
  case ($node/@rend='smallcaps' or $node/@rend='sc') return <span class="small-caps">{ passthru($node, $options) }</span>
  default return <span class="{$node/@rend}">{ passthru($node, $options) }</span>
};

declare function ref($node as element(tei:ref), $options) {
  <a>{ passthru($node, $options) }</a>
};

declare function said($node as element(tei:said), $options) {
  <quote>{ passthru($node, $options) }</quote>
};


declare function figure($node as element(tei:figure), $options) {
  <figure>{ passthru($node, $options) }</figure>
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei biblio
 : ~:~:~:~:~:~:~:~:~
 :)

declare function listBibl($node, $options) {
  <ul id="{$node/@xml:id}">{ passthru($node, $options) }</ul>
};

declare function biblItem($node, $options) {
   <li id="{$node/@xml:id}">{ passthru($node, $options) }</li>
};

(:~
 : This function treats tei:analytic
 : @todo group author and editor to treat distinctly
 :)
declare function getAnalytic($node, $options) {
  getResponsabilities($node, $options), 
  getTitle($node, $options)
};

(:~
 : This function treats tei:monogr
 :)
declare function getMonogr($node, $options) {
  getResponsabilities($node, $options),
  getTitle($node, $options),
  getEdition($node/node(), $options),
  getImprint($node/node(), $options)
};


(:~
 : This function get responsabilities
 : @todo group authors and editors to treat them distinctly
 : @todo "éd." vs "éds."
 :)
declare function getResponsabilities($node, $options) {
  let $nbResponsabilities := fn:count($node/tei:author | $node/tei:editor)
  for $responsability at $count in $node/tei:author | $node/tei:editor
  return if ($count = $nbResponsabilities) then (getResponsability($responsability, $options), '. ')
    else (getResponsability($responsability, $options), ' ; ')
};

(:~
 : si le dernier auteur mettre un séparateur à la fin
 :
 :)
declare function getResponsability($node, $options) {
  if ($node/tei:forename or $node/tei:surname) 
  then getName($node, $options) 
  else passthru($node, $options)
};

declare function persName($node, $options) {
    getName($node, $options)
};

(:~
 : this fonction concatenate surname and forname with a ', '
 :
 : @todo cases with only one element
 :)
declare function getName($node, $options) {
  if ($node/tei:forename and $node/tei:surname)
  then ($node/tei:forename || ', ', <span class="smallcaps">{$node/tei:surname/text()}</span>)
  else if ($node/tei:surname) then <span class="smallcaps">{$node/tei:surname/text()}</span>
  else if ($node/tei:forename) then $node/tei:surname/text()
  else passthru($node, $options)
};

(:~
 : this function returns title in an html element
 :
 : different html element whereas it is an analytic or a monographic title
 : @todo serialize the text properly for tei:hi, etc.
 :)
declare function getTitle($node, $options) {
  for $title in $node/tei:title
  let $separator := '. '
  return if ($title[@level='a'])
    then (<span class="title">« {$title/text()} »</span>, $separator)
    else (<em class="title">{$title/text()}</em>, $separator)
};

declare function getEdition($node, $options) {
  $node/tei:edition/text()
};

declare function getMeeting($node, $options) {
  $node/tei:meeting/text()
};

declare function getImprint($node, $options) {
  for $vol in $node/tei:biblScope[@type='vol']
  return $vol, 
  for $pubPlace in $node/tei:pubPlace
  return 
    if ($pubPlace) then ($pubPlace/text(), ' : ')
    else 's.l. :',
  for $publisher in $node/tei:publisher
  return 
    if ($publisher) then ($publisher/text(), ', ')
    else 's.p.'
};
