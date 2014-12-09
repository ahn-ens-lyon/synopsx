xquery version "3.0" ;
module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping';
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
declare default function namespace 'synopsx.mappings.htmlWrapping'; 

(: Specify namespaces used by the models:)
declare namespace html = 'http://www.w3.org/1999/xhtml'; 
declare variable $synopsx.mappings.htmlWrapping:xslt := '../../static/xslt2/tei2html.xsl' ;

(:~
 : this function can eventually call an innerWrapper to perform intermediate wrappings 
 : @data brought by the model (is a map of meta data and content data)
 : @options are the rendering options (not used yet)
 : @layout is the global layout
 : @pattern is the fragment layout 
 :
 : This function wrap the content in an html layout
 :
 : @data a map built by the model with meta values
 : @options options for rendering (not in use yet)
 : @layout path to the global wrapper html file
 : @pattern path to the html fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @change add flexibility to retrieve meta values and changes in variables names EC2014-11-15
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 : @toto treat in the same loop @* and text()
 :)
declare function wrapper($data, $options, $layout, $pattern){
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $wrap := fn:doc($layout)
  return $wrap update (
    for $text in .//@*
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta, $key)
      return replace value of node $text with fn:string($value) ,
    for $text in .//text()
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta,$key)
      return if ($key = 'content') 
        then replace node $text with pattern($meta, $contents, $options, $pattern)
        else replace node $text with $value 
    )
};

(:~
 : This function iterates the pattern template with contents
 :
 : @meta meta values built by the model as a map
 : @contents contents values built by the model as a map
 : @options options for rendering (not in use yet)
 : @pattern path to the html fragment layout 
 :
 : @toto modify to replace text nodes like "{quantity} éléments" (mixed content) EC2014-11-15
 : @toto treat in the same loop @* and text()
 :)
declare function pattern($meta as map(*), $contents  as map(*), $options, $pattern  as xs:string) as document-node()* {
  map:for-each($contents, function($key, $content) {
    fn:doc($pattern) update (
      for $text in .//@*
        where fn:starts-with($text, '{') and fn:ends-with($text, '}')
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
        return replace value of node $text with fn:string($value) ,
      for $text in .//text()
        where fn:starts-with($text, '{') and fn:ends-with($text, '}')
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
        return if ($key = 'tei') 
          then replace node $text with xslt:transform($value, $synopsx.mappings.htmlWrapping:xslt)
          else replace node $text with $value
      )
  })
};

(:~
 : This function wrap the content in an html layout
 :
 : @data a map built by the model with meta values
 : @options options for rendering (not in use yet)
 : @layout path to the global wrapper html file
 : @pattern path to the html fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @change add flexibility to retrieve meta values and changes in variables names EC2014-11-15
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 :
 : This function should be called by a global wrapper and wraps a sequence of items according to the pattern
 : @content brought by the model 
 : @options are the rendering options (not used yet)
 : @pattern is the fragment layout 
 :)
declare function innerWrapper($meta, $content, $options, $pattern){
  let $tmpl := fn:doc('../templates/'||map:get($options, 'middle'))
  return $tmpl update (
    replace node /*/text() with  pattern($meta, $content, $pattern, $options)
  )
};

(:~
 : this function can eventually call an innerWrapper to perform intermediate wrappings 
 : @data brought by the model (is a map of meta data and content data)
 : @options are the rendering options (not used yet)
 : @layout is the global layout
 : @pattern is the fragment layout 
 :
 : This function wrap the content in an html layout
 :
 : @data a map built by the model with meta values
 : @options options for rendering (not in use yet)
 : @layout path to the global wrapper html file
 : @pattern path to the html fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @change add flexibility to retrieve meta values and changes in variables names EC2014-11-15
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 :)
declare function globalWrapper($data, $options, $layout, $pattern){
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $wrap := fn:doc($layout) (: open the global layout doc:)
  return $wrap update (
    for $text in .//text() 
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta,$key)
    return 
      if ($key = 'content') then 
        replace node $text with pattern($meta, $contents, $options, $pattern)
      else 
        replace node $text with (xslt:transform($value, '../../static/xslt2/tei2html5.xsl'))
  )
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



(:~
 : deprecated function
 : This function should be a wrapper (BN : first version with no recursive inputs, formerly used for simple usage)
 : @data brought by the model (cf map of meta and content)
 : @options are the rendering options (not used yet)
 : @layout is the global layout
 : @pattern is the fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 :)
(: declare function wrapper($data as map(*), $options, $layout as xs:string, $pattern as xs:string){
  let $meta := map:get($data, 'meta')
  let $content := map:get($data,'content')
  let $tmpl := fn:doc($layout) (: open the global layout doc:)
  return $tmpl update (    
    replace node .//*:title/text() with map:get($meta, 'title'), (: replacing html title with the $meta title :)
    insert node pattern($content, $pattern, $options) into .//html:div[@title='main'] (: see function below :)
  )
}; :)