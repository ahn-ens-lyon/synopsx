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
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ;

declare default function namespace 'synopsx.webapp' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : Default error
 : ~:~:~:~:~:~:~:~:~
 :
 : @return Only xquery error
 : These function return a 404 error page
 :)
 


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
  let $project := synopsx.lib.commons:getDefaultProject()
  return if($project = '') then
    <rest:forward>/synopsx/install</rest:forward>
  else 
   <rest:forward>/{$project}/home</rest:forward>
};

(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/{$myProject}/{$myFunction}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function home($myProject, $myFunction) {
  let $queryParams := map {
    'project' : $myProject,
    'dbName' :  $myProject,
    'model' : 'tei' ,
    'function' : $myFunction
    }
  return try {
    let $prefix := synopsx.lib.commons:getFunctionModulePrefix($queryParams, 1)
    let $data := fn:function-lookup(xs:QName($prefix || ':' || map:get($queryParams, 'function')), 1)($queryParams)
    let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data,  $outputParams)
  }catch err:*{   
      let $error := map {
          'error-code' : $err:code,
          'error-description' : $err:description
        }
      let $data := map{
        'meta' : map:merge(($error, $queryParams)),
        'content' : map{}
      }
      let $outputParams := map {
         'lang' : 'fr',
         'layout' : 'error404.xhtml',
         'pattern' : 'inc_defaultItem.xhtml'
         (: specify an xslt mode and other kind of output options :)
       }
       return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data,  $outputParams)
    }
}; 


(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/{$myProject}/{$myFunction}/{$myOtherParams = .+}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function home($myProject, $myFunction, $myOtherParams) {
  let $queryParams := map {
    'project' : $myProject,
    'dbName' :  $myProject,
    'model' : 'tei' ,
    'function' : $myFunction,
    'otherParams' : $myOtherParams
    }
  return try {
    let $prefix := synopsx.lib.commons:getFunctionModulePrefix($queryParams, 1)
    let $data := fn:function-lookup(xs:QName($prefix || ':' || map:get($queryParams, 'function')), 1)($queryParams)
    let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data,  $outputParams)
  }catch err:*{   
      let $error := map {
          'error-code' : $err:code,
          'error-description' : $err:description
        }
      let $data := map{
        'meta' : map:merge(($error, $queryParams)),
        'content' : map{}
      }
      let $outputParams := map {
         'lang' : 'fr',
         'layout' : 'error404.xhtml',
         'pattern' : 'inc_defaultItem.xhtml'
         (: specify an xslt mode and other kind of output options :)
       }
       return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data,  $outputParams)
    }
}; 

