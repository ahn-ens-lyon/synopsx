(:~
 : Provides HTML components.
 :
 : @author Christian Grün, BaseX GmbH, 2014
 :)
module namespace html = 'dba/html';

import module namespace Request = 'http://exquery.org/ns/request';
import module namespace G = 'dba/global' at '../modules/global.xqm';
import module namespace web = 'dba/web' at '../modules/web.xqm';

(: Number formats. :)
declare variable $html:NUMBER := ('decimal','number', 'bytes');

(:~
 : Creates a checkbox.
 : @param  $name     name of checkbox
 : @param  $value    value
 : @param  $checked  checked state
 : @param  $label    label
 : @return checkbox
 :)
declare function html:checkbox(
  $name     as xs:string,
  $value    as xs:string,
  $checked  as xs:boolean,
  $label    as xs:string
) as item()* {
  element input {
    attribute type { "checkbox" },
    attribute name { $name },
    attribute checked { }[$checked],
    attribute value { $value }
  },
  $label
};

(:~
 : Creates a button.
 : @param  $value  button value
 : @param  $label  label
 :)
declare function html:button(
  $value    as xs:string,
  $label    as xs:string
) {
  html:button($value, $label, false())
};

(:~
 : Creates a button.
 : @param  $value    button value
 : @param  $label    label
 : @param  $confirm  confirm click
 :)
declare function html:button(
  $value    as xs:string,
  $label    as xs:string,
  $confirm  as xs:boolean
) {
  html:button($value, $label, $confirm, ())
};

(:~
 : Creates a button.
 : @param  $value    button value
 : @param  $label    label
 : @param  $confirm  confirm click
 : @param  $class    button class
 :)
declare function html:button(
  $value    as xs:string,
  $label    as xs:string,
  $confirm  as xs:boolean,
  $class    as xs:string?
) {
  element button {
    attribute type { 'submit' },
    attribute name { 'action' },
    attribute value { $value },
    $confirm[.] ! attribute onclick { "return confirm('Are you sure?');" },
    $class ! attribute class { . },
    $label
  }
};

(:~
 : Creates a property list.
 : @param $props properties
 :)
