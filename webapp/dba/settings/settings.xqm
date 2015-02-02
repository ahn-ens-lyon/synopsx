(:~
 : Queries page.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/settings';

import module namespace G = 'dba/global' at '../modules/global.xqm';
import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'settings';

(:~
 : Settings page.
 :)
declare
  %rest:GET
  %rest:path("dba/settings")
  %output:method("html")
function _:settings(
) as element() {
  web:check(),

  tmpl:wrap(map { 'top': $_:CAT }, (
    <td width='50%'>
      <form action="settings" method="get">
        <h2>Settings » <button>Save</button></h2>
        <table>
          <tr>
            <td colspan='2'><h3>Querying</h3></td>
          </tr>
          <tr>
            <td><b>MAXCHARS:</b></td>
            <td><input name="maxchars" type="number" value="{ $G:MAX-CHARS }"
              title="Maximum number of characters in the query result pane."/></td>
          </tr>
          <tr>
            <td><b>MAXROWS:</b></td>
            <td><input name="maxrows" type="number" value="{ $G:MAX-ROWS }"
              title="Maximum number of displayed table rows."/></td>
          </tr>
          <tr>
            <td><b>TIMEOUT:</b></td>
            <td><input name="timeout" type="number" value="{ $G:TIMEOUT }"
              title="Query timeout."/></td>
          </tr>
          <tr>
            <td><b>PERMISSION:</b></td>
            <td>
              <select name="permission" title="Permission for running queries.">{
                for $p in ('none', 'read', 'write', 'create', 'admin')
                return element option { attribute selected { }[$p = $G:PERMISSION], $p }
              }</select>
            </td>
          </tr>
          <tr>
            <td colspan='2'><h3>User Profile</h3></td>
          </tr>
          <tr>
            <td><b>NAME:</b></td>
            <td>{ $G:SESSION }</td>
          </tr>
          <tr>
            <td><b>PASSWORD:</b></td>
            <td><input name="password" type="password"
              title="Will be updated if non-empty."/></td>
          </tr>
        </table>
      </form>
    </td>
  ))
};

(:~
 : Save settings.
 :)
declare
  %rest:POST
  %rest:path("dba/settings")
  %output:method("html")
function _:settings-save(
) as element() {
  web:check(),
  
  let $param := web:query-params()
  let $config := doc($G:CONFIG-XML)/config update (
    let $user := user[name = $G:SESSION]
    for $key in map:keys($param)
    let $value := $param($key)
    return (
      (: delete old config, add new one if it differs from global setting :)
      delete node $user/*[name() = $key],
      let $default := default/*[name() = $key]
      where $default != $value
      return insert node element { $key } { $value} into $user
    )
  )
  return (
    file:write($G:CONFIG-XML, $config),
    web:redirect("settings")
  )
};
