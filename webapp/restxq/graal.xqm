(:
This file is part of SynopsX.
    created by AHN team (http://ahn.ens-lyon.fr)
    release 0.1, 2014-01-28

SynopsX is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

SynopsX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with SynopsX.
If not, see <http://www.gnu.org/licenses/>
:)

module namespace graal = 'http://ahn.ens-lyon.fr/graal';
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace me = "http://www.menota.org/ns/1.0";
import module namespace synopsx = 'http://ahn.ens-lyon.fr/synopsx' at 'synopsx.xqm';


declare function graal:paragraph($params){
<div id='content' type='paragraph'>
{let $paragraph := db:open(map:get($params,"project"))//tei:p[@n=map:get($params,"value")]
return 
$paragraph
}
</div>

};


declare function graal:content($params) {
if (map:contains($params, 'dataType'))
then 
graal:paragraph($params)
else

<div id="content" type='all'>
    {let $text := db:open(map:get($params,"project"))//tei:text
for $p in $text//tei:p 
return 
<p>
{$p}
</p>

}
</div>
};


  declare function graal:css($params){
  <div id="css">
        <link href="http://txm.ish-lyon.cnrs.fr/txm/css/tei-graal.css" rel="stylesheet" />
  </div>
  };
