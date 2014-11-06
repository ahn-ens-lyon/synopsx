module namespace G = "synopsx/globals";

(: Webapp directory:)
declare variable $G:HOME := file:base-dir();
 (: file:parent(static-base-uri()) || '../../repo/synopsx/templates/html.xml'; :)
declare variable $G:WEBAPP := file:current-dir() || 'webapp/';

declare variable $G:_RESTXQ := $G:HOME || '_restxq';
declare variable $G:MODELS :=  $G:HOME || 'models';
declare variable $G:TEMPLATES :=  $G:HOME || 'templates';
declare variable $G:VIEWS :=  $G:HOME || 'views';

(:~ Status: everything ok. :)
declare variable $G:OK := '1';
(:~ Status: something failed. :)
declare variable $G:FAILED := '2';
(:~ Status: user unknown. :)
declare variable $G:USER-UNKNOWN := '4';
(:~ Status: user exists. :)
declare variable $G:USER-EXISTS := '5';

(:~ Status and error messages. :)
declare variable $G:STATUS := map {
  $G:OK          : 'OK',
  $G:FAILED      : 'Something failed.',
  $G:USER-UNKNOWN: 'User is unknown.',
  $G:USER-EXISTS : 'User exists.'
};
