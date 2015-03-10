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
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace G = "synopsx.globals" at '../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm' ; 

import module namespace synopsx.mappings.tei2html = 'synopsx.mappings.tei2html' at 'tei2html.xqm' ; 

declare namespace html = 'http://www.w3.org/1999/xhtml' ;

declare default function namespace 'synopsx.mappings.htmlWrapping' ;

(:~
 : this function wrap the content in an HTML layout
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return an updated HTML document and instantiate pattern
 
 : @todo treat in the same loop @* and text() ?
 @todo add handling of outputParams (for example {class} attribute or call to an xslt)
 :)

declare function wrapper($queryParams as map(*), $data as map(*), $outputParams as map(*)){
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $layout := synopsx.lib.commons:getLayoutPath($queryParams, map:get($outputParams, 'layout'))
  let $wrap := fn:doc($layout)
  return $wrap update (
    for $text in .//@*
      return replace value of node $text with inject($text, $queryParams, $meta, $outputParams),
     for $text in .//text()
       where fn:starts-with($text, '{') and fn:ends-with($text, '}')
       let $key := fn:replace($text, '\{|\}', '')
       return if ($key = 'content') 
         then replace node $text with pattern($queryParams, $data, $outputParams)
         else replace node $text with inject($text, $queryParams, $meta, $outputParams)
     )
};

declare function inject($text as xs:string, $queryParams as map(*), $meta as map(*), $outputParams as map(*)){
  let $input as map(*)*:= ($queryParams,$meta,$outputParams)(:sequence of map:)
  let $map := map:merge($input)(:create a unique map:)
  let $tokens := fn:tokenize($text, '\{|\}')
  let $new := fn:string-join( 
    for $token in $tokens
      let $value := map:get($map, $token)
        return if(fn:empty($value)) then $token
        else $value)
        return $new
};

(:~
 : this function iterates the pattern template with contents
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
        return replace value of node $text with inject($text, $queryParams, $content, $outputParams),
      for $text in .//text()
        where fn:starts-with($text, '{') and fn:ends-with($text, '}')
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
        return if ($key = 'tei') 
          then replace node $text with render($outputParams, $value) (: TODO : options : xslt, etc. :)
          else replace node $text with inject($text, $queryParams, $content, $outputParams)
      )
  })
};

(:~
 : this function wrap the content in an HTML layout
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return an updated HTML document and instantiate pattern
 :
 :)
declare function wrapperNew($queryParams as map(*), $data as map(*), $outputParams as map(*)) as element() {
  let $meta := map:get($data, 'meta')
  let $content := map:get($data, 'content')
  let $layout := synopsx.lib.commons:getLayoutPath($queryParams, map:get($outputParams, 'layout'))
  let $wrap := fn:doc($layout)/*
  let $regex := '\{(.*?)\}'
  return
    $wrap update (
      for $text in .//@*
        where fn:matches($text, $regex)
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($meta, $key) 
      return replace value of node $text with fn:string($value) ,
      for $text in .//text()
        where fn:matches($text, $regex)
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($meta, $key)
        return if ($key = 'content') 
          then replace node $text with patternNew($queryParams, $data, $outputParams)
          else if ($value instance of node()* and $value != empty) 
           then replace node $text with render($outputParams, $value)
           else replace node $text with inject($value, $meta)
      )
};

(:~
 : this function iterates the pattern template with contents
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query to dispacth
 : @param $outputParams the serialization params
 : @return instantiate the pattern with $data
 :
 :)
declare function patternNew($queryParams as map(*), $data as map(*), $outputParams as map(*)) as element()* {
  let $sorting := map:get($queryParams, 'sorting')
  let $order := map:get($queryParams, 'order')
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data, 'content')
  let $pattern := synopsx.lib.commons:getLayoutPath($queryParams, map:get($outputParams, 'pattern'))
  for $content in $contents
  order by (: @see http://jaketrent.com/post/xquery-dynamic-order/ :)
    if ($order = 'descending') then map:get($content, $sorting) else () ascending,
    if ($order = 'descending') then () else map:get($content, $sorting) descending
  let $regex := '\{(.*?)\}'
  return
    fn:doc($pattern)/* update (
      for $text in .//@*
        where fn:matches($text, $regex)
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
      return replace value of node $text with fn:string($value) ,
      for $text in .//text()
        where fn:matches($text, $regex)
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key)
        return if ($value instance of node()* and $value != empty) 
          then replace node $text with render($outputParams, $value)
          else replace node $text with inject($text, $content)
      )
};

(:~
 : this function update the text with input content
 :
 : @param $text the text node to process
 : @param $input the content to dispatch
 : @return an updated text
 :
 :)
declare function inject($text as xs:string, $input as map(*)) as xs:string {
  let $tokens := fn:tokenize($text, '\{|\}')
  let $updated := fn:string-join( 
    for $token in $tokens
    let $value := map:get($input, $token)
    return if (fn:empty($value)) 
      then $token
      else $value
    )
  return $updated
};

(:~
 : this function dispatch the rendering based on $outpoutParams
 :
 : @param $value the content to render
 : @param $outputParams the serialization params
 : @return an html serialization
 :
 : @todo check the xslt with an xslt 1.0
 :)
declare function render($outputParams as map(*), $value ) as element()* {
  let $xsl :=  map:get($outputParams, 'xsl')
  let $xquery := map:get($outputParams, 'xquery')
  let $options := 'option'
  return 
    if ($xquery) 
    then synopsx.mappings.tei2html:entry($value, $options)
    else if ($xsl) 
      then xslt:transform($value, $G:FILES || 'xsl/' || $xsl)
      else <p>rien</p>
};
