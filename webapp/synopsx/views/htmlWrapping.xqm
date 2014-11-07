module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping';
(:~
 : AHN
 :)
import module namespace G = "synopsx/globals" at '../globals.xqm';

declare default function namespace 'synopsx.views.htmlWrapping'; 
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; 
declare namespace html = 'http://www.w3.org/1999/xhtml'; 

declare function render($content, $options, $layout){
  let $tmpl := fn:doc($layout('layout'))
  return $tmpl update (
    for $node in $content('items')
    return
      insert node (xslt:transform($node, $G:WEBAPP || 'static/xslt2/tei2html5.xsl',$options)) into .//html:div[@id='content'],
      replace node .//html:title with $content('title')
  )
};

(:~
 : this function should be a wrapper
 :)
declare function wrapper($data, $options, $layout, $pattern){
  let $meta := map:get($data, 'meta')
  let $content := map:get($data,'content')
  let $tmpl := fn:doc($layout)
  return $tmpl update (
    (:map:get($meta('title'),1):)
    (: prof:dump($data,'data : '), :)
    replace node .//*:title/text() with map:get($meta, 'title'),
    insert node to-html($content, $pattern) into .//html:main[@id='content']
  )
};

(:~
 : this one is supposed to do the magic inside the wrapper
 :)
declare function to-html(
  $contents  as map(*),
  $template  as xs:string
) as document-node()* {
  map:for-each($contents, function($key, $content) {
    fn:doc($template) update (
      for $text in .//text()
      where fn:starts-with($text, '[')
        and fn:ends-with($text, ']')
      let $key := fn:replace($text, '\[|\]', '')
      let $value := $content($key)
      return replace node $text with $value
    )
  })
};

(:~
 : this one is supposed to do the magic inside the wrapper
 :)
declare  %updating function to-delete($items){
  for $item in $items
  let $name := fn:local-name($item) (: rapporte le nom local ead:unitid --> unitid :)
  let $tmpl := fn:doc($name || "_tmpl.html") 
  return 
    insert node $item into $tmpl
};
