xquery version "3.0" ;
module namespace synopsx.users = 'synopsx.users';
(:~
 : This module is a demo RESTXQ for Content negociation
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
 : @todo to implement
 :)

import module namespace G = "synopsx.globals"  at '../globals.xqm';
import module namespace Session = "http://basex.org/modules/session";

import module namespace synopsx.synopsx = 'synopsx.synopsx' at 'synopsx.xqm';

import module namespace synopsx.models.tei = 'synopsx.models.tei'  at '../models/tei.xqm';
import module namespace synopsx.mappings.htmlUsers = 'synopsx.mappings.htmlUsers'  at '../mappings/htmlUsers.xqm';


(:~
 : 
 :)
declare
  %rest:path('/create-user')
  %output:method('html')
function synopsx.users:create-user() {
   let $queryParams := map {
    "project" : 'basket',
    "dataType" : 'home'
      }
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content := map {
    'title' : synopsx.models.tei:getTitle($queryParams),
    'items' : ()
  }
  let $outputParams := map { }
  let $layout := map {
    'layout' : $G:HOME || 'templates/html.xhtml'
  }
  return synopsx.mappings.htmlUsers:create-user($content, $outputParams, $layout)
};


(:~
 : 
 :)
declare
  %rest:path('/list-users')
  %rest:query-param('status', '{$status}')
  %output:method('html')
function synopsx.users:list-user(
  $status  as xs:string?
) {
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content := map {
    'status' : $status
  }
  let $outputParams := map { }
  let $layout := map {
    'layout' : $G:HOME || 'templates/html.xhtml'
  }
  return synopsx.mappings.htmlUsers:list-user($content, $outputParams, $layout)
};

(:~
 : Creates a new user and redirects to a list of users.
 : @param $name user name
 :)
declare
  %rest:path('/create-user/apply')
  %rest:form-param('name', '{$name}')
  %updating
function synopsx.users:create-user-apply(
  $name  as xs:string
) {
  let $users := db:open('users')/users
  let $exists := $users/user/@name = $name
  return (
    if($exists) then () else
      let $user := <user name='{ $name }'/>
      return insert node $user into db:open('users')/users,
    db:output(
      <rest:redirect>/list-users?status={
        if($exists) then $G:USER-EXISTS else $G:OK
      }</rest:redirect>)
  )
};

(:~
 : Deletes a user.
 : @param $name user name
 :)
declare
  %rest:path('/delete-user/apply')
  %rest:query-param('name', '{$name}')
  %updating
function synopsx.users:delete-user-apply(
  $name  as xs:string
) {
  let $users := db:open('users')/users
  let $user := $users/user[@name = $name]
  return (
    delete node $user,
    db:output(
      <rest:redirect>/list-users?status={
        if($user) then $G:OK else $G:USER-UNKNOWN
      }</rest:redirect>
    )
  )
};