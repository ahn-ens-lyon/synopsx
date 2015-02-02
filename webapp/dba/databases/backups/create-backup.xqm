(:~
 : Create backups.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace web = 'dba/web' at '../../modules/web.xqm';

(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Creates a database backup.
 : @param  $name  database
 :)
declare
  %rest:GET
  %rest:path("dba/create-backup")
  %rest:query-param("name", "{$name}")
  %output:method("html")
function _:create-backup(
  $name  as xs:string
) {
  web:check(),
  try {
    web:eval("db:create-backup($n)", map { 'n': $name }),
    web:redirect($_:SUB, map { 'name': $name, 'info': 'Backup was created.' })
  } catch * {
    web:redirect($_:SUB, map { 'name': $name, 'error': $err:description })
  }
};
