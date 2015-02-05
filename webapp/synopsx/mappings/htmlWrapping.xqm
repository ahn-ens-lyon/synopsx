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

declare default function namespace 'synopsx.mappings.htmlWrapping';

declare namespace html = 'http://www.w3.org/1999/xhtml';

declare variable $synopsx.mappings.htmlWrapping:xslt := '../../static/xslt2/tei2html.xsl' ;

(:~
 : This function 
 : @param $queryParams transformation params
 : @param $outputParams options params
 : @param $layout layout file
 :)
declare function globalWrapper($queryParams as map(*), $outputParams as map(*), $layout as document-node()){
  copy $injected := $layout modify ( 
    (: Calling the function specified with :
        - namespace:@data-model
        - function-name:@data-function
    :)
    for $node in $injected//*[@data-function] 
    let $data-model := fn:string($node/@data-model)
    let $result := fn:function-lookup(xs:QName($data-model  || ':' || fn:string($node/@data-function)), 1)($queryParams)
    (: 
      - If the function contains a node or a string the result is inserted
      - If the function return a map, each item is wrapped according to the pattern specified in the @data-pattern, by calling the function pattern. 
     :)
    return typeswitch($result)
      case map(*) return
        let $meta := map:get($result, 'meta')
        let $contents := map:get($result,'content') 
        return map:for-each($contents, function($key, $content) {
         insert node pattern($meta, $content, $outputParams, $G:TEMPLATES || fn:string($node/@data-pattern) || '.xhtml') into $node
    })
      default
       return insert node fn:function-lookup(xs:QName(fn:string($node/@data-model)  || ':' || fn:string($node/@data-function)), 1)($queryParams) into $node
     )  
  return $injected
};

(:@date : 2/02/15:)
declare function pattern($meta as map(*), $content  as map(*), $outputParams, $pattern  as xs:string) as document-node()* {
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
