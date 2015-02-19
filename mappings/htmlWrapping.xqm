xquery version '3.0' ;
module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' ;

(:~
 : This module is an HTML mapping for templating
 :
 : @version 2.0 (Constantia edition)
 : @since 2014-11-10 
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

import module namespace G = "synopsx.globals" at '../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm' ; 


declare namespace html = 'http://www.w3.org/1999/xhtml' ;

declare default function namespace 'synopsx.mappings.htmlWrapping' ;

declare variable $synopsx.mappings.htmlWrapping:xslt := '../files/xsl/tei2html.xsl' ;

(:~
 : this function wrap the content in an HTML layout
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return an updated HTML document and instantiate pattern
 :
 : @todo modify to replace mixted content like "{quantity} éléments" 
 : @todo treat in the same loop @* and text() ?
 :)
declare function wrapper($queryParams as map(*), $data as map(*), $outputParams as map(*)){
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $layout := synopsx.lib.commons:getLayoutPath($queryParams, map:get($outputParams, 'layout'))
  let $wrap := fn:doc($layout)
  return $wrap update (
    (: Head part of the HTML page if exists : css, js, etc. :)
    (: for $text in .//*:head//*:link/@*:href
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $path := fn:replace($text, '\{|\}', '')
      return replace value of node $text with fn:trace(synopsx.lib.files:getFile($path), 'CSS File :'),
      for $text in .//*:head//*:script/@*:src
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $path := fn:replace($text, '\{|\}', '')
      return replace value of node $text with synopsx.lib.files:getFile($path), :)
      (: Other meta and body part of the HTML page if exists : title, items... :)  
    for $text in .//*:body/@*
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta, $key)
      return replace value of node $text with fn:string($value),
     for $text in .//text()
       where fn:starts-with($text, '{') and fn:ends-with($text, '}')
       let $key := fn:replace($text, '\{|\}', '')
       let $value := map:get($meta,$key)
       return if ($key = 'content') 
         then replace node $text with pattern($queryParams, $data, $outputParams)
         else replace node $text with $value 
     )
};

(:~
 : This function iterates the pattern template with contents
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return instantiate the pattern with $data
 :
 : @todo modify to replace mixed content like "{quantity} éléments"
 : @todo treat in the same loop @* and text()
 : @todo use $outputParams to use an xslt
 :)
declare function pattern($queryParams as map(*), $data as map(*), $outputParams as map(*)) as document-node()* {
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $pattern := synopsx.lib.commons:getLayoutPath($queryParams, map:get($outputParams, 'pattern'))
  return map:for-each($contents, function($key, $content) {
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
        return if ($key = 'xsl') 
          then replace node $text with $value (: TODO : options : xslt, etc. :)
          else replace node $text with $value
      )
  })
};