(:~
 : Template functions.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace tmpl = 'dba/tmpl';

import module namespace web = 'dba/web' at 'web.xqm';

(:~
 : Wraps the specified content in the page template.
 : @param  $td  td elements
 : @return HTML page
 :)
declare function tmpl:wrap(
  $td       as element(td)+
) as element() {
  tmpl:wrap(map:new(), $td)
};

(:~
 : Wraps the specified content in the page template.
 : The following options can be specified:
 : <ul>
 :   <li><b>top</b>: current top category</li>
 :   <li><b>error</b>: error string</li>
 :   <li><b>info</b>: info string</li>
 : </ul>
 : @param  $td  td elements
 : @param  $options options
 : @return HTML page
 :)
declare function tmpl:wrap(
  $options  as map(*),
  $td       as element(td)+
) as element() {
  <html>
    <head>
      <meta charset="utf-8"/>
      <title>Database Administration</title>
      <meta name="description" content="Database Administration"/>
      <meta name="author" content="BaseX Team, 2014"/>
      <link rel="stylesheet" type="text/css" href="media/style.css"/> 
      <script type="text/javascript" src="media/js.js"/>
    </head>
    <body>
      <div class="right"><img src="media/basex.svg"/></div>
      <h1>Database Administration</h1>
      <div>{
        try {
          web:check(),
          let $cats := <cats>
            <cat name='databases'>Databases</cat>
            <cat name='queries'>Queries</cat>
            <cat name='logs'>Logs</cat>
            <cat name='users'>Users</cat>
            <cat name='settings'>Settings</cat>
            <cat name='logout'>Logout</cat>
          </cats>
          let $cats := 
            let $top := $options('top')
            for $cat in $cats/cat
            let $link := <a href="{ $cat/@name/data() }">{ $cat/data() }</a>
            return if($top = $link) then (
              <b>{ $link }</b>
            ) else (
              $link
            )
          return (head($cats), tail($cats) ! (' | ', .)),
          (1 to 4) ! '&#x2000;',
          element emph {
            attribute id { 'info' },
            $options('error')[.] ! (attribute class { 'error' }, .),
            $options('info')[.] ! (attribute class { 'info' }, .)
          }
        } catch basex:login {
          element emph {
            attribute id { 'info' },
            $options('error')[.] ! (attribute class { 'error' }, .),
            $options('info')[.] ! (attribute class { 'info' }, .)
          }, ' '
        }
      }</div>
      <hr/>
      <div class='small'/>
      <table width='100%'>
        <tr>{ $td }</tr>
      </table>
      <hr/>
      <div class='right'><sup>BaseX Team, 2014</sup></div>
      <div class='small'/>
      <script type="text/javascript">(function(){{ buttons(); }})();</script>
    </body>
  </html>
};
