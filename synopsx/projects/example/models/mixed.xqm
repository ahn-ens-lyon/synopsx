xquery version "3.0" ;
module namespace example.models.mixed = 'example.models.mixed';
(:~
 : This module is for TEI models
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

import module namespace G = 'synopsx.globals' at '../../../globals.xqm'; (: import globals variables :)

declare default function namespace 'example.models.mixed'; (: This is the default namespace:)
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: Add namespaces :)

declare function  getHomeContent($queryParams) {
  'My home content'
};

declare function  getTitle($queryParams) {
  'My example project title'
};

declare function getMainPartnerLogo($queryParams) as map(*) {
  map{
    'meta' : map{},
    'content' : 
      map{
        'img' : map{
          'src' : '/static/img/logo_ENS_sm_blanc.png',
          'alt' : 'ENS de Lyon',
          'class' : 'logo'
        }
      }
  }  
  
};

declare function getEntries($queryParams) {
  (: Display EAD unitId to access TEI documents :)
  'TODO'
};



