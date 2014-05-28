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
    
module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx';

declare namespace  xhtml = 'http://ahn.ens-lyon.fr/xhtml';
declare namespace db = 'http://basex.org/modules/db';
declare namespace inspect = 'http://basex.org/modules/inspect';
declare namespace xslt="http://basex.org/modules/xslt";
declare namespace xf="http://www.w3.org/2002/xforms";


(:import module namespace xhtml = 'http://ahn.ens-lyon.fr/xhtml' at 'xhtml.xqm';
import module namespace oai = 'http://ahn.ens-lyon.fr/oai' at 'oai.xqm';:)

(: This function checks whether there is a customization of the generic-templating function. 
By default, synopsX function is called. :)
declare function synopsx:function-lookup($function_name, $project_name, $output_type){
 
  
  let $function := 
       
  
  
        (: Checks if the specified output type has been assigned to a specific xqm module namespace for this project.
        This information stands in the project_name.xml file in the "config" db :)
        let $ns := string(db:open('config')//*[@xml:id=$project_name]//output[@name=$output_type]/@value)
        let $specific := if($ns = '') then () else function-lookup(xs:QName($ns || ":" || $function_name),1)
       
        (:   let $uri := $ns || '.xqm'
              for $f in inspect:functions($uri)
              where local-name-from-QName(function-name($f)) = $function_name
              return $f():)
              
        (: Check if the module declares a parent module :)
        let $parent_module := string(db:open('config')//*[@xml:id=$project_name]//parent[1]/@value)
        
        (: Checks if the declared parent module has a customization of the generic-templating function :)
         (:TODO : make the inheritage process recursive :)
        let $parent := if ($parent_module = '') then ()
                else function-lookup(xs:QName(db:open('config')//*[@xml:id=$parent_module]//output[@name=$output_type]/@value || ":" || $function_name),1)
        let $generic := function-lookup(xs:QName(db:open('config')//*[@xml:id='synopsx']//output[@name=$output_type]/@value ||":" || $function_name),1)
  
        let $f :=
            if (not(empty($specific))) then $specific
            else if (not(empty($parent))) then $parent
            else if  (not(empty($generic))) then  $generic
            else function-lookup(xs:QName("xhtml:notFound"),1)
        return $f
        
     
       
     
   
     
     return $function
};



declare %restxq:path("synopsx/admin/initialize")
updating function synopsx:initialize() { 
            (if(db:exists('config')) then () else db:create('config'),
            db:output(<restxq:redirect>/synopsx/admin/config</restxq:redirect>)) 
};


declare %restxq:path("synopsx/admin/config")
        %output:method("xml")
          %output:omit-xml-declaration("yes")
updating function synopsx:db-config() { 
let $config := <configuration xml:id="synopsx">
                    <output name="xhtml" value="xhtml"/>
                    <output name="oai" value="oai"/>
               </configuration>
 return (db:add("config", $config, "synopsx.xml"),
         db:output(<restxq:redirect>/synopsx</restxq:redirect>))
};







declare %restxq:path("{$project_name}/admin/config")
        %output:method("xml")
          %output:omit-xml-declaration("yes")
updating function synopsx:db-config($project_name) { 
(if (not(db:exists($project_name))) then db:create($project_name) else (),
let $config := <configuration xml:id="{$project_name}">
                <!--
                <parent value="here the namespace of the xqm module your project inherits" />
                <output name="xhtml" value="here the namespace of your xqm module dedicated to xquery functions for xhtml "/>
                
                <output name="rdf" value="here the namespace of your xqm module dedicated to xquery functions for rdf"/>
                <output name="oai" value="here the namespace of your xqm module dedicated to xquery functions for oai"/>-->
               </configuration>
               return db:add('config', $config, $project_name ||".xml"))
};

