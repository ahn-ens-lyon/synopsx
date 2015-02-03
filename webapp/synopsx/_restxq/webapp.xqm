xquery version "3.0" ;
module namespace synopsx.webapp = 'synopsx.webapp';
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

(: Put here all import modules declarations as needed :)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei/tei.xqm';

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';

(: Use a default namespace :)
declare default function namespace 'synopsx.webapp';

(:~
 : This resource function return the corpus item
 : 
 : @return an xhtml page binding layout templates and models
 : @rmq demo function for templating
 :)
declare 
  %restxq:path('/corpus')
  %output:method("xhtml") (: TODO content negociation :)
  function corpusList(){
    let $options := map {} (: specify an xslt mode and other kind of option :)
    let $layout  := $G:TEMPLATES || 'blogHtml5.xhtml'
  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml'
    return synopsx.mappings.htmlWrapping:wrapper
      (
        synopsx.models.tei:listCorpus(), $options, $layout, $pattern
      )
};



(:~
 : @@@@@@@@@@@@@@@@@@@@
 : To be use to implement the webapp entry points
 : Used in the last version of synopsx  
 : @@@@@@@@@@@@@@@@@@@@
 : These five functions analyze the given path and retrieve the data
 :
 :)

(:~
 : This resource function 
 :)
declare 
  %restxq:path("")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index() {
  let $params := map {
    "project" : "synopsx",
    "dataType" : "home"
  }
  return main($params)
};

(:~
 : This resource function 
 :)
declare 
  %restxq:path("{$project}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project) {
  let $params := map {
    "project" : $project,
    "dataType" : "home"
  }
  return main($params)
};

(:~
 : This resource function 
 :)
declare 
  %restxq:path("{$project}/{$dataType}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project, $dataType) {
  let $params := map {
    "project" : $project,
    "dataType" : $dataType
  }
  return main($params)
};

(:~
 : This resource function 
 :)
declare
  %restxq:path("{$project}/{$dataType}/{$value}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project, $dataType, $value) {
  let $params := map {
    "project" : $project,
    "dataType" : $dataType,
    "value" : $value
  }
  let $options := map {} (: specify an xslt mode and other kind of option :)
  let $layout  := $G:TEMPLATES || $project || '.xhtml'
  (:  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml' :)
  return main($params, $options, $layout)
};

(:~
 : This resource function 
 :)
declare 
  %restxq:path("{$project}/{$dataType}/{$value}/{$option}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project, $dataType, $value, $option) {
  let $params :=  map {
    "project" : $project,
    "dataType" : $dataType,
    "value" : $value,
    "option" : $option
  }
  return main($params)
};

(:~
 : @@@@@@@@@@@@
 : Function library
 : @@@@@@@@@@@@
 :)

(:~
 : This function (temporary) calls entry points
 :)
declare function main($params){
    (:let $project := map:get($params,'project'):)
    $G:HOME
};

(:~
 : This function is Where everything will be decided later on
 :) 
declare function main($params, $options, $layout){
    (:let $project := map:get($params,'project'):)
    copy $instanciated := fn:doc($layout) modify (
      (: adding the @data-model to the layout nodes when missing with the model specified in $params->dataType
      :)
      for $node in $instanciated//*[@data-function][fn:not(@data-model)]
      return insert node attribute data-model {map:get($params, 'dataType')} into $node
    )
   (:  return $instanciated  :)
     return  synopsx.mappings.htmlWrapping:globalWrapper($params, $options, $instanciated) 
};