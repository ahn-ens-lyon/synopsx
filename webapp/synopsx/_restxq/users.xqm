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

module namespace users = 'http://ahn.ens-lyon.fr/users';

import module namespace webapp = 'http://ahn.ens-lyon.fr/webapp' at 'webapp.xqm';
import module namespace Session = "http://basex.org/modules/session";


import module namespace synopsx.models.tei = 'synopsx.models.tei';
import module namespace synopsx.views.htmlUsers = 'synopsx.views.htmlUsers';
import module namespace G = "synopsx/globals";



declare
  %rest:path('/create-user')
  %output:method('html')
function users:create-user() {
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content := map {
    'title' := synopsx.models.tei:title(),
    'items' := ()
  }
  let $options := map { }
  let $layout := map {
    'layout' := $webapp:layout
  }
  return synopsx.views.htmlUsers:create-user($content, $options, $layout)
};

declare
  %rest:path('/list-users')
  %rest:query-param('status', '{$status}')
  %output:method('html')
function users:list-user(
  $status  as xs:string?
) {
  let $format as xs:string := 'html' (: par défaut on produit du html:)
  let $content := map {
    'status' := $status
  }
  let $options := map { }
  let $layout := map {
    'layout' := $webapp:layout
  }
  return synopsx.views.htmlUsers:list-user($content, $options, $layout)
};

(:~
 : Creates a new user and redirects to a list of users.
 : @param $name user name
 :)
declare
  %rest:path('/create-user/apply')
  %rest:form-param('name', '{$name}')
  %updating
function users:create-user-apply(
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
function users:delete-user-apply(
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