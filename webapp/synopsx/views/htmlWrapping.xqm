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
declare  %updating function to-html($content, $pattern){
  map:for-each($content,
     function($id, $map)
       
       {
         prof:dump($map, 'map : '),
         let $tmpl := fn:doc($pattern)
         
         return map:for-each($map,
         
           function($key, $value)
           {
             
             prof:dump($key, 'key : '),
             prof:dump($tmpl//*/@id, 'value : '), (: pb d'espace de nom:)
             replace node $tmpl//*[@id=$key]/text() with fn:string($value)
           }
         )
       }
  )

};


(: replace value of node .//html:div[@id='content'] with xslt:transform($contentWrap,'http://localhost:8984/static/xsl/tei2html5.xsl',$options), :)


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
