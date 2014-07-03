module namespace monModule = 'monModule';
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function monModule:occurrences($root){
  <ul>
  {
  for $paragraphe in $root//tei:w[text() contains text "Lancelot"]/ancestor::tei:p
  let $nOcc := count($paragraphe//tei:w[text() contains text "Lancelot"])
  return
  <li> paragraphe {string($paragraphe/@n)} : {$nOcc} occurrences </li>
  }
  </ul>
};

declare function monModule:occurrences($root,$mot){
  <ul>
  {
  for $paragraphe in $root//tei:w[text() contains text {$mot}]/ancestor::tei:p
  let $nOcc := count($paragraphe//tei:w[text() contains text {$mot}])
  return
  <li> paragraphe {string($paragraphe/@n)} : {$nOcc} occurrences </li>
  }
  </ul>
};
