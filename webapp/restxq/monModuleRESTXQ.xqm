module namespace monModuleRESTXQ = 'monModuleRESTXQ';
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare %restxq:path("occurences/de/{$mot}/dans/{$root}")
        %output:method("xhtml")
        %output:doctype-public("xhtml")
        function monModuleRESTXQ:occurrences($root,$mot){
  <ul>
  {
  for $paragraphe in db:open($root)//tei:w[text() contains text {$mot}]/ancestor::tei:p
  let $nOcc := count($paragraphe//tei:w[text() contains text {$mot}])
  return
  <li> paragraphe {string($paragraphe/@n)} : {$nOcc} occurrences </li>
  }
  </ul>
};
