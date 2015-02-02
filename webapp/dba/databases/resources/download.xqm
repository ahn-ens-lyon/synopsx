(:~
 : Download resources.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace web = 'dba/web' at '../../modules/web.xqm';

(:~
 : Downloads a document.
 : @param  $name      database
 : @param  $resource  resource
 :)
declare
  %rest:path("dba/download/{$file}")
  %output:media-type("application/octet-stream")
  %output:method("xml")
  %rest:query-param("name", "{$name}")
  %rest:query-param("resource", "{$resource}")
function _:download(
  $name      as xs:string,
  $resource  as xs:string,
  $file      as xs:string
) {
  web:check(),
  let $options := map { 'n': $name, 'r': $resource }
  let $raw := web:eval("db:is-raw($n, $r)", $options)
  return (
    <rest:response>
      <output:serialization-parameters>
        <output:method value='{ if($raw) then "raw" else "xml" }'/>
        <output:media-type value='{ web:eval("db:content-type($n, $r)", $options) }'/>
      </output:serialization-parameters>
    </rest:response>,
    web:eval(if($raw) then "db:retrieve($n, $r)" else "db:open($n, $r)", $options)
  )
};

(:~
 : Downloads a database backup.
 : @param  $backup  name of backup
 :)
declare
  %rest:path("dba/download-backup/{$backup}")
  %output:method("raw")
  %output:media-type("application/octet-stream")
function _:download(
  $backup  as xs:string
) {
  web:check(),
  file:read-binary(db:system()/globaloptions/dbpath || '/' || $backup)
};
