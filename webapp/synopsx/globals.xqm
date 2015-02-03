xquery version '3.0' ;
module namespace G = 'synopsx.globals';
(:~
 : This module gives the globals variables for SynopsX
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
 :)
(: Webapp directory:)
declare variable $G:HOME := file:base-dir();

declare variable $G:SYNOPSX_DIR := substring-before(file:base-dir(), 'webapp/synopsx') || 'webapp/';


(: 
declare variable $G:_RESTXQ := $G:HOME || '_restxq/';
declare variable $G:MODELS :=  $G:HOME || 'models/';
declare variable $G:TEMPLATES :=  $G:HOME || 'templates/';
declare variable $G:MAPPINGS :=  $G:HOME || 'mappings/'; 
:)
declare variable $G:configfile := 'config.xml';

declare variable $G:WEBAPP := file:current-dir() || 'webapp/'; (: TO CHECK :)

declare variable $G:_RESTXQ := $G:SYNOPSX_DIR || '/synopsx/_restxq/';
declare variable $G:MODELS :=  $G:SYNOPSX_DIR || '/synopsx/models/';
declare variable $G:TEMPLATES :=  $G:SYNOPSX_DIR || '/synopsx/templates/';
declare variable $G:VIEWS :=  $G:SYNOPSX_DIR || '/synopsx/views/';
declare variable $G:PROJECTS :=  $G:SYNOPSX_DIR || '/synopsx/projects/';

(: Section dedicated to databases, specificities of a project:)
declare variable $G:DBNAME := fn:doc($G:configfile)/projects/project;
declare variable $G:BLOGDB := 'blog';
declare variable $G:PROJECTEDITIONROOT := 'http://localhost:8984/gdp/';
declare variable $G:PROJECTBLOGROOT := 'http://localhost:8984/blog/';

(:~ Status: everything ok. :)
declare variable $G:OK := '1';
(:~ Status: something failed. :)
declare variable $G:FAILED := '2';
(:~ Status: user unknown. :)
declare variable $G:USER-UNKNOWN := '4';
(:~ Status: user exists. :)
declare variable $G:USER-EXISTS := '5';

(:~ Status and error messages. To be internationalized:)
declare variable $G:STATUS := map {
  $G:OK          : 'OK',
  $G:FAILED      : 'Something failed.',
  $G:USER-UNKNOWN: 'User is unknown.',
  $G:USER-EXISTS : 'User exists.'
};

