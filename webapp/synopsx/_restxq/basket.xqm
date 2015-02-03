xquery version "3.0" ;
module namespace synopsx.basket = 'synopsx.basket';
(:~
 : This module is a RESTXQ demo for user's basket
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
 : @todo improve and implement
:)

import module namespace Session = "http://basex.org/modules/session";

import module namespace G = "synopsx.globals" at '../globals.xqm';

import module namespace synopsx.webapp = 'synopsx.webapp' at 'webapp.xqm';
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei/tei.xqm';
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';

declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: déclaration pour test :)

(:~
 : This ressource function si a test for basket
 :)
declare
  %rest:path('/basket')
  %rest:query-param('status', '{$status}')
  %output:method('html')
function synopsx.basket:tei(
  $status  as xs:string?
) {
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content as map(*) := map {
    'title' : synopsx.models.tei:title(),
    'items' : synopsx.models.tei:listItems(),
    'status': $status
  }
  let $options as map(*) := map {
        'mode' : 'short'  
    }
  let $layout as map(*) := map {
        'layout' : $G:TEMPLATES || 'html.xhtml'
    }
  (:
  : @TODO negociation de contenu
  :)
  return '' (: @depreciated synopsx.mappings.htmlWrapping:render($content, $options, $layout) :)
};


(:~
 : This ressource function shows basket's user content
 :)
declare
  %rest:path('/basket/select')
  %rest:method('post')
  %rest:form-param('items', '{$items}')
  %rest:form-param('user' , '{$user}')
function synopsx.basket:select(
  $items  as xs:string*,
  $user   as xs:string
) {

  let $xml :=
    <selected>{
      for $item in $items
      return <item>{ $item }</item>
    }</selected>
  return Session:set("selected", $xml),
  Session:set("user", $user),

  <rest:redirect>/tei?status={ $G:OK }</rest:redirect>
};

