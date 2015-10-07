xquery version '3.0' ;
module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' ;

(:~
 : This module is for SynopsX models
 :
 : @version 2.0 (Constantia edition)
 : @since 2014-11-10 
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
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../lib/commons.xqm' ;

declare default function namespace "synopsx.models.synopsx";




(:~
 : this function returns a sequence of map for meta and content 
 : !! the result structure has changed to allow sorting early in mapping
 : 
 : @rmq for testing with new htmlWrapping
 :)
declare function getProjectsList($queryParams as map(*)) as map(*) {
  let $databases := db:list() 
  let $meta := map{
    'title' : 'Liste des bases de données',
    'count' : fn:string(fn:count($databases))
    }
  let $content := for $database in $databases return 
    (map:put($queryParams, "database", $database),
    getSynopsxStatus($queryParams))
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
  };

declare function getSynopsxStatus($queryParams as map(*)) as map(*) {
  let $isProject := fn:exists(synopsx.lib.commons:getDb($queryParams)//project[/dbName=$queryParams('database')])
  let $isDefault := $isProject and fn:exists(synopsx.lib.commons:getDb($queryParams)//project[@default="true"])
  return map {'database':$queryParams('database'),'isProject':fn:string($isProject), 'isDefault':fn:string($isDefault)}
};
