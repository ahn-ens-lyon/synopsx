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
import module namespace synopsx_html = 'http://ahn.ens-lyon.fr/synopsx_html' at 'synopsx_html.xqm';

declare function graal:html($params) {
<html>
   <head>
      <title>
      {db:open(map:get($params,"project"))//tei:fileDesc/tei:titleStmt/tei:title[1]/text()}
      </title>
   </head>
<body>
    {db:open(map:get($params,"project"))//tei:w//me:norm}
</body>
</html>
};
