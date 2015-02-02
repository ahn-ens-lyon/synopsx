(:~
 : Global constants.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace G = 'dba/global';

import module namespace Session = 'http://basex.org/modules/session';

(:~ Login error code. :)
declare variable $G:LOGIN-ERROR := xs:QName("basex:login");

(:~ Name of server session. :)
declare variable $G:SESSION-KEY := "session";
(:~ Remote port. :)
declare variable $G:SESSION-REMOTE := "remote";
(:~ Current session. :)
declare variable $G:SESSION := Session:get($G:SESSION-KEY);
(:~ Remote settings. :)
declare variable $G:REMOTE := Session:get($G:SESSION-REMOTE);

(:~ Configuration file. :)
declare variable $G:CONFIG-XML := file:parent(static-base-uri()) || 'config.xml';
(:~ Configuration. :)
declare %private variable $G:CONFIG := map:new(
  doc('config.xml')/config/(user[name = $G:SESSION], default)/* ! map { name(): string() }
);

(:~ Language. :)
declare variable $G:LANGUAGE := G:string('language');

(:~ Maximum length of XML characters (currently: 1mb). :)
declare variable $G:MAX-CHARS := G:integer('maxchars');
(:~ Maximum number of table entries (currently: 1000 rows). :)
declare variable $G:MAX-ROWS := G:integer('maxrows');
(:~ Query timeout. :)
declare variable $G:TIMEOUT := G:integer('timeout');
(:~ Maximal memory consumption. :)
declare variable $G:MEMORY := G:integer('memory');
(:~ Permission when running queries. :)
declare variable $G:PERMISSION := G:string('permission');

(:~ Year one. :)
declare variable $G:YEAR-ONE := xs:dateTime('0001-01-01T01:01:01');
(:~ Time one. :)
declare variable $G:TIME-ZERO := xs:time('00:00:00');

(:~
 : Returns a configuration string for the specified key.
 : @param  $key key
 : @return text
 :)
declare %private function G:string($key as xs:string) as xs:string {
  let $text := $G:CONFIG($key)
  return if($text) then $text else error((), 'Missing in config.xml: "' || $text || '"')
};

(:~
 : Returns a configuration number for the specified key.
 : @param  $key key
 : @return text
 :)
declare %private function G:integer($key as xs:string) as xs:integer {
  xs:integer(G:string($key))
};
