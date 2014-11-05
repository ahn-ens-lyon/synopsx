(:~
 : Open issue when implementing JAX-RS proposal for supporting quality factors:
 : Which RESTXQ function to give preference for…
 :
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/b"
 : -H"Accept:application/json, application/xml;q=0.001" "http://localhost:8984/path/a"
 :)
module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';

declare
  %rest:path("/path/a")
  %rest:produces("application/json")
  function webapp:a(
) {
  <a/>
};

declare
  %rest:path("/path/{$a}")
  %rest:produces("application/xml")
  function webapp:a($a) {
  <variable/>
};
