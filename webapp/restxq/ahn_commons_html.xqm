module namespace ahn_commons_html = 'http://ahn.ens-lyon.fr/ahn_commons_html';

import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx';


declare variable $ahn_commons_html:url_base := "http://archive.desanti.huma-num.fr";
(:declare variable $ahn_commons_html:url_base := "http://basex.db.huma-num.fr";:)
declare variable $ahn_commons_html:xslt := "/static/xsl/tei2html5.xsl";
declare variable $ahn_commons_html:default_ns := "http://ahn-basex.fr/ahn_commons_html";




declare function ahn_commons_html:head($params){
  <head>
        <title>{map:get($params,"project")}</title>
        
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Kit Corpus de l'AHN. Utilise BaseX et RESTXQ" />
        <meta name="author" content="Atelier des Humanités Numériques, ENS de Lyon, France" />
        
        <!-- Bootstrap core CSS -->
        <link href="/static/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="/static/css/ahn.css" rel="stylesheet" />

        <!-- CSS spécifiques au corpus -->
        {synopsx:get-function("css",map:get($params,"project"),"xhtml")($params)}
  </head>
};



declare function ahn_commons_html:body($params){
   
  <body>
    
      {
      synopsx:get-function("navbar",map:get($params,"project"),"xhtml")($params),
      synopsx:get-function("container",map:get($params,"project"),"xhtml")($params),
      synopsx:get-function("footer",map:get($params,"project"),"xhtml")($params),
      synopsx:get-function("scripts_js",map:get($params,"project"),"xhtml")($params)
      }
    
  </body>
};


declare function ahn_commons_html:navbar($params){
  <div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
    <!--le .navbar du bootstrap remplace nos anciens styles #ahn-nav et .ahn-nav--> 
      <div class="navbar container">
        
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="/desanti/a-propos">à propos</a></li>
            <li><a href="/desanti/mentions-legales">mentions légales</a></li>
            <li><a href="/desanti/credits">crédits</a></li>
            <li><a href="/desanti/contacts">contacts</a></li>
          </ul>
        </div> <!-- /.nav-collapse --> 
      </div> <!-- /.navbar container -->  
  </div>(: <!-- /.navbar navbar-fixed-top navbar-inverse--> :)
};


declare function ahn_commons_html:container($params) {
  <div class="container">
      <div class="row row-offcanvas">
        <div class="col-xs-12 col-sm-12">
          {synopsx:get-function("header",map:get($params,"project"),"xhtml")($params)} 
         
          {synopsx:get-function("primary-nav",map:get($params,"project"),"xhtml")($params)}
          {synopsx:get-function("content",map:get($params,"project"),"xhtml")($params)}
         
        </div>
      </div> <!-- /.container --> 
  </div>

};

