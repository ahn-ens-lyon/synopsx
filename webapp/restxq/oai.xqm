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


module namespace oai = 'http://ahn.ens-lyon.fr/oai';

declare default element namespace "http://www.openarchives.org/OAI/2.0/";
declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace xslt="http://basex.org/modules/xslt";
import module namespace request = "http://exquery.org/ns/request";

declare variable $oai:tei2dc := "http://ahn-basex.cbp.ens-lyon.fr:8984/static/xsl/tei2dc.xsl";
         


declare %restxq:path("{$project}/oai")
        %output:method("xml")
        %rest:query-param("verb", "{$verb}", "")
        %rest:query-param("identifier", "{$identifier}")
        %rest:query-param("metadataPrefix", "{$metadataPrefix}")
        %rest:query-param("from", "{$from}")
        %rest:query-param("until", "{$until}")
        %rest:query-param("set", "{$set}")
        %rest:query-param("resumptionToken", "{$resumptionToken}")
        %output:omit-xml-declaration("no")
function oai:index($project, $verb, $identifier, $metadataPrefix, $from, $until, $set, $resumptionToken) {
  <OAI-PMH>
      <responseDate>{fn:current-dateTime()}</responseDate>
      <request>{request:uri()}?{request:query()}</request>
      {switch ($verb) 
        case 'GetRecord'
          return oai:GetRecord($project, $identifier, $metadataPrefix)
        case 'Identify'
          return oai:Identify($project)
        case 'ListIdentifiers'
          return oai:ListIdentifiers($project, $from, $until, $metadataPrefix, $set, $resumptionToken)
        case 'ListMetadataFormats'
          return oai:ListMetadataFormats($project, $identifier)
        case 'ListRecords'
          return oai:ListRecords($project, $from, $until, $metadataPrefix, $set, $resumptionToken)
        case 'ListSets'
          return oai:ListSets($project, $resumptionToken)
        case ''
          return <error code="badVerb">No verb specified</error>
        default
          return <error code="badVerb">No such verb {$verb}</error>
      }
    </OAI-PMH>
};

declare function oai:GetRecord($project, $identifier, $metadataPrefix){
    <GetRecord>
    </GetRecord>
};

declare function oai:Identify($project){
    <Identify>
      <repositoryName>{$project}</repositoryName>
      <baseURL>{request:uri()}</baseURL>
      <protocolVersion>2.0</protocolVersion>
      <adminEmail>ahn-equipe@ens-lyon.fr</adminEmail>
      <earliestDatestamp></earliestDatestamp>
      <deletedRecord></deletedRecord>
      <granularity></granularity>
    </Identify>
};

declare function oai:ListIdentifiers($project, $from, $until, $metadataPrefix, $set, $resumptionToken){
    <ListIdentifiers>
    </ListIdentifiers>
};

declare function oai:ListMetadataFormats($project, $identifier){
    <ListMetadataFormats>
      <metadataFormat>
      <metadataPrefix>oai_dc</metadataPrefix>
      <schema>http://www.openarchives.org/OAI/2.0/oai_dc.xsd</schema>
      <metadataNamespace>http://www.openarchives.org/OAI/2.0/oai_dc/</metadataNamespace>
      </metadataFormat>
    </ListMetadataFormats>
};

declare function oai:ListRecords($project, $from, $until, $metadataPrefix, $set, $resumptionToken){
    <ListRecords>
  
    </ListRecords>
};

declare function oai:ListSets($project, $resumptionToken){
    <ListSets>
      {
        for $set in db:open($project)//*:teiCorpus 
          return 
          <set>
            <setSpec>
              {string-join($set/ancestor-or-self::*:teiCorpus/@xml:id,':')}
            </setSpec>
            <setName>
              {$set/*:teiHeader/*:fileDesc/*:titleStmt/*:title/text()}
            </setName>
            <setDescription>
              { if ($set/*:teiHeader) then
                xslt:transform($set/*:teiHeader, $oai:tei2dc)
                else ''
              }
            </setDescription>
          </set>
      }
    </ListSets>
};
