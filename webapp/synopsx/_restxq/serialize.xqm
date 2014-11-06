(:~
 : Custom REST responses.
 :)
module namespace serialize = 'http://ahn.ens-lyon.fr/serialize';

import module namespace Request = "http://exquery.org/ns/request";

(:~
 : This function returns a custom response, based on the specified mime type.
 : @param  $mime  mime type
 : @return custom result
 :)
declare
  %rest:path("/mime")
  %rest:query-param("mime", "{$mime}", "application/xml")
  function serialize:custom(
    $mime  as xs:string
) {
  let $accept := trace(Request:header("Accept"), "Accept: ")
  let $accepts := tokenize($accept, ',')
  

  return if($mime = 'application/xml') then (
    serialize:xml()
  ) else if($mime = 'application/json') then (
    serialize:json()
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
  function serialize:custom(
) {
  let $accept := Request:header("Accept")
  let $accepts := tokenize($accept, ',') !
                    replace(., ';.*', '')
  return if($accepts = 'application/xml') then (
    serialize:xml()
  ) else if($accepts = 'application/json') then (
    serialize:json()
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
  function serialize:error(
  ) {
  <xml>Not supported, sorry</xml>
};

(:~
 : This function returns a custom response, based on the specified mime type.
 : @return custom result
 :)
declare %private function serialize:xml() {
  <xml/>
};

(:~
 : This function returns a custom response, based on the specified mime type.
 : @return custom result
 :)
declare %private function serialize:json() {
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
