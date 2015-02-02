(:~
 : Drops backups.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace web = 'dba/web' at '../../modules/web.xqm';

(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Drops a database backup.
 : @param  $name    database
 : @param  $backups  backup files
 :)
declare
  %rest:GET
  %rest:path("dba/drop-backup")
  %rest:query-param("name",   "{$name}")
  %rest:query-param("backup", "{$backups}")
  %output:method("html")
function _:drop-backup(
  $name     as xs:string,
  $backups  as xs:string*
) {
  try {
    web:eval("$b ! db:drop-backup(.)", map { 'b': $backups }),
    web:redirect($_:SUB, map { 'name': $name, 'info': 'Backups were dropped.' })
  } catch * {
    web:redirect($_:SUB, map { 'name': $name, 'error': $err:description })
  }
};
