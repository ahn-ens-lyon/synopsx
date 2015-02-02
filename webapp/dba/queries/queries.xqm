(:~
 : Queries page.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/queries';

import module namespace G = 'dba/global' at '../modules/global.xqm';
import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'queries';

(:~
 : Queries page.
 : @param  $query     input query
 : @param  $realtime  realtime execution
 : @param  $error     error string
 : @param  $info      info string
 :)
declare
  %rest:GET
  %rest:path("dba/queries")
  %rest:query-param("query",     "{$query}")
  %rest:query-param("realtime",  "{$realtime}")
  %rest:query-param("error",     "{$error}")
  %rest:query-param("info",      "{$info}")
  %output:method("html")
function _:queries(
  $query     as xs:string?,
  $realtime  as xs:string?,
  $error     as xs:string?,
  $info      as xs:string?
) as element() {
  web:check(),

  let $f := function($b) { "xquery('Please wait…', 'Query was successful.', " || $b || ");" }
  return tmpl:wrap(map { 'top': $_:CAT, 'info': $info, 'error': $error }, (
    <td width='50%'>{
      <h2>XQuery</h2>,
      <textarea id='xquery' rows='20' spellcheck='false' onkeyup="{ $f(false()) }">{ $query }</textarea>,
      web:focus('xquery'),
      <button id='run' onclick="{ $f(true()) }">Run</button>,
      <input type='checkbox' checked='' id='realtime' onclick="{ $f(false()) }"/> update (
        if($realtime) then () else delete node @checked
      ),
      'Realtime Execution'
    }</td>,
    <td width='50%'>
      <h2>Result</h2>
      <textarea id='output' rows='20' readonly='' spellcheck='false'/>
    </td>
  ))
};

(:~
 : Returns the result of a query.
 : @param  $query    query
 :)
declare
  %rest:POST
  %rest:path("dba/queries")
  %rest:query-param("query", "{$query}")
  %output:method("text")
function _:query(
  $query  as xs:string?
) {
  web:check(),
  let $limit := $G:MAX-CHARS
  let $query := if($query) then $query else '()'
  return web:eval("serialize(
  xquery:update(
    $query,
    map { },
    map { 'timeout':" || $G:TIMEOUT || ",'memory':" || $G:MEMORY || ",'permission':'" ||
      $G:PERMISSION || "' }
  ),
  map { 'limit': $limit * 2 }
) ! replace(., '&#xd;', '')
  ! (if(string-length(.) > $limit) then substring(., 1, $limit) || '...' else .)",
    map { 'query': $query, 'limit': $limit }
  )
};
