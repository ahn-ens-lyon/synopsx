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
import module namespace monModule = 'monModule'; 

declare function graal:frequencies($params){
  (:for $text in distinct-values(db:open(map:get($params,"project"))//tei:body//tei:w/string-join(text(),''))
  let $count := count(db:open(map:get($params,"project"))//tei:body//tei:w[string-join(text(),'') contains text {$text}])
:)
for $w in (db:open(map:get($params,"project"))//tei:body//tei:w)
let $text := string-join($w/text(),'')
group by $text
let $count := sum(count($w/@xml:id))
order by $count descending, $text ascending
return 
<div id="content" type="frequences">
<ul>
<li> {$text} : {$count}</li>
</ul>
</div>
};


declare function graal:pagine($params){
let $section :=map:get($params, "dataType")
let $number := number(map:get($params, "value"))
let $nResults := count(db:open(map:get($params,"project"))//tei:body//*[local-name() = $section])

return 
<div id="content" type="{$section}">
<div>
<p> {$nResults} resultats trouves </p>
{(if ($number > 1)
then
<a href="/{map:get($params, 'project')}/{$section}/{$number -1}">precedent</a>
else ()),
(if ($number < $nResults)
then
<a href="/{map:get($params, 'project')}/{$section}/{$number +1}">suivant</a>
else ())}
</div>


{(db:open(map:get($params,"project"))//tei:body//*[local-name() = $section])[$number]}

</div>
};


declare function graal:content($params) {

switch (map:get($params, 'dataType'))

case 'home' return
<div id="content" type='all'>
<p>Lecture par <a href="/graal/p/1"> paragraphe</a></p>
<p>Lecture par <a href="/graal/s/1"> phrase</a></p>
</div>

case 'frequences' return
 graal:frequencies($params)

default return

     graal:pagine($params)
};


declare function graal:css($params){
  <div id="css">
        <link href="http://txm.ish-lyon.cnrs.fr/txm/css/tei-graal.css" rel="stylesheet" />
  </div>
  };
