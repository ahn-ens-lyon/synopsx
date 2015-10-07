xquery version '3.0' ;
module namespace synopsx.synopsx = 'synopsx.synopsx' ;

(:~
 : This module is the RESTXQ for SynopsX's installation processes
 :
 : @author synopsx team
 : @since 2014-11-10 
 : @version 2.0 (Constantia edition)
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
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace G = 'synopsx.globals' at '../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm' ;
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../models/synopsx.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ;

declare default function namespace 'synopsx.synopsx' ;

declare variable $synopsx.synopsx:project := 'synopsx';
declare variable $synopsx.synopsx:db := synopsx.lib.commons:getProjectDB($synopsx.synopsx:project) ;
(:~
 : this resource function redirects to the synopsx' home
 :)
declare 
  %restxq:path('/synopsx')
function index() {
  web:redirect(if(db:exists("synopsx"))
              then '/synopsx/home' 
              else '/synopsx/install')
};

(:~
 : this resource function is the synopsx' home
 : @todo give contents
 :)
declare 
  %restxq:path('/synopsx/install')
  %output:method('html')
  %output:html-version('5.0')
  %updating
function install(){
  db:create("synopsx", ($G:FILES||"xml/synopsx.xml",$G:FILES||"xml/config.xml"), (), map {'chop':fn:false()}),
  db:create("example", $G:FILES||"xml/sample.xml", (), map {'chop':fn:false()}),
  db:output(web:redirect("/synopsx/home"))
};

(:~
 : this resource function is the synopsx' home
 : @todo give contents
 :)
declare 
  %restxq:path('/synopsx/home')
  %output:method('html')
  %output:html-version('5.0')
function home(){
  let $queryParams := map {
    'project' : $synopsx.synopsx:project,
    'dbName' :  $synopsx.synopsx:db,
    'model' : 'tei' ,
    'function' : 'getTextById',
    'id':'synopsx'
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }  
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};

declare 
  %rest:GET
  %restxq:path('/synopsx/config')
  %output:method('html')
  %output:html-version('5.0')
function config() as element(html) {
  let $queryParams := map {
    'project' : $synopsx.synopsx:project,
    'dbName' :  $synopsx.synopsx:db,
    'model' : 'synopsx' ,
    'function' : 'getProjectsList'
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'config.xhtml',
    'pattern' : 'inc_configItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }  
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)

};

declare 
  %rest:POST
  %restxq:path('/synopsx/config')
  %output:method('html')
  %rest:query-param("project",  "{$project}")
  %output:html-version('5.0')
function config($project) as element() {
  <span>{$project}</span>
};
