xquery version "3.0" ;
module namespace synopsx.mappings.htmlBasket = 'synopsx.mappings.htmlBasket';
(:~
 : This module is an HTML demo for a user's basket
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
 : @rmq to implement
 :)
import module namespace Session = "http://basex.org/modules/session";

import module namespace G = "synopsx.globals" at '../globals.xqm';

(: Use a default namespace :)
declare default function namespace 'synopsx.mappings.htmlBasket';

(:~
 : This function is a form to register an user 
 :)
declare function form($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      let $items := $content('items')
      let $status := $content('status')
      return
        <form action="/tei/select" method='post'>
          { status($status) }
          <input type='submit' value='ORDER'/>
          <br/>
          User: <input type='text' name='user' value='{ Session:get("user") }'/>
          <br/>
          {
            let $selected := Session:get("selected")/item
            for $item at $p in $items
            return (
              element input {
                attribute type { 'checkbox' },
                attribute name { 'items' },
                attribute checked { 'checked' }[$p = $selected],
                attribute value { $p },
                $item/text()
              },
              <br/>
            )
        }</form>
    ),
    replace value of node .//*:title with $content('title')
  )
};


(:~
 : This function check user status and return a message
 : 
 : @rmq To mutualise 
 :)
declare function status(
  $status as xs:string
) {
  let $msg := $G:STATUS($status)
  return if($msg) then (
    <div>Status: { $msg }</div>
  ) else (
    (: Safer: catch unknown status
      error(xs:QName('INVALID'), "Unknown status.") :)
   <div>No status</div>
  )
};
