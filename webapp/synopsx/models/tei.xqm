(:~
 : tei function module for SynopsX
 :)
 
module namespace synopsx.models.tei = 'synopsx.models.tei';
declare default function namespace 'synopsx.models.tei'; 

declare default element namespace 'http://www.tei-c.org/ns/1.0'; 

declare variable $synopsx.models.tei:db := "gdpTei";

(:~
 : tei function, decides what to do wether config data and database already exist or not for this project
 : TODO entièrement
 :)
declare function title() as element(){ 
  (db:open($synopsx.models.tei:db)//titleStmt/title)[1]
}; 
 
declare function listItems() as element()* { 
  db:open($synopsx.models.tei:db)//titleStmt/title
};
