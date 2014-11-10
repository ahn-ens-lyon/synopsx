module namespace htmlBasket = 'synopsx.mapping.htmlBasket';

import module namespace Session = "http://basex.org/modules/session";

import module namespace G = "synopsx/globals" at '../globals.xqm';

declare function htmlBasket:form($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      let $items := $content('items')
      let $status := $content('status')
      return
        <form action="/tei/select" method='post'>
          { htmlBasket:status($status) }
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

(: A mutualiser :)
declare function htmlBasket:status(
  $status as xs:string
) {
  let $msg := $G:STATUS($status)
  return if($msg) then (
    <div>Status: { $msg }</div>
  ) else (
    (: Safer: catch unknown status
      error(xs:QName('INVALID'), "Unknown status.") :)
   <div>No status</div>
  )
};
