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
    
module namespace synopsx_html = 'http://ahn.ens-lyon.fr/synopsx_html';
import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx' at 'synopsx.xqm';

(: webapp root url :)
declare variable $synopsx_html:url_base := "http://xml-basex.cbp.ens-lyon.fr:8984";
(: default namespace :)
declare variable $synopsx_html:default_ns := "http://ahn-basex.fr/";
(: default xslt stylesheet :)
declare variable $synopsx_html:xslt := "/static/xsl/tei2html5.xsl";



declare function synopsx_html:notFound($params) {
	<html>
	<head><title>Base {map:get($params,"project")} not found</title></head>
	<body>
	   <header>SynopsX</header>
	   <br/>Nous n'avons pas trouvé ce que vous cherchez...
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

declare %restxq:path("")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function synopsx_html:index() {
  let $params := map {
      "project" := "synopsx",
      "dataType" := "home"
    } 
    
    
    return synopsx:function-lookup("html",map:get($params,"project"),"html")($params) 
  
};



declare %restxq:path("{$project}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function synopsx_html:index($project) {
  let $params := map {
      "project" := $project,
      "dataType" := "home"
    }                  
    return 
    (:synopsx_html:html($params):)
    synopsx:function-lookup("html",map:get($params,"project"),"html")($params)
};



declare %restxq:path("{$project}/{$dataType}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function synopsx_html:index($project, $dataType) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType
      }
    return 
    (:synopsx_html:html($params):)
    synopsx:function-lookup("html",map:get($params,"project"),"html")($params)
};

declare %restxq:path("{$project}/{$dataType}/{$value}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function synopsx_html:index($project, $dataType, $value) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType,
      "value" := $value
      }
    return
    (:synopsx_html:html($params):)
    synopsx:function-lookup("html",map:get($params,"project"),"html")($params)
};

declare %restxq:path("{$project}/{$dataType}/{$value}/{$option}")
        %output:method("xhtml")
        %output:omit-xml-declaration("no")
        %output:doctype-public("xhtml")
function synopsx_html:index($project, $dataType, $value, $option) {
    let $params := map {
      "project" := $project,
      "dataType" := $dataType,
      "value" := $value,
      "option" := $option
      }
    return synopsx:function-lookup("html",map:get($params,"project"),"html")($params)
}; 

declare function synopsx_html:html($params){ 
    <html lang="fre">
      { synopsx:function-lookup("head",map:get($params,"project"),"html")($params)
       ,synopsx:function-lookup("body",map:get($params,"project"),"html")($params)
      }
   </html>
};



(: Default html head :)
declare function synopsx_html:head($params){
  <head>
        <title>{map:get($params,"project")}</title>
        
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Synopsx AHN. Utilise BaseX et RESTXQ" />
        <meta name="author" content="Atelier des Humanités Numériques, ENS de Lyon, France" />
        
        <!-- Bootstrap core CSS -->
        <link href="/static/dist/css/bootstrap.min.css" rel="stylesheet" />
      
        <!-- CSS spécifiques au corpus -->
        {synopsx:function-lookup("css",map:get($params,"project"),"html")($params)}
  </head>
};


(: Default html body :)
declare function synopsx_html:body($params){
   
  <body>
       <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
                    <div class="navbar container">SynopsX</div>
                </div>
 
        <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>Welcome to SynopsX !</h1>
        <p>Synopsx helps Digital Humanists to manage, process and publish their xml data. Start customising it now !</p>
        <p><a class="btn btn-primary btn-lg" role="button">Learn more >>></a></p>
      </div>
    </div>

    <div class="container">
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

      <hr/>

      <footer>
        <p>© Atelier des Humanités Numériques, ENS de Lyon, 2014</p>
      </footer>
    </div> <!-- /container -->
        
    
    
  </body>
};


  declare function synopsx_html:scripts_js($params){
  
  (<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>,
    <script src="/static/bootstrap/js/bootstrap.min.js"></script>)
  };
  
  declare function synopsx_html:css($params){
  
        (:<link href="/static/css/mycss.css" rel="stylesheet" />:)
        ()
  
  };

