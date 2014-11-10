xquery version "3.0" ;
module namespace serialize = 'http://ahn.ens-lyon.fr/serialize';
(:~
 : This module is a demo file for Custom  REST responses (serialization)
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
