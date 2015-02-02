(:~
 : Utility services.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/util';

import module namespace Request = 'http://exquery.org/ns/request';
import module namespace tmpl = 'dba/tmpl' at 'modules/tmpl.xqm';
import module namespace web = 'dba/web' at 'modules/web.xqm';

(:~ Redirection to start page. :)
declare
  %rest:path("dba")
function _:redirect(
) {
  web:redirect('/dba/databases')
};

(:~
 : Return media file.
 : @param $file file or unknown path
 :)
declare
  %rest:path("dba/media/{$file}")
function _:file(
  $file as xs:string
) {
  let $path := file:parent(static-base-uri()) || 'media/' || $file
  let $xq := some $x in ('.xq', '.xqm') satisfies ends-with($file, $x)
  return (
    <rest:response>
      <http:response>
        <http:header name="Cache-Control" value="max-age=3600,public"/>
      </http:response>
      <output:serialization-parameters>
        <output:media-type value='{ web:mime-type($file) }'/>
        <output:method value='raw'/>
      </output:serialization-parameters>
    </rest:response>,
    file:read-binary($path)
  )
};


(:~
 : Show page not found error.
 : @param $unknown  unknown page
 :)
declare
  %rest:path("dba/{$unknown}")
  %output:method("html")
function _:any(
  $unknown  as xs:string
) {
  web:check(),
  tmpl:wrap(
    <td>
      <h3>Page not found!</h3>
      <ul>
        <li>Page: <code>dba/{ $unknown }</code></li>
        <li>Method: <code>{ Request:method() }</code></li>
      </ul>
    </td>
  )
};

(:~
 : Login error: redirect to login page.
 :)
declare
  %rest:error("basex:login")
function _:error-login(
) {
  web:redirect("login")
};
