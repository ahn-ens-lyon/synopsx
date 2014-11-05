(:~
 : Custom REST responses.
 :)
module namespace webapp = 'http://ahn.ens-lyon.fr/webapp';

import module namespace Request = "http://exquery.org/ns/request";

(:~
 : This function returns a custom response, based on the specified mime type.
 : @param  $mime  mime type
 : @return custom result
 :)
declare
  %rest:path("/mime")
  %rest:query-param("mime", "{$mime}", "application/xml")
  function webapp:custom(
    $mime  as xs:string
) {
  let $accept := trace(Request:header("Accept"), "Accept: ")
  let $accepts := tokenize($accept, ',')
  

  return if($mime = 'application/xml') then (
    webapp:xml()
  ) else if($mime = 'application/json') then (
    webapp:json()
  ) else (
    error(xs:QName("UNKNOWN"), "Not supported, bad luck")
  )
};

(:~
 : This function returns a custom response, based on the used accept header.
 : @return custom result
 :)
declare
  %rest:path("/accept")
  function webapp:custom(
) {
  let $accept := Request:header("Accept")
  let $accepts := tokenize($accept, ',') !
                    replace(., ';.*', '')
  return if($accepts = 'application/xml') then (
    webapp:xml()
  ) else if($accepts = 'application/json') then (
    webapp:json()
  ) else (
    error(xs:QName("UNKNOWN"), "Not supported, bad luck")
  )
};

(:~
 : This function returns a custom response, based on the specified mime type.
 : @param  $mime  mime type
 : @return custom result
 :)
declare
  %rest:error("UNKNOWN")
  function webapp:error(
  ) {
  <xml>Not supported, sorry</xml>
};

(:~
 : This function returns a custom response, based on the specified mime type.
 : @return custom result
 :)
declare %private function webapp:xml() {
  <xml/>
};

(:~
 : This function returns a custom response, based on the specified mime type.
 : @return custom result
 :)
declare %private function webapp:json() {
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='application/json'/>
    </output:serialization-parameters>
  </rest:response>,

  let $result := 
    <json type='object'>
      <lyon>is great</lyon>
    </json>

  return  json:serialize($result)
};
