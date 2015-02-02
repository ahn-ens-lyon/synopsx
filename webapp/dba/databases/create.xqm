(:~
 : Create new database.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/databases';

import module namespace html = 'dba/html' at '../modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at '../modules/tmpl.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(:~ Top category :)
declare variable $_:CAT := 'databases';
(:~ Sub category :)
declare variable $_:SUB := 'database';

(:~
 : Form for creating a new database.
 : @param  $name   entered name
 : @param  $opts   database options
 : @param  $lang   language
 : @param  $error  error string
 :)
declare
  %rest:GET
  %rest:path("dba/create")
  %rest:query-param("name",  "{$name}")
  %rest:query-param("opts",  "{$opts}", "textindex", "attrindex")
  %rest:query-param("lang",  "{$lang}", "en")
  %rest:query-param("error", "{$error}")
  %output:method("html")
function _:create(
  $name   as xs:string?,
  $opts   as xs:string*,
  $lang   as xs:string?,
  $error  as xs:string?
) as element() {
  web:check(),
  tmpl:wrap(map { 'top': $_:CAT, 'error': $error },
    <td>
      <form action="create" method="post">
        <h2>
          <a href="{ $_:CAT }">Databases</a> »
          { html:button('create', 'Create') }
        </h2>
        <!-- dummy value; prevents reset of options when nothing is selected -->
        <input type="hidden" name="opts" value="x"/>
        <table>
          <tr>
            <td>Name:</td>
            <td>
              <input autocomplete="off" type="text" name="name" value="{ $name }" id="name"/>
              { web:focus('name') }
              <div class='small'/>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <h3>{ "textindex" ! html:checkbox("opts", ., $opts = ., 'Text Index') }</h3>
              <h3>{ "attrindex" ! html:checkbox("opts", ., $opts = ., 'Attribute Index') }</h3>
              { "updindex" ! html:checkbox("opts", ., $opts = ., 'Incremental Indexing') }<br/>
              <div class='small'/>
              <h3>{ "ftindex" ! html:checkbox("opts", ., $opts = ., 'Fulltext Index') }</h3>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              { "stemming" ! html:checkbox("opts", ., $opts = ., 'Stemming') }<br/>
              { "casesens" ! html:checkbox("opts", ., $opts = ., 'Case Sensitivity') }<br/>
              { "diacritics" ! html:checkbox("opts", ., $opts = ., 'Diacritics') }<br/>
            </td>
          </tr>
          <tr>
            <td>Language:</td>
            <td><input type="text" name="language" value="{ $lang }"/></td>
          </tr>
        </table>
      </form>
    </td>
  )
};

(:~
 : Creates a database.
 : @param  $name  database
 : @param  $opts  database options
 : @param  $lang  language
 :)
declare
  %rest:POST
  %rest:path("dba/create")
  %rest:query-param("name", "{$name}")
  %rest:query-param("opts", "{$opts}")
  %rest:query-param("lang", "{$lang}")
function _:create(
  $name  as xs:string,
  $opts  as xs:string*,
  $lang  as xs:string?
) {
  web:check(),
  try {
    if(web:eval('db:exists($n)', map { 'n' : $name })) then (
      error((), 'Database already exists: ' || $name)
      ) else (
      web:eval("db:create($name, (), (), map:new((
  (('textindex','attrindex','ftindex','stemming','casesens','diacritics','updindex') !
    map:entry(., $opts = .)),
    $lang ! map:entry('language', .)
  )
))",
        map { 'name': $name, 'lang': $lang, 'opts': $opts }
      ),
      web:redirect($_:SUB, map { 'info': 'Created Database: ' || $name, 'name': $name })
    )
  } catch * {
    web:redirect("create", map { 'error': $err:description, 'name': $name, 'opts': $opts,
      'lang': $lang })
  }
};
