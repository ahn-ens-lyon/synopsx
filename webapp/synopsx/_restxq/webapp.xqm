<<<<<<< HEAD
=======
module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';
>>>>>>> 7d18bd36e197965a1ef6fd92bd293e64559b3066
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

<<<<<<< HEAD
module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';

import module namespace Session = "http://basex.org/modules/session";

import module namespace synopsx.models.tei = 'synopsx.models.tei';
import module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping';

import module namespace G = "synopsx/globals";
=======
import module namespace G = "synopsx/globals" at '../globals.xqm';

import module namespace Session = "http://basex.org/modules/session";

import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';
import module namespace synopsx.views.htmlWrapping = 'synopsx.views.htmlWrapping' at '../views/htmlWrapping.xqm';


>>>>>>> 7d18bd36e197965a1ef6fd92bd293e64559b3066

declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: déclaration pour test :)

declare variable $webapp:layout := 
  (: in future: file:base-dir() :)
<<<<<<< HEAD
  file:parent(static-base-uri()) || '../../repo/synopsx/templates/html.xml';
=======
  file:parent(static-base-uri()) || '../templates/html.xml';
>>>>>>> 7d18bd36e197965a1ef6fd92bd293e64559b3066

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
<<<<<<< HEAD
    'hello'
=======
    $G:HOME
>>>>>>> 7d18bd36e197965a1ef6fd92bd293e64559b3066
    
};

