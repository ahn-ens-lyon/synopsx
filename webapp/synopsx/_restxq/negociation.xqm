xquery version "3.0" ;
module namespace negociation = 'http://ahn.ens-lyon.fr/negociation';
(:~
 : This module is a demo RESTXQ for Content negociation
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
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
 : @todo to implement
 :)
 
 (:~
 : Open issue when implementing JAX-RS proposal for supporting quality factors:
 : Which RESTXQ function to give preference for…
 :
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/b"
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/a"
 :)
 
declare namespace tei = 'http://www.tei-c.org/ns/1.0';


declare
  %rest:path("/path/a")
  %rest:produces("application/json")
  function negociation:a(
) {
  <a/>
};


declare
  %rest:path("/path/{$a}")
  %rest:produces("application/xml")
  function negociation:a($a) {
  <variable/>
};


(:~
 : resource function with content negociation (test)
 :)
declare %restxq:path("negociation")
         %restxq:GET
         %rest:produces("application/json")
function negociation:negociation-get(){
  db:open('gdp')//tei:head
  
};
