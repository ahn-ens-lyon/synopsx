(:~
 : Open issue when implementing JAX-RS proposal for supporting quality factors:
 : Which RESTXQ function to give preference for…
 :
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/b"
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/a"
 :)
module namespace negociation = 'http://ahn.ens-lyon.fr/negociation';
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
