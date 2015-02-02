(:~
 : Web functions.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace web = 'dba/web';

import module namespace Request = 'http://exquery.org/ns/request';
import module namespace G = 'dba/global' at 'global.xqm';

(:~
 : <p>Creates a URL representation for the specified URI path
 : and query parameters. All parameters will be URI-encoded
 : and appended to the link. Map entries with empty string values
 : will be ignored.</p>
 : <p>An example:
 :   <code>{ 'a':'foo', 'b':'bar' } -> ?a=foo&amp;b=bar</code>.
 : </p>
 : @param  $link    the target page
 : @param  $params  the parameters to add
 : @return url
 :)
declare function web:url(
  $link    as xs:string,
  $params  as map(*)
) as xs:string? {
  $link || string-join(
    for $k in map:keys($params) ! string()
    for $v in distinct-values($params($k))
    count $c
    return (
      if($c = 1) then '?' else '&amp;',
      encode-for-uri($k) || '=' || encode-for-uri(xs:string($v))
    )
  )
};

(:~
 : Returns all query parameters in a map.
 : @return query parameters
 :)
declare function web:query-params(
) as map(*) {
  map:new(
    for $param in tokenize(Request:query(), '&amp;')
    let $values := substring-after($param, '=')
    group by $key := substring-before($param, '=')
    return map { $key := $values }
  )
};

(:~
 : Returns the mime-type for the specified file.
 : @param  $file  file name
 : @return mime type
 :)
declare function web:mime-type(
  $name  as xs:string
) as xs:string {
  Q{java:org.basex.io.MimeTypes}get($name)
};

(:~
 : Creates a link to the specified target.
 : @param  $text    link text
 : @param  $target  target
 : @return link
 :)
declare function web:link(
  $text    as xs:string,
  $target  as xs:string)
  as element(a)
{
  <a href="{ $target }">{ $text }</a>
};

(:~
 : Creates a link to the specified target.
 : @param  $text    link text
 : @param  $target  target
 : @param  $params  map with query parameters
 : @return link
 :)
declare function web:link(
  $text    as xs:string,
  $target  as xs:string,
  $params    as map(*))
  as element(a)
{
  web:link($text, web:url($target, $params))
};

(:~
 : Creates a RESTXQ (HTTP) redirect header for the specified link.
 : @param  $location  page to forward to
 : @return redirect header
 :)
declare function web:redirect(
  $location  as xs:string)
  as element(rest:redirect)
{
  <rest:redirect>{ $location }</rest:redirect>
};

(:~
 : Creates a RESTXQ (HTTP) redirect header for the specified link and parameters.
 : @param  $redirect  page to forward to
 : @param  $params    map with query parameters
 : @return redirect header
 :)
declare function web:redirect(
  $redirect  as xs:string,
  $params    as map(*))
  as element(rest:redirect)
{
  web:redirect(web:url($redirect, $params))
};

(:~
 : Focuses the specified field via Javascript.
 : @param $element element to be focused
 :)
declare function web:focus(
  $element  as xs:string
) {
  <script type="text/javascript">
    (function(){{ var u = document.getElementById('{ $element }'); u.focus(); u.select(); }})();
  </script>
};

(:~
 : Checks if the current client is logged in. If not, raises an error.
 :)
declare function web:check()
{
  if($G:SESSION) then () else error($G:LOGIN-ERROR, 'Please log in again.')
};

(:~
 : Evaluates the specified query locally or on a remote server and returns the results.
 : @param  $query  query to be executed
 : @return result
 :)
declare function web:eval(
  $query as xs:string
) as item()* {
  web:eval($query, map {})
};

(:~
 : Evaluates the specified query locally or on a remote server and returns the results.
 : @param  $query  query to be executed
 : @param  $vars   variables
 : @return result
 :)
declare function web:eval(
  $query as xs:string,
  $vars  as map(*)
) as item()* {
  (: prof:dump($query, "QUERY: "),
  if(map:size($vars) = 0) then () else (
    prof:dump(
      for $key in map:keys($vars)
      let $vals := $vars($key) ! string() ! (if(string-length(.) > 64) then
        substring(., 1, 64) || '...' else .)
      return '$' || $key || ' := ' || string-join($vals, ', '), " ")
  ),
  prof:dump(""), :)

  let $query := string-join((map:keys($vars) ! ('declare variable $' || . || ' external;'), $query))
  return if($G:REMOTE) then (
    let $xml := parse-xml($G:REMOTE)/*
    let $id := client:connect($xml/host, $xml/port, $xml/name, $xml/pass)
    let $r := client:query($id, $query, $vars)
    return (client:close($id), $r)
  ) else (
    xquery:update($query, $vars)
  )
};
