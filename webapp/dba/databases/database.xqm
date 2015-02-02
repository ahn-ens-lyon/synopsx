(:~
 : Database main page.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace G = 'dba/global' at '../modules/global.xqm';
import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'databases';
(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Manage single database.
 : @param  $name      database
 : @param  $resource  resource
 : @param  $error     error string
 : @param  $info      info string
 :)
declare
  %rest:GET
  %rest:path("dba/database")
  %rest:query-param("name",     "{$name}")
  %rest:query-param("backup",   "{$backup}")
  %rest:query-param("resource", "{$resource}")
  %rest:query-param("error",    "{$error}")
  %rest:query-param("info",     "{$info}")
  %output:method("html")
function _:database(
  $name      as xs:string,
  $backup    as xs:string?,
  $resource  as xs:string?,
  $error     as xs:string?,
  $info      as xs:string?
) as element() {
  web:check(),
  if($backup) then web:redirect('download-backup/' || encode-for-uri($backup) || '.zip') else

  let $found := web:eval('db:exists($n)', map { 'n': $name })
  return tmpl:wrap(map { 'top': $_:CAT, 'info': $info, 'error': $error }, (
    <td width='500'>{
      <form action="{ $_:SUB }" method="post" id="{ $_:SUB }" class="update">
        <input type="hidden" name="name" value="{ $name }" id="name"/>
        <h2><a href="{ $_:CAT }">Databases</a> » {
          $name ! (if(empty($resource)) then . else web:link(., $_:SUB, map { 'name': $name } ))
        }</h2>
        {
          if(not($found)) then () else (
            let $entries := if($found) then
              web:eval('db:list-details($n)', map { 'n': $name }) !
                <e resource='{ . }' ct='{ @content-type }' raw='{
                  if(@raw = 'true') then '✓' else '–'
                }'/> else ()
            let $headers := (
              <resource>{ html:label($entries, ('Resource', 'Resources')) }</resource>,
              <ct>Content type</ct>,
              <raw>Raw</raw>
            )
            let $buttons := (
              html:button('add', 'Add…'),
              html:button('delete', 'Delete', true()),
              html:button('copy', 'Copy…', false()),
              html:button('alter', 'Rename…', false()),
              html:button('optimize', 'Optimize…', false(), 'global')
            )
            return html:table($entries, $headers, $buttons, $_:SUB, map { 'name': $name }, (), true())
          )
        }
      </form>,
      <form action="{ $_:SUB }" method="post" class="update">
        <input type="hidden" name="name" value="{ $name }"/>
        <h3>Backups</h3>
        {
          let $entries :=
            for $b in web:eval('db:backups($n)', map { 'n': $name })
            order by $b descending
            return <e backup='{ $b }' size='{ $b/@size }'/>
          let $headers := (
            <backup order='desc'>{ html:label($entries, ('Backup', 'Backups')) }</backup>,
            <size type='bytes'>Size</size>
          )
          let $buttons := (
            html:button('create-backup', 'Create', false(), 'global') update (
              if($found) then () else insert node attribute disabled { '' } into .
            ),
            html:button('restore', 'Restore', true()),
            html:button('drop-backup', 'Drop', true())
          )
          return html:table($entries, $headers, $buttons, $_:SUB, map { 'name': $name }, (), true())
        }
      </form>
    }</td>,
    <td class='vertical'/>,
    <td>{
      if($resource) then <_>
        <h3>Resources » { $resource }</h3>
        <form action="resource" method="post" id="resources" enctype="multipart/form-data">
          <input type="hidden" name="name" value="{ $name }"/>
          <input type="hidden" name="resource" value="{ $resource }" id="resource"/>
          { html:button('rename', 'Rename…') }
          { html:button('download', 'Download') }
          { html:button('replace', 'Replace…') }
        </form>
        <b>XQuery:</b>
        <input style="width:100%" autocomplete="off" name="xquery" id="xquery"
          onkeyup='xpath("Please wait…", "Query was successful.")'/>
        { web:focus('xquery') }
        <textarea name='output' id='output' rows='20' readonly='' spellcheck='false'/>
        <script type="text/javascript">(function(){{ xpath('', ''); }})();</script>
      </_>/node() else (
        $found[.] ! html:properties(web:eval('db:info($n)', map { 'n': $name }))
      )
    }</td>
  ))
};

(:~
 : Performs actions on a single database.
 : @param  $action     action to perform
 : @param  $name       database
 : @param  $resources  resources
 : @param  $backups    backups
 :)
declare
  %rest:POST
  %rest:path("dba/database")
  %rest:form-param("action",   "{$action}")
  %rest:form-param("name",     "{$name}")
  %rest:form-param("resource", "{$resources}")
  %rest:form-param("backup",   "{$backups}")
function _:action(
  $action     as xs:string,
  $name       as xs:string,
  $resources  as xs:string*,
  $backups    as xs:string*
) as element() {
  web:redirect($action, map { 'name': $name, 'resource': $resources, 'backup': $backups })
};
