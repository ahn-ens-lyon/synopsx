xquery version "3.0" ;
module namespace synopsx.synopsx = 'synopsx.synopsx';
(:~
 : This module is the RESTXQ for SynopsX
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

import module namespace G = "synopsx.globals" at '../globals.xqm';

(: Put here all import modules declarations as needed :)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei.xqm';

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm';

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm';

(: Use a default namespace :)
declare default function namespace 'synopsx.synopsx';

(:~
 : ~:~:~:~:~:~:~:~:~
 : To be use to implement the synopsx entry points
 : Used in the last version of synopsx  
 : ~:~:~:~:~:~:~:~:~
 : These five functions analyze the given path and retrieve the data
 :
 :)


(:~
 : this resource function 
 @ todo : installation program
 :)
declare 
  %restxq:path("/synopsx/install")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("xhtml")
function install() {
  <p>TODO Synopsx install</p>
};
