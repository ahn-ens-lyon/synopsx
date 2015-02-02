(:~
 : Users page.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/users';

import module namespace G = 'dba/global' at '../modules/global.xqm';
import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'users';

(:~
 : Users page.
 : @param  $sort  table sort key
 :)
declare
  %rest:GET
  %rest:path("dba/users")
  %rest:query-param("sort", "{$sort}", "")
  %output:method("html")
function _:users(
  $sort  as xs:string
) as element() {
  web:check(),
  tmpl:wrap(map { 'top': $_:CAT },
    <td>
      <form action="{ $_:CAT }" method="post" class="update">
      <h2>Users</h2>
      {
        let $entries := web:eval('admin:users()') ! <e name='{ text() }' perm='{ @permission }'/>
        let $headers := (
          <name>{ html:label($entries, ('User', 'Users')) }</name>,
          <perm>Permission</perm>
        )
        let $buttons := (
          html:button('add', 'Add…'),
          html:button('drop', 'Drop', true())
        )
        return html:table($entries, $headers, $buttons, $_:CAT, map { }, $sort)
      }
      <div>&#xa0;</div>
      <h2>Sessions</h2>
      {
        let $entries := web:eval('admin:sessions()') ! <e addr='{ @address }' user='{ @user }'/>
        let $headers := (
          <addr>{ html:label($entries, ('Session', 'Sessions')) }</addr>,
          <user>Address</user>
        )
        let $buttons := (
          html:button('kill', 'Kill', true())
        )
        return html:table($entries, $headers, $buttons, $_:CAT)
      }
      </form>
    </td>
  )
};
