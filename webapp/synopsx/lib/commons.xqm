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
 declare function getLayoutPath($params as map(*), $template as xs:string) as xs:string {
   if (file:exists( $G:PROJECTS || map:get($params, 'project') || '/' || $template) )   
   then $G:PROJECTS || map:get($params, 'project') || '/' || $template
   else if (file:exists($G:TEMPLATES || $template)) then $G:TEMPLATES || $template
   else $G:TEMPLATES || 'default.xhtml'
 };

(:~
 : this function (temporary) calls entry points
 :)
declare function main($params){
    (:let $project := map:get($params,'project'):)
    $G:HOME
};

(:~
 : this function is Where everything will be decided later on
 : @param $params params built from the url
 : @param $options options e.g. locals, etc.
 : @param $layout layout for the project
 : @return adding the @data-model to the layout nodes when missing with the model specified in $params->dataType
 copy the selected layout and modify to prepare data injection
 return the template instanciated 
 :) 
declare function main($params as map(*), $options as map(*), $layout as xs:string){
  copy $template := fn:doc($layout) modify (
    for $node in $template//*[@data-function][fn:not(@data-model)]
    return insert node attribute data-model {map:get($params, 'model')} into $node
    )
    return synopsx.mappings.htmlWrapping:globalWrapper($params, $options, $template)
};