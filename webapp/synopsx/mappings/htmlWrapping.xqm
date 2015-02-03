xquery version "3.0" ;
module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping';
(:~
 : This module is an HTML mapping for templating
 : @since 2014-11-10 
 : @version 0.3 (Constantia edition)
 : @author synopsx's team
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
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei/tei.xqm'; 
import module namespace synopsx.models.globals = 'synopsx.models.globals' at '../models/globals/globals.xqm'; 
import module namespace synopsx.models.ead = 'synopsx.models.ead' at '../models/ead/ead.xqm'; 

declare default function namespace 'synopsx.mappings.htmlWrapping';

declare namespace html = 'http://www.w3.org/1999/xhtml';

declare variable $synopsx.mappings.htmlWrapping:xslt := '../../static/xslt2/tei2html.xsl' ;

(:~
 : This function wrap the content in an html layout
 : @param $data brought by the model (is a map of meta data and content data)
 : @param $options are the rendering options (not used yet)
 : @param $layout path to the global layout
 : @param $pattern path to the fragment layout 
 : @return replace node or value of node in the template with value from the map
 :  
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @todo treat mixted content p.e.: "{quantity} éléments"
 : @todo treat in the same loop @* and text()
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
(:declare function pattern($meta as map(*), $contents  as map(*), $options, $pattern  as xs:string) as document-node()* {
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
};:)

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
    (:  if ($key = 'content') then    :)
        replace node $text with pattern($meta, $contents, $options, $pattern)
       (: else 
        replace node $text with (xslt:transform($value, '../../static/xslt2/tei2html5.xsl'))   :)
  )
};

(:~
 : This function 
 : @param $params transformation params
 : @param $options options params
 : @param $layout layout file
 :)
declare function globalWrapper($params, $options, $layout){
  copy $injected := $layout modify ( 
    (: Calling the function specified with :
        - namespace:@data-model
        - function-name:@data-function
    :)
    for $node in $injected//*[@data-function] 
    let $result := fn:function-lookup(xs:QName('synopsx.models.' || fn:string($node/@data-model) || ':' || fn:string($node/@data-function)), 1)($params)
    (: 
      - If the function contains a node or a string the result is inserted
      - If the function return a map, each item is wrapped according to the pattern specified in the @data-pattern, by calling the function pattern. 
     :)
    return typeswitch(fn:trace($result)) 
      case map(*) return
        let $meta := map:get($result, 'meta')
        let $contents := map:get($result,'content') 
        return map:for-each($contents, function($key, $content) {
         insert node pattern($meta, $content, $options, $G:TEMPLATES || fn:string($node/@data-pattern) || '.xhtml') into $node
    })
      default
       return insert node fn:function-lookup(xs:QName('synopsx.models.' || fn:string($node/@data-model) || ':' || fn:string($node/@data-function)), 1)($params) into $node
     )  
  return $injected
};

(:@date : 2/02/15:)
declare function pattern($meta as map(*), $content  as map(*), $options, $pattern  as xs:string) as document-node()* {
  copy $injected := fn:doc($pattern) modify (
    map:for-each($content, function($key, $item) {
        for $node in $injected//.[@data-key=$key]
          return replace value of node $node with fn:string($item) ,
        for $attribute in $injected//@*[fn:matches(.,'\{'||$key||'\}')]
          let $key := fn:replace($attribute, '\{|\}', '')
          return
            replace value of node $attribute with fn:string($item)
    })
)
return $injected
};
