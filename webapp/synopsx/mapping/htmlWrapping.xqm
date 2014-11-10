xquery version "3.0" ;
module namespace synopsx.mapping.htmlWrapping = 'synopsx.mapping.htmlWrapping';
(:~
 : This module is an HTML mapping for templating
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 :)

import module namespace G = "synopsx.globals" at '../globals.xqm';


(: use to avoid to prefix functions name:)
declare default function namespace 'synopsx.mapping.htmlWrapping'; 

(: Specify namespaces used by the models:)
declare namespace html = 'http://www.w3.org/1999/xhtml'; 


(:~
 : This function should be a wrapper
 : @data brought by the model (cf map of meta and content)
 : @options are the rendering options (not used yet)
 : @layout is the global layout
 : @pattern is the fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 :)
declare function wrapper($data as map(*), $options, $layout as xs:string, $pattern as xs:string){
  let $meta := map:get($data, 'meta')
  let $content := map:get($data,'content')
  let $tmpl := fn:doc($layout) (: open the global layout doc:)
  return $tmpl update (    
    replace node .//*:title/text() with map:get($meta, 'title'), (: replacing html title with the $meta title :)
    insert node to-html($content, $pattern) into .//html:main[@id='content'] (: see function below :)
  )
};


(:~
 : This function is supposed to do the magic inside the wrapper :
 : generates a document node with as many documents as there are contents
 :)
declare function to-html($contents  as map(*), $template  as xs:string) as document-node()* {
  map:for-each($contents, function($key, $content) {
    fn:doc($template) update (
      for $text in .//text() (: look through all text nodes with the particular condition specified below :)
      where fn:starts-with($text, '{') 
        and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '') (: get the text between braces :)
      let $value := $content($key) (: get the content corresponding to the key :)
      return replace node $text with $value (: replace text between braces with the content :)
    )
  })
};


(: deprecated function, check dependencies : use by c_tmpl.xhtml :)
declare  %updating function to-delete($items){
  for $item in $items
  let $name := fn:local-name($item) (: brings back the local-name (ead:unitid --> unitid) :)
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