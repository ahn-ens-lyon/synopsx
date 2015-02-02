(:~
 : Restore a backup.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace web = 'dba/web' at '../../modules/web.xqm';

(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Restores a database backup.
 : @param  $name    database
 : @param  $backup  backup file
 :)
declare
  %rest:GET
  %rest:path("dba/restore")
  %rest:query-param("name",   "{$name}")
  %rest:query-param("backup", "{$backup}")
  %output:method("html")
function _:restore(
  $name    as xs:string,
  $backup  as xs:string
) {
  web:check(),
  try {
    web:eval("db:restore($b)", map { 'b': $backup }),
    web:redirect($_:SUB, map { 'name': $name, 'info': 'Database was restored.' })
  } catch * {
    web:redirect($_:SUB, map { 'name': $name, 'error': $err:description })
  }
};
