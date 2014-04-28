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
declare namespace db = 'http://basex.org/modules/db';
declare namespace xslt="http://basex.org/modules/xslt";
declare namespace xf="http://www.w3.org/2002/xforms";


import module namespace synopsx_html = 'http://ahn.ens-lyon.fr/synopsx_html' at 'synopsx_html.xqm';
import module namespace ahn = 'http://ahn.ens-lyon.fr/ahn' at 'ahn.xqm';
import module namespace ahn_commons_html = 'http://ahn.ens-lyon.fr/ahn_commons_html' at 'ahn_commons_html.xqm';
import module namespace desanti = 'http://ahn.ens-lyon.fr/desanti' at 'desanti.xqm';



(: import module namespace synodes = 'http://ahn.ens-lyon.fr/synodes' at 'synodes.xqm'; :)

(: 
this function checks if the specified output type has been assigned to a specific namespace for this project
this information stands in the config.xml file
:)
declare function synopsx:get_namespace($project_name, $output_type){
  string(db:open('config')//*[@name=$project_name]//output[1]/@value)
};


(: This function checks whether there is a customization of the generic-templating function. 
By default, synopsX function is called. :)
declare function synopsx:function-lookup($function_name, $project_name, $output_type){
  (:TODO : make the inheritage process recursive :)
  
  let $function := 
  if(db:exists($project_name)) then
  
  
  
        let $ns := synopsx:get_namespace($project_name,$output_type)
        
   
        let $specific := if($ns = "") then () else function-lookup(xs:QName($ns || ":" || $function_name),1)
        (: Check if the module declares a parent module :)
        let $parent_module := string(db:open('config')//*[@name=$project_name]//parent[1]/@value)
        (:let $parent_module := string(db:open("config",$project_name||".xml")//*[@name="parent_module"][1]/@value):)
        (: Checks if the declared parent module has a customization of the generic-templating function :)
        let $parent := if ($parent_module = "") then ()
                else function-lookup(xs:QName(synopsx:get_namespace($parent_module,$output_type)|| ":" || $function_name),1)
        let $generic := function-lookup(xs:QName(synopsx:get_namespace("synopsx",$output_type) ||":" || $function_name),1)
  
        let $f :=
            if (not(empty($specific))) then $specific
            else if (not(empty($parent))) then $parent
            else if  (not(empty($generic))) then  $generic
            else function-lookup(xs:QName("synopsx_html:notFound"),1)
        return $f
        
     
     
     
     
     else function-lookup(xs:QName("synopsx:no-database"),1)
     
     return $function
};

declare function synopsx:no-database($params) {
	<html>
	<head><title>Base {map:get($params,"project")} not found</title></head>
	<body>
	   <header>SynopsX</header>
	   <p>Il n'y a pas de base de donnée associée à "{map:get($params,"project")}"
	   <br/>{map:get($params,"dataType")}
	   <br/>{map:get($params,"value")}
	   <br/>{map:get($params,"option")}
	   </p>
	   <p>You have to <a href="/{map:get($params,"project")}/create-database">create the database</a> first.
	   <br/> <a href="/{map:get($params,"project")}/config">configuer {map:get($params,"project")}</a></p>
	   <footer>Synopsx vous est proposé par : Atelier des Humanités Numériques - ENS de Lyon</footer>
	</body>
	</html>
};



declare %restxq:path("{$project_name}/create-database/")
        %output:method("xml")
          %output:omit-xml-declaration("yes")
 updating function synopsx:create-database($project_name) {

(if(db:exists("config")) then () else db:create("config"),
            db:output(<restxq:redirect>{$project_name}/config/</restxq:redirect>))
     
};

declare %restxq:path("synopsx/config/{$project_name}")
        %output:method("xml")
          %output:omit-xml-declaration("yes")
updating function synopsx:db-config($project_name) { 
let $config := <configuration name="{$project_name}">
<parent value="synopsx"/>
<ouput name="html" value="synopsx_html"/>
<output name="oai" value="synopsx_oai"/>
<head/>
</configuration>
 return (db:add("config", $config, $project_name||".xml"),
  db:output(<restxq:redirect>/{$project_name}</restxq:redirect>))
};

declare function synopsx:db-exists() { 
let $html := (
  <?xml-stylesheet href="/static/xsltforms/xsltforms.xsl" type="text/xsl"?>,
<?css-conversion no?>,
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
  <head>
    <title>AHN XForms Demo</title>
    <link rel="stylesheet" type="text/css" href="http://ahn-basex.cbp.ens-lyon.fr:8984/static/style.css" />

    <!-- XForms data models -->
    <xf:model>
      <xf:instance>
        <track xmlns="">
          <metadata>
            <title>Like A Rolling Stone</title>
            <artist>Bob Dylan</artist>
            <date>1965-06-21</date>
            <genre>Folk</genre>
          </metadata>
        </track>
      </xf:instance>
      <xf:bind id="_date" nodeset="//date" type="xs:date"/>
    </xf:model>
  </head>

  <body>
    <div class="right">
      <img src="basex.svg" width="96" />
    </div>
    <h2>SynopsX - Configuration d'une collection (à faire !!!)</h2>
    <ul>
      <li> In this example, the XForms model is defined in the
        <code>head</code> section of the XML document.</li>
      <li> The XForms model consists of an <b>instance</b> and a <b>binding</b>.</li>
      <li> The instance contains the data, and the binding specifies the type
        of elements (in this case the <code>date</code> element).</li>
    </ul>

    <h3>XForm Widgets <small> – coupled to and synchronized with XML Data Model</small></h3>
    <ul>
      <li> Whenever you modify data in the edit components, the XML data model will
        be updated, and all other output and input components will reflect the changes.</li>
      <li> XForms also cares about type conversion: as the <code>date</code>
      element is of type <code>xs:date</code>: a date picker is offered.</li>
    </ul>

    <div>Below, three different views on the XForms model are supplied. Please open the source
      view of this HTML document to see how the input and output fields are specified.</div>
    <table width='100%'>
      <tr>
        <td width='30%'>
          <h4>Input Form</h4>
          <table>
            <tr>
              <td>Title:</td>
              <td><xf:input class="input-medium" ref="/track/metadata/title" incremental="true"/></td>
            </tr>
            <tr>
              <td>Artist:</td>
              <td><xf:input class="input-medium" ref="//artist" incremental="true"/></td>
            </tr>
            <tr>
              <td>Date:</td>
              <td><xf:input bind="_date"/></td>
            </tr>
            <tr>
              <td>Genre:</td>
              <td>
                <xf:select1 ref="//genre" appearance="minimal" incremental="true">
                  <xf:item>
                    <xf:label>Classic Rock</xf:label>
                    <xf:value>Classic Rock</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Folk</xf:label>
                    <xf:value>Folk</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Metal</xf:label>
                    <xf:value>Metal</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Gospel</xf:label>
                    <xf:value>Gospel</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Instrumental</xf:label>
                    <xf:value>Instrumental</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Soul</xf:label>
                    <xf:value>Soul</xf:value>
                  </xf:item>
                  <xf:item>
                    <xf:label>Pop</xf:label>
                    <xf:value>Pop</xf:value>
                  </xf:item>
                </xf:select1>
              </td>
            </tr>
          </table>
        </td>
        <td width='30%'>
          <h4>Output Form</h4>
          <table>
            <tr>
              <td>Artist:</td>
              <td><xf:output ref="//artist"/></td>
            </tr>
            <tr>
              <td>Title:</td>
              <td><xf:output ref="//title"/></td>
            </tr>
            <tr>
              <td>Date:</td>
              <td><xf:output ref="//date"/></td>
            </tr>
            <tr>
              <td>Genre:</td>
              <td><xf:output ref="//genre"/></td>
            </tr>
          </table>
        </td>
        <td width='40%'>
          <h4>XML Data Model</h4>
          <pre>
            <xf:output value="serialize(., 'yes')"/>
          </pre>
        </td>
      </tr>
    </table>
  </body>
</html>)
(:return xslt:transform($html, "http://ahn-basex.cbp.ens-lyon.fr:8984/static/xsltforms/xsltforms.xsl"):)
return $html
};

