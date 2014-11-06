module namespace htmlUsers = 'synopsx.views.htmlUsers';

import module namespace Session = "http://basex.org/modules/session";

<<<<<<< HEAD
import module namespace G = "synopsx/globals";
=======
import module namespace G = "synopsx/globals" at '../globals.xqm';
>>>>>>> 7d18bd36e197965a1ef6fd92bd293e64559b3066



declare function htmlUsers:create-user($content, $options, $layout) {
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

declare function htmlUsers:list-user($content, $options, $layout) {
  let $tmpl := fn:doc($layout('layout'))
  
  return $tmpl update (
    replace node .//*:div[@id='content'] with (
      htmlUsers:status($content('status')),
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

declare function htmlUsers:status(
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
