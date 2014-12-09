xquery version "3.0" ;
module namespace synopsx.mappings.htmlUsers = 'synopsx.mappings.htmlUsers';
(:~
 : This module is an HTML demo for Users
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
declare default function namespace 'synopsx.mappings.htmlUsers';

(:~
 : This function create a user
 :)
declare function create-user($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      <form action="/create-user/apply" method='post'>
        <input type='text' name='name'/>
        <input type='submit' value='Create'/>
      </form>
    ),
    replace value of node .//*:title with $content('title')
  )
};


(:~
 : This function list users
 :)
declare function list-user($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      status($content('status')),
      <ul>
      {
        for $user in db:open('users')/users/user
        let $name := $user/@name/fn:string()
        (: let $name := $user/@name/string() :)
        return 
          <li>{ $name }  (<a href="delete-user/apply?name={ $name }">delete</a>)</li>
      }
      </ul>,
      <form action='create-user'>
        <input type='submit' value='Create User'/>
      </form>
    ),
    replace value of node .//*:title with $content('title')
  )
};


(:~
 : This function shows status
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
