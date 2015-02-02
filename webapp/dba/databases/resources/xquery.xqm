(:~
 : Query resources.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace G = 'dba/global' at '../../modules/global.xqm';
import module namespace web = 'dba/web' at '../../modules/web.xqm';

(:~
 : Runs a query on a document and returns the result.
 : @param  $name      database
 : @param  $resource  resource
 : @param  $query     query
 :)
declare
  %rest:POST
  %rest:path("dba/xquery")
  %rest:query-param("name",     "{$name}")
  %rest:query-param("resource", "{$resource}")
  %rest:query-param("query",    "{$query}")
  %output:method("text")
function _:query(
  $name      as xs:string,
  $resource  as xs:string,
  $query     as xs:string
) as xs:string {
  web:check(),
  let $limit := $G:MAX-CHARS
  let $query := if($query) then $query else '.'
  return web:eval("serialize(
  xquery:update(
    $query,
    map { '': db:open($name, $resource) },
    map { 'timeout':" || $G:TIMEOUT || ",'memory':" || $G:MEMORY || ",'permission':'none' }
  ),
  map { 'limit': $limit * 2 }
) ! replace(., '&#xd;', '')
  ! (if(string-length(.) > $limit) then substring(., 1, $limit) || '...' else .)",
    map { 'query': $query, 'name': $name, 'resource': $resource, 'limit': $limit }
  )
};
