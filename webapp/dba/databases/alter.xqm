(:~
 : Alter database.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web'  at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'databases';
(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Form for altering a database.
 : @param  $name     database
 : @param  $newname  new name
 : @param  $error    error string
 :)
declare
  %rest:GET
  %rest:path("dba/alter")
  %rest:query-param("name",    "{$name}")
  %rest:query-param("newname", "{$newname}")
  %rest:query-param("error",   "{$error}")
  %output:method("html")
function _:alter(
  $name     as xs:string,
  $newname  as xs:string?,
  $error    as xs:string?
) as element() {
  web:check(),
  tmpl:wrap(map { 'top': $_:SUB, 'error': $error },
    <td>
      <form action="alter" method="post">
        <input type="hidden" name="name" value="{ $name }"/>
        <h2>
          <a href="{ $_:CAT }">Databases</a> »
          { web:link($name, $_:SUB, map { 'name': $name } ) } »
          { html:button('alter', 'Rename') }
        </h2>
        <table>
          <tr>
            <td>New name:</td>
            <td>
              <input autocomplete="off" type="text" name="newname"
                value="{ ($newname, $name)[1] }" id="newname"/>
              { web:focus('newname') }
              <div class='small'/>
            </td>
          </tr>
        </table>
      </form>
    </td>
  )
};

(:~
 : Copies a database.
 : @param  $name     database
 : @param  $newname  new name
 :)
declare
  %rest:POST
  %rest:path("dba/alter")
  %rest:query-param("name",    "{$name}")
  %rest:query-param("newname", "{$newname}")
function _:alter(
  $name     as xs:string,
  $newname  as xs:string
) {
  web:check(),
  try {
    web:eval("db:alter($n, $m)", map { 'n': $name, 'm': $newname }),
    web:redirect($_:SUB, map { 'info': 'Database was renamed.', 'name': $newname })
  } catch * {
    web:redirect("alter", map { 'error': $err:description, 'name': $name, 'newname': $newname })
  }
};
