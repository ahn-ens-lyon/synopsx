module namespace search = 'http://ahn.ens-lyon.fr/search';

(:
 : launches search for a 
 : @word
:)
declare function search:query (
   $db as xs:string,
   $word as xs:string
){
  let $ftindex := db:info($db)//ftindex = 'true'
  let $options := map {
    'mode' : 'all words',
    'fuzzy' : true()
  }
  return if ($ftindex) then (
            ft:search($db, $word, $options)
  )else ( 
            db:open($db)//*[ft:contains($db, $word, $options)]
    )
    
}; 
