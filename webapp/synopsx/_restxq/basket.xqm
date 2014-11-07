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

module namespace basket = 'http://ahn.ens-lyon.fr/basket';

import module namespace webapp = 'http://ahn.ens-lyon.fr/webapp' at 'webapp.xqm';
import module namespace Session = "http://basex.org/modules/session";

import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';
import module namespace synopsx.mapping.htmlWrapping = 'synopsx.mapping.htmlWrapping' at '../mapping/htmlWrapping.xqm';

import module namespace G = "synopsx/globals" at '../globals.xqm';

declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: déclaration pour test :)

declare
  %rest:path('/basket')
  %rest:query-param('status', '{$status}')
  %output:method('html')
function basket:tei(
  $status  as xs:string?
) {
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content as map(*) := map {
    'title' := synopsx.models.tei:title(),
    'items' := synopsx.models.tei:listItems(),
    'status':= $status
  }
  let $options as map(*) := map {
        'mode' := 'short'  
    }
  let $layout as map(*) := map {
        'layout' := $G:TEMPLATES || 'html.xhtml'
    }
  (:
  : @TODO negociation de contenu
  :)
  return synopsx.mapping.htmlWrapping:render($content, $options, $layout)
};

declare
  %rest:path('/basket/select')
  %rest:method('post')
  %rest:form-param('items', '{$items}')
  %rest:form-param('user' , '{$user}')
function basket:select(
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

