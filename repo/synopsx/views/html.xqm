module namespace synopsx.views.html = 'synopsx.views.html';
declare default function namespace 'synopsx.views.html'; 
declare default element namespace 'http://www.w3.org/1999/xhtml'; 


declare function render($content, $options, $layout){
	let $tmpl := fn:doc($layout('layout'))
  (: a supprimer après passage à xslt2:)
  let $contentWrap := <xml>{$content('items')}</xml>
	return $tmpl update (
		replace value of node .//*:div[@id='content'] with xslt:transform($contentWrap,'http://localhost:8984/static/xsl/tei2html5.xsl',$options),
    replace value of node .//*:title with $content('title')
	)
};

declare function to-html($items){
	for $item in $items
	let $name := fn:local-name($item)
	let $tmpl := fn:doc($name || "_tmpl.html")
	return $tmpl

};