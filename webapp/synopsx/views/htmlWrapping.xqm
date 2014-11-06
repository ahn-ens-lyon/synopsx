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
  (: a supprimer après passage à xslt2:)
  return $tmpl update (
    for $node in $content('items')
    return
      insert node (xslt:transform($node, $G:WEBAPP || 'static/xslt2/tei2html5.xsl',$options)) into .//html:div[@id='content'],
      replace node .//html:title with $content('title')
  )
};

declare function to-html($items){
  for $item in $items
  let $name := fn:local-name($item)
  let $tmpl := fn:doc($name || "_tmpl.html")
  return $tmpl
};


(: replace value of node .//html:div[@id='content'] with xslt:transform($contentWrap,'http://localhost:8984/static/xsl/tei2html5.xsl',$options), :)

