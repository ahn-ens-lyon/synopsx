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

<<<<<<< HEAD
import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx' at 'synopsx.xqm';

=======
import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx';
>>>>>>> c89405c1311497895c480d0e8c13f70a821d6844

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



(: Main function, decides what to do wether config data and database already exist or not for this project :)
declare function webapp:main($params){
<<<<<<< HEAD
    let $project := map:get($params,"project")
    return
   
    if(db:exists('config')) then synopsx:function-lookup("html",$project,"xhtml")($params) 
    
    else <html>
            {synopsx:head($params)}
            <body>
            {synopsx:header($params)}
            <div id="container" class="container">
            <a href="/synopsx/admin/initialize">Please initialize Synopsx</a>{synopsx:footer($params)}
            </div>
            </body>
            </html> 
    
=======
>>>>>>> c89405c1311497895c480d0e8c13f70a821d6844
    
   synopsx:get-function("html",$params,"xhtml")($params)
 
};



