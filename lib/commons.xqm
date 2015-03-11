xquery version '3.0' ;
module namespace synopsx.lib.commons = 'synopsx.lib.commons' ;

(:~
 : This module is a function library for SynopsX
 :
 : @version 2.0 (Constantia edition)
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
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace G = "synopsx.globals" at '../globals.xqm';
import module namespace synopsx.mappings.htmlWrapping = "synopsx.mappings.htmlWrapping" at '../mappings/htmlWrapping.xqm';

declare default function namespace 'synopsx.lib.commons' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : Function library
 : ~:~:~:~:~:~:~:~:~
 :)

declare function getProjectDB($project as xs:string) as xs:string {
  fn:doc($G:CONFIGFILE)//config/projects/project[resourceName/text() = $project]/dbName/text()
};

declare function getDefaultProject() as xs:string {
    if(file:exists($G:CONFIGFILE)) then
      if(fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()) then 
        fn:doc($G:CONFIGFILE)//project[@default="true"]/resourceName/text()
      else fn:doc($G:CONFIGFILE)//project[1]/resourceName/text()
    else ''
};

(:~
 : this function built the layout path based on the project hierarchy
 :
 : @param $queryParams the query params
 : @param $template the template name.extension
 : @return a path 
 :)
declare function getLayoutPath($queryParams as map(*), $template as xs:string?) as xs:string { 
  let $path := $G:WORKSPACE || map:get($queryParams, 'project') || '/templates/' || $template
  return 
    if (file:exists($path)) 
    then $path
    else if (file:exists($G:TEMPLATES || $template)) then $G:TEMPLATES || $template
    else 
        (: Test if we are looking for a main layout or a 'inc_*' layout:)
        let $prefix := if (fn:contains($template, '_')) then fn:substring-before($template, '_') || '_' else ''
        return $G:TEMPLATES || $prefix || 'inc_defaultList.xhtml'
};

(:~
 : this function checks if the function exists in the given module
 :
 : @param module uri and function name
 : @return a function QName
 :
 : @rmq the modules namespaces should be imported in the restxq
 : @todo give a default function or an error
 :)
declare function getModelFunction($queryParams as map(*)) as xs:QName {
  let $projectName :=  map:get($queryParams, 'project')
  let $modelName := map:get($queryParams, 'model')
  let $functionName := map:get($queryParams, 'function')
  let $uri := $projectName || '.models.' || $modelName
  let $context := inspect:context()/function
  let $function := inspect:context()//function[@name = $functionName]
  return if ($function/@uri = $uri) 
    then fn:QName($function/@uri, $function/@name)
    else if ($function/@uri = 'synopsx.models.' || $modelName) 
      then fn:QName($function/@uri, $function/@name)
      else   fn:QName('synopsx.models.mixed', 'notFound') (: give default or error :)
};

(:~
 : this function checks if the given function exists in the given module with the given arity
 : without inspecting functions (i.e. without compiling the module)
 :
 : @param $queryParams the query params
 : @param $arity and arity to retrieve the function
 : @return the function name as a string or an empty string
 :
 : @todo return error messages
 :)
declare function getFunctionPrefix($queryParams as map(*), $arity as xs:integer) as xs:string {
  let $project :=  map:get($queryParams, 'project')
  let $fileName := map:get($queryParams, 'model') || '.xqm'
  let $projectModelPath := $G:WORKSPACE || $project || '/models/'
  let $functionName := map:get($queryParams, 'function') 
  let $customizedFunction := 
    if (file:exists($projectModelPath || $fileName)) then 
      let $xml := inspect:module($projectModelPath || $fileName)
      (: if the function exists in this module, returns the module name :)
      return if($xml/function[@name = fn:string($xml/@prefix) || ':' || $functionName][fn:count(./argument) = $arity]) then 
        fn:string($xml/function[@name = fn:string($xml/@prefix) || ':' || $functionName][fn:count(./argument) = $arity]/ancestor::module/@prefix)
        else ''
    else ''
    return if ($customizedFunction = '') then                                     
              if (file:exists($G:MODELS || $fileName)) then 
                let $xml := inspect:module($G:MODELS || $fileName)
                (: if the function exists in this module, returns the module name :)
                return fn:string($xml/function[@name = fn:string($xml/@prefix) || ':' || $functionName][fn:count(./argument) = $arity]/ancestor::module/@prefix)          
              else ''  
           else $customizedFunction
};

(:~
 : this function shows the errors
 :
 : @param $queryParams the query params
 : @param $err:code the error code
 : @param $err:additional the error description, module, line and column numbers, error message
 : @return send a map with the errors messages to the wrapperNew
 :)
declare function error($queryParams, $err:code, $err:additional) {
  let $error := map {
    'title' : 'An error occured :(',
    'error code' : fn:string($err:code),
    'error stack trace' : fn:string($err:additional)
    }
  let $data := map{
    'meta' : $error,
    'content' : $queryParams
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'error404.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data,  $outputParams)
};

(:~
 : this function built document node with dbName and path
 :
 : @param $queryParams the query params
 : @return one or several document-node according to dbName and path
 :)
declare function getDb($queryParams as map(*)) as document-node()* {
  let $dbName := map:get($queryParams, 'dbName')
  let $path := map:get($queryParams, 'path')
  return
    if ($path)
    then db:open($dbName, $path)
    else db:open($dbName)
};



