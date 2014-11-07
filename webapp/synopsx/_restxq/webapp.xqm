module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';
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

import module namespace G = "synopsx/globals" at '../globals.xqm';

(: Put here all import modules declarations as needed:)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';

(: Put her all import declarations for mapping according to models :)
import module namespace synopsx.mapping.htmlWrapping = 'synopsx.mapping.htmlWrapping' at '../mapping/htmlWrapping.xqm';

(: Specify namespaces used by the models:)
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: déclaration pour test :)

(: Available function to list one or several tei corpora :)
declare 
%restxq:path('/corpus')
%output:method("xhtml") (: TODO content negociation :)
  function webapp:corpusList(){
    let $options := '' (: to specify an xslt and other kin of option :)
    let $layout := $G:TEMPLATES || 'html.xhtml' (: corresponds to the template file for a global layout:)
    let $pattern := $G:TEMPLATES || 'chapter_tei.xhtml' (: corresponds to the template file for a fragment layout (to be repeated or not) :)
    return synopsx.mapping.htmlWrapping:wrapper
      (
        synopsx.models.tei:listCorpus(), $options, $layout, $pattern
      ) (: Calling the wrapper to bind fragment layout and models to display in the global layout:)
};

(: Where everything will be decided later on :)
declare function webapp:main($params){

    (:let $project := map:get($params,'project'):)
    $G:HOME
};


(:~
 : To be use to implement the webapp entry points
 : Used in the last version of synopsx  
 :) 
 
(: These five functions analyze the given path and retrieve the data :)
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
