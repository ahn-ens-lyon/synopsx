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

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ;

declare default function namespace 'synopsx.synopsx' ;

declare variable $synopsx.synopsx:syn := 'synopsx';
(:~
 : this resource function redirects to the synopsx' home
 :)
declare 
  %restxq:path('/synopsx')
function index() {
  <rest:response>
    <http:response status='303' message='See Other'>
      <http:header name='location' value='/synopsx/home'/>
    </http:response>
  </rest:response>
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
    'project' : $synopsx.synopsx:syn,
    'model' : 'lib.commons' ,
    'function' : 'getHomeContent'
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }  
 return synopsx.lib.commons:htmlDisplay($queryParams, $outputParams)
};
