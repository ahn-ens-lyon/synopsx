(:~
 : Logging page.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/logs';

import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'logs';

(:~
 : Logging page.
 : @param  $sort     table sort key
 : @param  $name     name (date) of log file
 : @param  $loglist  search term for log list
 : @param  $logs     search term for logs
 : @param  $error    error string
 : @param  $info     info string
 :)
declare
  %rest:GET
  %rest:path("dba/logs")
  %rest:query-param("sort",    "{$sort}", "")
  %rest:query-param("name",    "{$name}")
  %rest:query-param("loglist", "{$loglist}")
  %rest:query-param("logs",    "{$logs}")
  %rest:query-param("error",   "{$error}")
  %rest:query-param("info",    "{$info}")
  %output:method("html")
function _:logs(
  $sort     as xs:string,
  $name     as xs:string?,
  $loglist  as xs:string?,
  $logs     as xs:string?,
  $error    as xs:string?,
  $info     as xs:string?
) as element() {
  web:check(),

  tmpl:wrap(map { 'top': $_:CAT, 'info': $info, 'error': $error }, (
    <td width='230'>
      <input type='hidden' name='name' id='name' value='{ $name }'/>
      <input type='hidden' name='sort' id='sort' value='{ $sort }'/>
      <form action="{ $_:CAT }" method="post" class="update">
        <h2>{ if($name) then <a href="{ $_:CAT }">Logs</a> else 'Logs' } »
          <input size="14" autocomplete="off" name="loglist" id="loglist" value="{ $loglist }"
            onkeyup="logslist('Please wait…', 'Query was successful.');"/>
        </h2>
        <div id='list'>{ _:loglist($sort, $loglist) }</div>
      </form>
    </td>,
    <td class='vertical'/>[$name],
    <td>{
      if($name) then (
        <h3>
          Log Entries » { $name } »
          <input size="40" autocomplete="off" id="logs" value="{ ($loglist, $logs)[1] }"
            onkeyup="logentries('Please wait…', 'Query was successful.');"/>
        </h3>,
        <div id='output'/>,
        <script type="text/javascript">(function(){{ logentries('', ''); }})();</script>
      ) else (),
      web:focus(if($name) then 'logs' else 'loglist')
    }</td>
  ))
};

(:~
 : Returns log data.
 : @param  $name     database
 : @param  $sort     table sort key
 : @param  $loglist  loglist
 : @param  $query    query
 :)
declare
  %rest:POST
  %rest:path("dba/logs")
  %rest:query-param("name",    "{$name}")
  %rest:query-param("sort",    "{$sort}")
  %rest:query-param("loglist", "{$loglist}")
  %rest:query-param("query",   "{$query}")
  %output:method("html")
function _:query(
  $name     as xs:string,
  $sort     as xs:string?,
  $query    as xs:string?,
  $loglist  as xs:string?
) {
  let $entries :=
    for $a in try {
      web:eval("admin:logs($n, true())[matches(., $q, 'i')]", map { 'n': $name, 'q': $query })
    } catch * {
      (: legacy (7.8.1) :)
      web:eval("admin:logs($n)[contains(., $q, 'i')]", map { 'n': $name, 'q': $query })
    }
    return <e t='{ $a/@time }' a='{ $a/@address }' u='{ $a/@user}' p='{ $a/@type }'
              m='{ $a/@ms }' d='{ $a }'/>
  let $headers := (
    <t type='time' order='desc'>Time</t>,
    <a>Address</a>,
    <u>User</u>,
    <p>Type</p>,
    <m type='decimal' order='desc'>ms</m>,
    <d>{ html:label($entries, ('Log Entry', 'Log Entries')) }</d>
  )
  return html:table($entries, $headers, (), $_:CAT,
    map { 'name': $name, 'loglist': $loglist, 'logs': $query }, $sort)
};

(:~
 : Returns log data.
 : @param  $sort   table sort key
 : @param  $query  query
 :)
declare
  %rest:POST
  %rest:path("dba/loglist")
  %rest:query-param("sort",  "{$sort}")
  %rest:query-param("query", "{$query}")
  %output:method("html")
function _:loglist(
  $sort   as xs:string?,
  $query  as xs:string?
) {
  let $entries :=
    (: legacy (7.8.1): $a/@date :)
    for $a in web:eval("for $a in admin:logs()
let $n := $a/(@date,text())/string()
where not($query) or (some $a in admin:logs($n) satisfies matches($a, $query, 'i'))
order by $n descending
return $a
    ", map { 'query': $query })
    order by $a descending
    (: legacy (7.8.1): $a/@date :)
    return <e name='{ ($a/@date, $a/text()) }' size='{ $a/@size }'/>
  let $headers := (
    <name>{ html:label($entries, ('Log', 'Logs')) }</name>,
    <size type='bytes'>Size</size>
  )
  let $buttons := (
    html:button('delete-log', 'Delete', true())
  )
  return html:table($entries, $headers, $buttons, $_:CAT,
    map { 'sort': $sort, 'loglist': $query }, (), true())
};
