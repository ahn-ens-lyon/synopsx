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

import module namespace ahn_commons = 'http://ahn.ens-lyon.fr/ahn_commons' at 'ahn_commons.xqm';
import module namespace desanti = 'http://ahn.ens-lyon.fr/desanti' at 'desanti.xqm';

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


declare function synopsx:notFound($params) {
<html>
<head><title>Base {map:get($params,"project")} not found</title></head>
<body>
<header>SynopsX</header>
<br/>Nous n avons pas trouvé ce que vous cherchez...
Les paramètres donnés étaient :
<br/>{map:get($params,"project")}
<br/>{map:get($params,"dataType")}
<br/>{map:get($params,"value")}
<br/>{map:get($params,"option")}
<p>Voulez-vous préciser la configuration de {map:get($params,"project")} ?
<br/> <a href="/{map:get($params,"project")}/config">configuer {map:get($params,"project")}</a></p>
<footer>Synopsx vous est proposé par : Atelier des Humanités Numériques - ENS de Lyon</footer>
</body>
</html>
};




(: Default html root tag html :)
declare function synopsx:html($params){ 
    <html lang="fre">
      { synopsx:function-lookup("head",map:get($params,"project"),"xhtml")($params)
       ,synopsx:function-lookup("body",map:get($params,"project"),"xhtml")($params)
      }
   </html>
};



(: Default html head tag :)
declare function synopsx:head($params){
  <head>
        <title>{map:get($params,"project")}</title>
        
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Synopsx AHN. Utilise BaseX et RESTXQ" />
        <meta name="author" content="Atelier des Humanités Numériques, ENS de Lyon, France" />
        
        <!-- Bootstrap core CSS -->
        <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet" />
      
        <!-- CSS spécifiques au corpus -->
        {synopsx:function-lookup("css",map:get($params,"project"),"xhtml")($params)}
  </head>
};

 declare function synopsx:css($params){
  
        (: Add your own css in the /static directory of your webapp and call it here :)
        (:<link href="/static/css/mycss.css" rel="stylesheet" />:)
        ()
  
  };

(: Default html body tag :)
declare function synopsx:body($params){
       <body>
             {synopsx:function-lookup("header",map:get($params,"project"),"xhtml")($params),
             synopsx:function-lookup("container",map:get($params,"project"),"xhtml")($params),
             synopsx:function-lookup("footer",map:get($params,"project"),"xhtml")($params),
           synopsx:function-lookup("scripts_js",map:get($params,"project"),"xhtml")($params)}
        </body>
};



(: Default xhtml header :)
declare function synopsx:header($params){
   let $project := map:get($params,"project")
   return switch ($project)
   
   case "synopsx" return
   <header>
 <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
                    <div class="navbar container">{$project}</div>
                </div>
 
        <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>Welcome to {map:get($params,"project")} !</h1>
        <p>Synopsx helps Digital Humanists to manage, process and publish their xml data. Start customising it now !</p>
        <p><a class="btn btn-primary btn-lg" role="button">Learn more >>></a></p>
      </div>
    </div>
    </header>
    default return 
     <header>
 <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
                    <div class="navbar container">{$project}</div>
                </div>
 
        <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>Welcome to {map:get($params,"project")} !</h1>
        <p>Congratulations, this is your webapp homepage  !</p>
        <p><a class="btn btn-primary btn-lg" role="button">Learn more >>></a></p>
      </div>
    </div>
    </header>
};   






(: Default html container tag :)
declare function synopsx:container($params){
   let $project := map:get($params,"project")
   return switch ($project)
   case "synopsx" return
      <div id="container" class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
          <h2>Do your data live in the XML world ?</h2>
          <p>Stay inside the XML world at each step of your project and stop mixing technologies. </p>
          <p>Let your xml structures drive the design of your websites and webservices.</p>
          <p><a class="btn btn-default" href="#" role="button">View details >>></a></p>
        </div>
        <div class="col-md-4">
          <h2>How does it work ?</h2>
          <p>SynopsX is based on the native XML database <a href="http://basex.org" title="BaseX native XML database"><img src="http://basex.org/fileadmin/styles/07_layouts_grids/css/images/BaseX-Logo.png"/></a></p>
          <p><a class="btn btn-default" href="#" role="button">View details >>></a></p>
        </div>
        <div class="col-md-4">
          <h2>Who makes it ?</h2>
          <p>AHN</p>
          <p>Partenaire</p>
          <p>Partenaire</p>
          <p><a class="btn btn-default" href="#" role="button">View details >>></a></p>
        </div>
      </div>
     <!-- /container --></div>
    
    default return 
     <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
        <h1>1</h1>
          <h2>Manage your XML database</h2>
          <p>Add XML files, user... Set your database options. <a href="http://docs.basex.org/wiki/Commands" title="BaseX commands doc">Need help ?</a></p>
          <p><a class="btn btn-default" href="/{$project}/admin/db" role="button">Proceed >>></a></p>
        </div>

        <div class="col-md-4">
        <h1>2</h1>
          <h2>Customize your webapp templates with RESTXQ</h2>
          <p>Create new restxq templates and declare them in your config file. <a href="http://docs.basex.org/wiki/RESTXQ" title="BaseX RESTXQ doc">Need help ?</a></p>
          <p><a class="btn btn-default" href="/{$project}/admin/config" role="button">Proceed >>></a></p>
        </div>
        <div class="col-md-4">
        <h1>3</h1>
          <h2>Can we help ? Get third parties templates</h2>
          <p>AHN libs</p>
          <p>Partenaire libs</p>
          <p>Partenaire libs</p>
          
        </div>
      </div>
    <!-- /container --> </div>
};





(: Default xhtml footer :)
declare function synopsx:footer($params){
  <footer>
        <hr/>
        <div class="container">© Atelier des Humanités Numériques, ENS de Lyon, 2014</div>
  </footer>
};


  declare function synopsx:scripts_js($params){
  
  (<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>,
    <script src="http://getbootstrap.com/dist/js/bootstrap.min.js"></script>)
  };
  
 
 
   