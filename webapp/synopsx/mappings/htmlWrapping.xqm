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
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm'; 
import module namespace synopsx.models.mixed = 'synopsx.models.mixed' at '../models/mixed.xqm'; 
import module namespace synopsx.models.ead = 'synopsx.models.ead' at '../models/ead.xqm'; 
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm'; 

declare default function namespace 'synopsx.mappings.htmlWrapping';


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
 : @todo modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 : @todo treat in the same loop @* and text()
 : @todo send to pattern $meta and $contents in a single map
 :)
declare function wrapper($queryParams as map(*), $data as map(*), $options as map(*), $layout as xs:string, $pattern as xs:string){
          if(map:size($queryParams) = 0) then 'Pas de queryParams associés à cette requête...'
          else if (map:size($data) = 0) then 'Pas de data associées à cette requête...'
         else let $layout := synopsx.lib.commons:getLayoutPath($queryParams, $layout)
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
                then replace node $text with simplePattern($queryParams, $meta, $contents, $options, $pattern)
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
declare function simplePattern($queryParams, $meta as map(*), $contents  as map(*), $options, $pattern  as xs:string) as document-node()* {
  let $pattern := synopsx.lib.commons:getLayoutPath($queryParams, $pattern)
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
        return if ($key = 'tei') 
          then replace node $text with $value (: TODO : options : xslt, etc. :)
          else replace node $text with $value
      )
  })
};