declare function html:properties(
  $props  as element()
) {
  <table>{
    for $info in $props/*
    return (
      <tr>
        <th colspan='2' align='left'>
          <h3>{ upper-case($info/name()) }</h3>
        </th>
      </tr>,
      for $option in $info/*
      let $value := $option/data()
      return <tr>
        <td><b>{ upper-case($option/name()) }</b></td>
        <td>{
          if($value = 'true') then '✓'
          else if($value = 'false') then '–'
          else $value
        }</td>
      </tr>
    )
  }</table>
};

(:~
 : Creates a sorted table for the specified entries.
 : @param $entries  table entries
 : @param $headers  headers
 : @param $buttons  buttons
 : @param $cat      top category
 :)
declare function html:table(
  $entries as element(e)*,
  $headers as element()*,
  $buttons as element(button)*,
  $cat     as xs:string
) {
  html:table($entries, $headers, $buttons, $cat, map {})
};

(:~
 : Creates a sorted table for the specified entries.
 : @param $entries  table entries
 : @param $headers  headers
 : @param $buttons  buttons
 : @param $cat      top category
 : @param $param    additional query parameters
 :)
declare function html:table(
  $entries as element(e)*,
  $headers as element()*,
  $buttons as element(button)*,
  $cat     as xs:string,
  $param   as map(*)
) {
  html:table($entries, $headers, $buttons, $cat, $param, ())
};

(:~
 : Creates a sorted table for the specified entries.
 : @param $entries  table entries
 : @param $headers  headers
 : @param $buttons  buttons
 : @param $cat      top category
 : @param $param    additional query parameters
 : @param $sort     sort key
 :)
declare function html:table(
  $entries as element(e)*,
  $headers as element()*,
  $buttons as element(button)*,
  $cat     as xs:string,
  $param   as map(*),
  $sort    as xs:string?
) {
  html:table($entries, $headers, $buttons, $cat, $param, $sort, false())
};

(:~
 : Creates a sorted table for the specified entries.
 : @param $entries  table entries
 : @param $headers  headers
 : @param $buttons  buttons
 : @param $cat      top category
 : @param $param    additional query parameters
 : @param $sort     sort key
 : @param $link     link main entry
 :)
declare function html:table(
  $entries as element(e)*,
  $headers as element()*,
  $buttons as element(button)*,
  $cat     as xs:string,
  $param   as map(*),
  $sort    as xs:string?,
  $link    as xs:boolean
) {
  if($buttons) then ($buttons, <br/>, <div class='small'/>) else (),
  if($entries) then (
    let $sort := if($sort = '') then $headers[1]/name() else $sort
    return <table>
      <tr>{
        for $header in $headers
        let $name := $header/name()
        let $value := upper-case($header/text())
        return element th {
          attribute align { if($header/@type = $html:NUMBER) then 'right' else 'left' },
          if(empty($sort) or $name = $sort) then (
            $value
          ) else (
            web:link($value, Request:path(), map:new(($param, map { 'sort': $name })))
          )
        }
      }
      </tr>
      {
        let $entries := if(empty($sort)) then $entries else (
          let $sort := if($sort) then $sort else $headers[1]/name()
          let $header := $headers[name() eq $sort]
          let $desc := $header/@order = 'desc'
          let $order :=
            if($header/@type = $html:NUMBER) then (
              if($desc)
              then function($a) { 0 - number($a) }
              else function($a) { number($a) }
            ) else if($header/@type = 'time') then (
              if($desc)
              then function($a) { xs:time('00:00:00') - xs:time($a) }
              else function($a) { $a }
            ) else if($header/@type = 'date') then (
              if($desc)
              then function($a) { xs:date('0001-01-01') - xs:date($a) }
              else function($a) { $a }
            ) else if($header/@type = 'dateTime') then (
              if($desc)
              then function($a) { xs:dateTime('0001-01-01T00:00:00Z') - xs:dateTime($a) }
              else function($a) { $a }
            ) else (
              function($a) { $a }
            )
          return for $entry in $entries
                 let $key := $entry/@*[name() eq $sort]
                 order by $order($key) empty greatest collation '?lang=en'
                 return $entry
        )

        for $entry at $c in $entries
        return if($c < $G:MAX-ROWS) then (
          <tr>{
            for $header at $pos in $headers
            let $name := $header/name()
            let $type := $header/@type
            let $col := $entry/@*[name() = $name]
            let $value := $col/string() ! (
              if($header/@type = 'bytes') then (
                try { prof:human(xs:integer(.)) } catch * { . }
              ) else if($header/@type = 'decimal') then (
                try { format-number(number(.), '#.00') } catch * { . }
              ) else if($header/@type = 'dateTime') then (
                let $zone := timezone-from-dateTime(current-dateTime())
                let $dt := fn:adjust-dateTime-to-timezone(xs:dateTime(.), $zone)
                return format-dateTime($dt, '[Y0000]-[M00]-[D00], [H00]:[m00]')
              )
              else .
            )
            return element td {
              attribute align { if($header/@type = $html:NUMBER) then 'right' else 'left' },
              if($pos = 1 and $buttons) then (
                <input type="checkbox" name="{ $name }" value="{ $col }" onClick="buttons()"/>,
                if($link) then web:link($value, $cat, map:new(($param, map { $name: $value })))
                else $value
              ) else (
                let $tl := string-length($value)
                return if($tl < 80) then
                  $value
                else
                  <textarea class='variable' rows='{ max((2, $tl div 64)) }' cols='80' readonly=''>{
                    $value
                  }</textarea>
              )
            }
          }</tr>
        ) else if($c = $G:MAX-ROWS) then (
          <tr>
            <td>{
              if($buttons) then <input type="checkbox" disabled=""/> else ()
            }…</td>
          </tr>
        ) else ()
      }
    </table>
    (: , if($buttons) then (<div class='small'/>, $buttons, <br/>) else () :)
  ) else (
    <b>{ upper-case($headers[1]) }</b>
  )
};

(:~
 : Creates a singular/plural label.
 : @param  $items   items
 : @param  $labels  singular/plural label
 :)
declare function html:label(
  $items   as item()*,
  $labels  as xs:string+
) {
  let $size := count($items)
  return (
    $size || ' ' || $labels[if(count($items) = 1) then 1 else 2] ||
    (if($size = 0) then '.' else ':')
  )
};
