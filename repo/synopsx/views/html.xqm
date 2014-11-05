module namespace html = 'synopsx.views.html';

import module namespace Session = "http://basex.org/modules/session";

import module namespace G = "synopsx/globals";

declare function html:render($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      let $items := $content('items')
      let $status := $content('status')
      return
        <form action="/tei/select" method='post'>
          { html:status($status) }
          <input type='submit' value='ORDER'/>
          <br/>
          User: <input type='text' name='user' value='{ Session:get("user") }'/>
          <br/>
          {
            let $selected := Session:get("selected")/item
            for $item at $p in $items
            return (
              element input {
                attribute type { 'checkbox' },
                attribute name { 'items' },
                attribute checked { 'checked' }[$p = $selected],
                attribute value { $p },
                $item/text()
              },
              <br/>
            )
        }</form>
    ),
    replace value of node .//*:title with $content('title')
  )
};

declare function html:create-user($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      <form action="/create-user/apply" method='post'>
        <input type='text' name='name'/>
        <input type='submit' value='Create'/>
      </form>
    ),
    replace value of node .//*:title with $content('title')
  )
};

declare function html:list-user($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      html:status($content('status')),
      <ul>{
        for $user in db:open('users')/users/user
        let $name := $user/@name/string()
        return <li>{ $name }  
          (<a href="delete-user/apply?name={ $name }">delete</a>)
        </li>
      }</ul>,
      <form action='create-user'>
        <input type='submit' value='Create User'/>
      </form>
    ),
    replace value of node .//*:title with $content('title')
  )
};

declare function html:status(
  $status as xs:string
) {
  let $msg := $G:STATUS($status)
  return if($msg) then (
    <div>Status: { $msg }</div>
  ) else (
    (: Safer: catch unknown status
      error(xs:QName('INVALID'), "Unknown status.") :)
    ()
  )
};
