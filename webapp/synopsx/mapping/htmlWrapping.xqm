module namespace synopsx.mapping.htmlWrapping = 'synopsx.mapping.htmlWrapping';
(:~
 : Wrapper for HTML layout
 : @author: synopsx team 
 :)
import module namespace G = "synopsx/globals" at '../globals.xqm';

(: use to avoid to prefix functions name:)
declare default function namespace 'synopsx.mapping.htmlWrapping'; 

(: Specify namespaces used by the models:)
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; 
declare namespace html = 'http://www.w3.org/1999/xhtml'; 

(:~
 : this function should be a wrapper
   @data brought by the model (cf map of meta and content)
   @options (not used yet)
   @layout is the global layout
   @pattern is the fragment layout 
   
 : To debug use prof:dump($data,'data : '), cf the basexhttp console which have launched the basexhttp server
 :)
declare function wrapper($data, $options, $layout, $pattern){
  let $meta := map:get($data, 'meta')
  let $content := map:get($data,'content')
  let $tmpl := fn:doc($layout) (: open the global layout doc:)
  return $tmpl update (    
    replace node .//*:title/text() with map:get($meta, 'title'), (: replacing html title with the $meta title :)
    insert node to-html($content, $pattern) into .//html:main[@id='content'] (: see function below :)
  )
};

(:~
 : this one is supposed to do the magic inside the wrapper
 : generate a document node with as many documents as there are contents
 :)
declare function to-html($contents  as map(*), $template  as xs:string) as document-node()* {
  map:for-each($contents, function($key, $content) {
    fn:doc($template) update (
      for $text in .//text() (: looking for all text() with the particular condition specified below :)
      where fn:starts-with($text, '[') 
        and fn:ends-with($text, ']')
      let $key := fn:replace($text, '\[|\]', '') (: removing the brackets '[' ']' :)
      let $value := $content($key) (: getting the value corresponding to the key :)
      return replace node $text with $value (: replacing this text with the content text :)
    )
  })
};

(: deprecated function, check dependencies : use by c_tmpl.xhtml :)
declare  %updating function to-delete($items){
  for $item in $items
  let $name := fn:local-name($item) (: rapporte le nom local ead:unitid --> unitid :)
  let $tmpl := fn:doc($name || "_tmpl.xhtml") 
  return 
    insert node $item into $tmpl
};


(: deprecated function, check dependencies with htmlBasket.xqm and htmlUsers.xqm :)
declare function render($content, $options, $layout){
  let $tmpl := fn:doc($layout('layout'))
  return $tmpl update (
    for $node in $content('items')
    return
      insert node (xslt:transform($node, $G:WEBAPP || 'static/xslt2/tei2html5.xsl',$options)) into .//html:div[@id='content'],
      replace node .//html:title with $content('title')
  )
};