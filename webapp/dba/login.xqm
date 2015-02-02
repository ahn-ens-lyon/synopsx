(:~
 : Logging in and out.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace _ = 'dba/login';

import module namespace Session = 'http://basex.org/modules/session';
import module namespace G = 'dba/global' at 'modules/global.xqm';
import module namespace html = 'dba/html' at 'modules/html.xqm';
import module namespace tmpl = 'dba/tmpl' at 'modules/tmpl.xqm';
import module namespace web = 'dba/web' at 'modules/web.xqm';

(:~
 : Login page.
 : @param  $name   user name
 : @param  $url    url
 : @param  $error  error code
 : @return login page
 :)
declare
  %rest:path("dba/login")
  %rest:query-param("name" , "{$name}")
  %rest:query-param("url",   "{$url}")
  %rest:query-param("error", "{$error}")
  %output:method("html")
function _:login(
  $name   as xs:string?,
  $url    as xs:string?,
  $error  as xs:string?
) {
  tmpl:wrap(map { 'error': $error },
    <td>
      <form action="login-check" method="post">
        <table>
          <tr>
            <td><b>Name:</b></td>
            <td>
              <input size="40" name="name" value="{ $name }" id="user"/>
              { web:focus('user') }
              { html:button('login', 'Login') }
            </td>
          </tr>
          <tr>
            <td><b>Password:</b></td>
            <td>
              <input size="40" type="password" name="pass"/>
            </td>
          </tr>
          <tr>
            <td><b>Address:</b></td>
            <td>
              <input size="40" name="url" value="{ $url }"/> (optional)
            </td>
          </tr>
          <tr>
            <td/>
            <td>Syntax: <code>host:port</code></td>
          </tr>
        </table>
      </form>
    </td>
  )
};

(:~
 : Check user credentials and redirect to start or login page.
 : @param  $name  user name
 : @param  $url   url
 : @param  $pass  password
 :)
declare
  %rest:path("dba/login-check")
  %rest:query-param("name", "{$name}")
  %rest:query-param("pass", "{$pass}")
  %rest:query-param("url",  "{$url}")
function _:check(
  $name  as xs:string,
  $pass  as xs:string,
  $url   as xs:string
) {
  if($url) then (
    if(matches($url, '^.+:\d+/?$')) then (
      let $host := replace($url, ':.*$', '')
      let $port := replace($url, '^.*:|/$', '')
      return try {
        client:close(client:connect($host, xs:integer($port), $name, $pass)),
        Session:set($G:SESSION-KEY, $name),
        Session:set($G:SESSION-REMOTE, serialize(
          <remote>
            <host>{ $host }</host>
            <port>{ $port }</port>
            <name>{ $name }</name>
            <pass>{ $pass }</pass>
          </remote>
        )),
        web:redirect('databases')
      } catch * {
        web:redirect('login', map { 'name': $name, 'url': $url, 'error': $err:description })
      }
    ) else (
      web:redirect('login', map { 'name': $name, 'url': $url,
        'error': 'Please check the syntax of your URL.' })
    )
  ) else (
    let $user := doc($G:CONFIG-XML)/config/user[name = $name]
    let $salt-pw := substring-after($user/password, '$5$')
    let $salt := substring-before($salt-pw, '$')
    let $pw := substring-after($salt-pw, '$')
    return if($user and xs:base64Binary($pw) = hash:sha256($salt || $pass)) then (
      Session:set($G:SESSION-KEY, $name),
      web:redirect('databases')
    ) else (
      web:redirect('login', map { 'name': $name, 'error': 'Please check your login data.' })
    )
  )
};

(:~
 : End session and return to login page.
 :)
declare
  %rest:path("dba/logout")
function _:logout(
) {
  Session:close(),
  web:redirect('databases')
};
