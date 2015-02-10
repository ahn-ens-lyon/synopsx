xquery version "3.0" ;
module namespace synopsx.lib.commons = 'synopsx.lib.commons';
(:~
 : This module is a function library for SynopsX
 :
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

declare default function namespace 'synopsx.lib.commons';

(:~
 : ~:~:~:~:~:~:~:~:~
 : Function library
 : ~:~:~:~:~:~:~:~:~
 :)

declare function getProjectDB($project as xs:string) as xs:string {
  fn:doc($G:CONFIGFILE)//config/projects/project[resourceName/text() = $project]/dbName/text()
};

(:~
 : this function built the layout path based on the project hierarchy
 :
 : @param $queryParams the query params
 : @param $template the template name.extension
 : @return a path 
 :)
declare function getLayoutPath($queryParams as map(*), $template as xs:string?) as xs:string {
  if (fn:empty($template)) then $G:TEMPLATES || 'inc_default.xhtml' 
  else let $path := $G:PROJECTS || map:get($queryParams, 'project') || '/templates/' || $template
  return 
    if (file:exists($path)) 
    then $path
    else if (file:exists($G:TEMPLATES || $template)) then $G:TEMPLATES || $template
    else if (fn:empty($template)) then $G:TEMPLATES || 'default.xhtml'
    else $G:TEMPLATES || 'default.xhtml'
};

(:~
 : this function launches processings according to the resource functions (restxq)
 :
 : @param $queryParams the query params
 : @param $outputParams the serialization params
 : @return find the function name
 :
 : @todo return error messages
 : @todo test heritage
 : @rmq depreciated
 :)
declare function main($queryParams as map(*), $outputParams as map(*)){
  (: fn:function-lookup(xs:QName($data-model  || ':' || fn:string($node/@data-function)), 1)($queryParams :)
  let $dataModel := map:get($queryParams, 'dataModel')
  let $dataType := map:get($queryParams, 'dataType')
  return fn:function-lookup(xs:QName($dataModel  || ':' || $dataType), 1)($queryParams)
};