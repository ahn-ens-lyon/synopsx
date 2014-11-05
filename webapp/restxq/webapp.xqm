(:
This file is part of SynopsX.
    created by AHN team (http://ahn.ens-lyon.fr)
    release 0.1, 2014-01-28

SynopsX is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

SynopsX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with SynopsX.
If not, see <http://www.gnu.org/licenses/>
:)

module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';

import module namespace synopsx.models.tei = 'synopsx.models.tei';
import module namespace synopsx.views.html = 'synopsx.views.html';

declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: déclaration pour test :)

declare variable $webapp:layout := '../repo/synopsx/templates/html.xml';

(: These five functions analyse the given path and retrieve the data :)
declare %restxq:path("")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function webapp:index() {
  let $params := map {
      "project" := "synopsx",
      "dataType" := "home"
    }
   return webapp:main($params)
};


declare %restxq:path("{$project}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function webapp:index($project) {
  let $params := map {
      "project" := $project,
      "dataType" := "home"
    }

    return webapp:main($params)
};


declare %restxq:path("{$project}/{$dataType}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function webapp:index($project, $dataType) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType
      }
    return webapp:main($params)
};

declare %restxq:path("{$project}/{$dataType}/{$value}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function webapp:index($project, $dataType, $value) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType,
      "value" := $value
      }
    return webapp:main($params)
};

declare %restxq:path("{$project}/{$dataType}/{$value}/{$option}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function webapp:index($project, $dataType, $value, $option) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType,
      "value" := $value,
      "option" := $option
      }

    return webapp:main($params)
};

declare function webapp:main($params){

    (:let $project := map:get($params,'project'):)
    'hello'
    
};

declare %restxq:path('/tei')

function webapp:tei() {
    let $format as xs:string := 'html' (: par défaut on produit du html:)
    let $content as map(*) := map {
        'title' := synopsx.models.tei:title(),
        'items' := synopsx.models.tei:listItems() 
        
      }
    let $options as map(*) := map {
          'mode' := 'short'  
      }
    let $layout as map(*) := map {
          'layout' := $webapp:layout
      }
    (:
    : @TODO negociation de contenu
    :)
    return synopsx.views.html:render($content, $options, $layout)
};


(:~
 : resource function with content negociation (test)
 :)
 

declare %restxq:path("negociation")
         %restxq:GET
         %rest:produces("application/json")
function webapp:negociation-get(){
  db:open('gdp')//tei:head
  
};
