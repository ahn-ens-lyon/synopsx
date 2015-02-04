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
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm';

(: Use a default namespace :)
declare default function namespace 'synopsx.webapp';

(:~
 : this resource function return the corpus item
 : 
 : @return an xhtml page binding layout templates and models
 : @rmq demo function for templating
 :)
(: declare 
  %restxq:path('/corpus')
  %output:method("xhtml") (: TODO content negociation :)
  function corpusList(){
    let $queryParams := map {
    "project" : 'hyperdonat',
    "dataType" : 'persName',
    "model" : 'synopsx.models.tei',
    "dbName" : synopsx.lib.commons:getProjectDB('hyperdonat')
      }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, 'home.xhtml')
    return synopsx.lib.commons:main
      (
        synopsx.models.tei:listCorpus($queryParams), $outputParams, $layout
      )
}; :)



(:~
 : ~:~:~:~:~:~:~:~:~
 : To be use to implement the webapp entry points
 : Used in the last version of synopsx  
 : ~:~:~:~:~:~:~:~:~
 : These five functions analyze the given path and retrieve the data
 :
 :)

(:~
 : this resource function 
 :)
declare 
  %restxq:path("")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index() {
  let $queryParams := map {
    'project' : 'synopsx',
    'dataType' : 'home',
    'model' : 'synopsx.models.tei'
  }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, 'home.xhtml')
  return synopsx.lib.commons:main($queryParams, $outputParams, $layout)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path("{$project}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project) {
  let $queryParams := map {
    "project" : $project,
    "model" : 'synopsx.models.tei',
    "dbName" : synopsx.lib.commons:getProjectDB($project)
      }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $template := 'multi.xhtml'
  let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, $template)
  (:  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml' :)
  return synopsx.lib.commons:main($queryParams, $outputParams, $layout)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path("{$project}/{$dataType}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project, $dataType) {
  let $queryParams := map {
    "project" : $project,
    "dataType" : $dataType,
    "model" : 'synopsx.models.tei',
    "dbName" : synopsx.lib.commons:getProjectDB($project)
      }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $template := 'multi.xhtml'
  let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, $template)
  (:  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml' :)
  return synopsx.lib.commons:main($queryParams, $outputParams, $layout)
};

(:~
 : this resource function gets texts containing a given persName
 : @param $project project name
 : @param $value resource id
 : @return builds a $queryParams map with url path, and calls main function with $queryParams, $outputParams and a $layout constructed by the project
 : @todo give options e.g. language from browser
 :)
declare
  %restxq:path("{$project}/{$dataType}/{$value}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function textsByPerson($project, $dataType, $value) {
  let $queryParams := map {
    "project" : $project,
    "dataType" : $dataType,
    "value" : $value,
    "model" : 'synopsx.models.tei',
    "dbName" : synopsx.lib.commons:getProjectDB($project)
      }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $template := 'multi.xhtml'
  let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, $template)
  (:  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml' :)
  return synopsx.lib.commons:main($queryParams, $outputParams, $layout)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path("{$project}/{$dataType}/{$value}/{$option}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function index($project, $dataType, $value, $option) {
    let $queryParams := map {
    "project" : $project,
    "dataType" : $dataType,
    "value" : $value,
    "option" : $option,
    "model" : 'synopsx.models.tei',
    "dbName" : synopsx.lib.commons:getProjectDB($project)
      }
  let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
  let $template := 'multi.xhtml'
  let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, $template)
  (:  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml' :)
  return synopsx.lib.commons:main($queryParams, $outputParams, $layout)
};



