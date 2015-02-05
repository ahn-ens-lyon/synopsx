xquery version "3.0" ;
module namespace synopsx.lib.commons = 'synopsx.lib.commons';
(:~
 : This module is the RESTXQ for SynopsX
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

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';


(: Use a default namespace :)
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
 :)
 declare function getLayoutPath($queryParams as map(*), $template as xs:string) as xs:string {
   let $path := $G:PROJECTS || map:get($queryParams, 'project') || '/templates/' || $template
   return 
     if (file:exists($path)) 
     then $path
     else if (file:exists($G:TEMPLATES || $template)) then $G:TEMPLATES || $template
     else $G:TEMPLATES || 'default.xhtml'
 };

(:~
 : this function launches processings according to the resource functions (restxq)
 : @todo return error messages
 : @todo test heritage
 :)
declare function main($queryParams as map(*), $outputParams as map(*)){
  (: fn:function-lookup(xs:QName($data-model  || ':' || fn:string($node/@data-function)), 1)($queryParams :)
  let $dataModel := map:get($queryParams, 'dataModel')
  let $dataType := map:get($queryParams, 'dataType')
  return fn:function-lookup(xs:QName($dataModel  || ':' || $dataType), 1)($queryParams)
};

(:~
 : this function is Where everything will be decided later on
 : @param $queryParams params built from the url
 : @param $outputParams options e.g. locals, etc.
 : @param $layout layout for the project
 : @return adding the @data-model to the layout nodes when missing with the model specified in $queryParams->dataType
 copy the selected layout and modify to prepare data injection
 return the template instanciated 
 :) 
declare function main($queryParams as map(*), $outputParams as map(*), $layout as xs:string){
   copy $template := fn:doc($layout) modify (
    for $node in $template//*[@data-function][fn:not(@data-model)]
    return insert node attribute data-model {map:get($queryParams, 'model')} into $node
    )
    return synopsx.mappings.htmlWrapping:globalWrapper($queryParams, $outputParams, $template)
};