declare function ahn_commons_html:header($params){
          <header id="header">
              <div id="search-container">
                  <form id="simple-search" action="/items/browse" method="get">
                  
                  <fieldset>
                    <input type="text" name="search" id="search" value="" class="textinput" />
                    <input type="submit" name="submit_search" id="submit_search" value="Search" />
                    </fieldset>
                  </form>
                  <a href="/items/advanced-search">Advanced Search</a>
              </div> <!-- end search --> 
              <div id="site-title">
                  <a href="/"><img src="/static/img/logo_AHN.png" title="Kit AHN"/></a>
                  <div id="logo-partenaire-principal"> 
                    <a href="http://www.ens-lyon.eu" title="Vers le site de l'ENS de Lyon" target="_blank">
                    <img src="http://morand.ens-lyon.fr/archive/theme_uploads/logo_Partenaire.png" width="121" height="41" alt="Logo du partenaire principal"/>
                    </a>
                  </div>
             </div>
           {synopsx:get-function("header-image",map:get($params,"project"),"xhtml")($params)}
          </header>  (: <!-- /#header --> :)
            
};

declare function ahn_commons_html:header-image($params){
	<div id="header-image">
            <img src="/static/img/bandeau_AHN.png" />
          </div> 
};




declare function ahn_commons_html:content($params){
  <div id="content"  class="col-8 col-sm-8 col-lg-8 row row-offcanvas">     
      		{synopsx:get-function("secondary",map:get($params,"project"),"xhtml")($params)}
      		{synopsx:get-function("primary",map:get($params,"project"),"xhtml")($params)}
      	
  </div>    
};


declare function ahn_commons_html:primary-nav($params){
    <div class="container navbar" id="primary-nav">
    <ul class="navigation">
      
      <li class="nav-accueil active"><a href="/#kit">Le kit</a></li>
      <li class="nav-entree"><a href="/#download">Téléchargement</a></li>
      <li class="nav-entree"><a href="/#doc">Documentation</a></li>
      <li class="nav-entree"><a href="/#team">L’équipe</a></li>
    </ul>
  </div>(: <!-- end primary-nav --> :)
};

declare function ahn_commons_html:secondary($params){
  
          <div id="secondary" class="col-4 col-sm-4 col-lg-4">
            <ul class="navigation">
              <div class="well sidebar-nav">
                <h2>Activités AHN</h2>
                  <ul class="nav">
                    <li class="active"><a href="/ahn">Identité visuelle</a></li>
                    <li><a href="/" title="Intégration HTML5 responsive design en cours">Kit Corpus AHN</a></li>
                    <li><a href="http://www.mutec-shs.fr">MutEC</a></li>
                  </ul>
                <h2>Sites et corpus qui testent le kit</h2>
                  <ul class="nav">
                  	<li><a href="/ahn">Le site de l’AHN</a></li>
                  	
                    <li><a href="/bvm">Bibliothèque Virtuelle Montesquieu</a></li>
                    <li><a href="/desanti">Archive numérique Desanti</a></li>
                    
                    <li><a href="/hyperdonat">Hyperdonat</a></li>
                    <li><a href="/hyperprince">Hyperprince</a></li>
                    
                    <li><a href="/morand">Le roman des Morand</a></li>
                  </ul> <!--/.end nav--> 
              </div><!--/.well -->
            </ul><!--/navigation-->
          <!--secondary--> </div>         
};

declare function ahn_commons_html:primary($params){
          <div id="primary">
          
            <h1>Bienvenue sur le kit Corpus AHN</h1>
            <p>Vous souhaiez mettre en ligne un corpus transcrit en XML (TEI) : ceci est l'outil que vous attendiez. Un kit clef en main qui pioche dans votre base de données XML grâce à baseX et qui produit du HTML5 web-responsive...? Il ne vous reste plus qu'à l'adapter!</p>
            
        
            <div class="row">
              <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Deux colonnes</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
              </div><!--/span-->
              <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Deux colonnes</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
              </div><!--/span-->
            </div><!--/row-->
              <div class="row">
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Trois colonnes</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Trois colonnes</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Trois colonnes</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
              </div>
              <div class="row">
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Heading</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Heading</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
                <div class="col-4 col-sm-4 col-lg-4">
                  <h2>Heading</h2>
                  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                  <p><a class="btn btn-default" href="#">View details &#187;</a></p>
                </div><!--/span-->
            </div><!--/row-->
           <!--/primary--> </div>
};

declare function ahn_commons_html:footer($params){
    <footer id="footer">

        <ul class="footer-logo">
          
          <li><img src="/static/img/logo_AHN_sm_blanc.png" alt="Logo de l’AHN"/></li> 
          <li><img src="/static/img/logo_ENS_sm_blanc.png" alt="Logo de l’ENS de Lyon"/></li>
          
        </ul>
            
        <div id="footer-text">
         Ce site a été réalisé grâce à <a href="http://basex.org/" title="BaseX. The XML Database.">BaseX</a> et au thème AHN.               
        </div>
    
    </footer>
  };

 
  declare function ahn_commons_html:css($params){
  <div id="css">
        <link href="/static/css/ahn.css" rel="stylesheet" />
  </div>
  };

