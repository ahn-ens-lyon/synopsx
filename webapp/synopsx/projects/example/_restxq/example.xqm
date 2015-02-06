xquery version "3.0" ;
module namespace example.webapp = 'example.webapp';
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

import module namespace G = "synopsx.globals" at '../../../globals.xqm';

(: Put here all import modules declarations as needed :)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm';

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm';

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm';

(: Use a default namespace :)
declare default function namespace 'example.webapp';

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
 : dispatch betweens resource function is based on http constraints
 : @bug not working
 :)
declare 
  %restxq:path('/corpus')
function corpus() {
  <rest:response>
    <http:response status="200" message="OK">
      <http:header name="Content-Location" value="http://localhost:8984/corpus/html"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>
};

(:~
 : this resource function 
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/corpus/html')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function corpusHtml() {
    let $project := 'example'
    let $model := 'synopsx.models.tei'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'getCorpusList'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    let $data := synopsx.models.tei:getCorpusList($queryParams)
    let $layout  := 'blogHtml5.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
    synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, '') (: give $data instead of $queryParams:)
};


(:~
 : this crad resource function 
 : $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/biblio/list/html")
  %restxq:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
    let $project := 'example'
    let $model := 'synopsx.models.tei'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'getBiblioList'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    (: let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, 'home.xhtml') :)
    let $data := synopsx.models.tei:getBiblStructList($queryParams)
    let $layout  := 'inc_blogListSerif.xhtml'
    let $pattern := 'inc_blogArticleSerif.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
           synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, $pattern) (: give $data instead of $queryParams:)
};

(:~
 : this crad resource function 
 : $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/corpus/list/html")
  %restxq:query-param("pattern", "{$pattern}")
function corpusListHtml($pattern as xs:string?) {
    let $project := 'example'
    let $model := 'synopsx.models.tei'
    let $queryParams := map {
      'project' : $project,
      'dbName' : 'example', (: todo synopsx.lib.commons:getDbByProject($project) :)
      'model' : $model, (: todo synopsx.lib.commons:getModelByProject($project, $model) :)
      'dataType' : 'getCorpusList'
    }
    let $outputParams := map {'lang' : 'fr'} (: specify an xslt mode and other kind of option :)
    (: let $layout  := synopsx.lib.commons:getLayoutPath($queryParams, 'home.xhtml') :)
    let $data := synopsx.models.tei:getCorpusList($queryParams)
    let $layout  := 'inc_blogListSerif.xhtml'
    let $pattern := 'inc_blogArticleSerif.xhtml'
    return (: synopsx.lib.commons:main($queryParams, $outputParams, $layout) :)
           synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams, $layout, $pattern) (: give $data instead of $queryParams:)
};

