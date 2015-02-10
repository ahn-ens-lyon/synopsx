xquery version "3.0" ;
module namespace synopsx.webapp = 'synopsx.webapp' ;
(:~
 : This module is the RESTXQ for SynopsX's default entry points
 : @version 0.2 (Constantia edition)
 : @since 2014-11-10 
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

import module namespace G = "synopsx.globals" at '../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm' ;

import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm' ;
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ;

declare default function namespace 'synopsx.webapp' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : Default home
 : ~:~:~:~:~:~:~:~:~
 :
 : These two functions returns a default home based on the 'config.xml' file
 :)
 
(:~
 : this resource function redirect to /home
 :)
declare 
  %restxq:path("")
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/home"/>
    </http:response>
  </rest:response>
};

(:~
 : this resource function is the default home
 : @return a home based on the default project in 'config.xml'
 : @todo move project test to lib/ ?
 :)
declare 
  %restxq:path("/home")
  %restxq:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function home() {
  let $project := 
    if(file:exists($G:CONFIGFILE)) then
      if(fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()) then 
        fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()
      else fn:doc($G:CONFIGFILE)//project[1]/resourceName/text()
    else ()
  return if(fn:empty($project)) then
    <rest:forward>/synopsx/install</rest:forward>
  else 
   <rest:forward>/{$project}/home</rest:forward>
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : Default webapp entry points
 : ~:~:~:~:~:~:~:~:~
 :
 : These five functions analyze the given path and retrieve the data
 :
 : @todo build default resource function
 :)

(:~
 : this resource function 
 :)
declare 
  %restxq:path('{$project}')
  %restxq:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project) {
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : 'synopsx.models.tei', (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'home'
      }
    let $data := map{} (: synopsx.models.tei:getCorpusList($queryParams) :)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'default.xhtml',
      'pattern' : ''
      (: specify an xslt mode and other kind of output options :)
      }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path('{$project}/{$dataType}')
  %restxq:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project as xs:string, $dataType as xs:string) {
  let $queryParams := map {
    'project' : $project,
    'dataType' : $dataType,      
    'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
    'model' : 'synopsx.models.tei' (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
    }
  let $data := map{} (: synopsx.models.tei:getCorpusList($queryParams) :)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'default.xhtml',
    'pattern' : ''
    (: specify an xslt mode and other kind of output options :)
    }
  return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path('{$project}/{$dataType}/{$value}')
  %restxq:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project as xs:string, $dataType as xs:string, $value as xs:string) {
  let $queryParams := map {
    'project' : $project,
    'dataType' : $dataType,      
    'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
    'model' : 'synopsx.models.tei' (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
    }
  let $data := map{} (: synopsx.models.tei:getCorpusList($queryParams) :)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'default.xhtml',
    'pattern' : ''
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
};

(:~
 : this resource function 
 :)
declare 
  %restxq:path('{$project}/{$dataType}/{$value}/{$options}')
  %restxq:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function default($project, $dataType, $value, $options) {
  let $queryParams := map {
    'project' : $project,
    'dataType' : $dataType,
    'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
    'model' : 'synopsx.models.tei' (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
    }
  let $data := map{} (: synopsx.models.tei:getCorpusList($queryParams) :)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'default.xhtml',
    'pattern' : ''
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
};

