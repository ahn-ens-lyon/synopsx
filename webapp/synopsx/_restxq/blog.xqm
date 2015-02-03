xquery version '3.0' ;
module namespace synopsx.blog = 'synopsx.blog' ;
(:~
 : This module is a RESTXQ blog with SynopsX
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 : @rmq the url scheme corresponds to a project level in SynopsX
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';
 
import module namespace G = 'synopsx.globals' at '../globals.xqm' ;
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../models/tei/tei.xqm' ;
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ; 
declare default function namespace 'synopsx.blog';


(:~
 : resource function for the blog
 : 
:)
declare 
  %restxq:path('/blog')
function blog(){
  <rest:redirect>{ '/blog/home' }</rest:redirect>
};


(:~
 : resource function for the blog home
 : 
:)
declare 
  %restxq:path('/blog/home')
function home(){
  let $params :=  map {
    "project" : '$project',
    "dataType" : '$dataType',
    "value" : '$value',
    "option" : '$option'
  }
  let $data    := synopsx.models.tei:listArticles($params)
  let $options := map {'sorting' : 'descending'} (: todo :)
  let $layout  := $G:TEMPLATES || 'blogHtml5.xhtml'
  let $pattern  := $G:TEMPLATES || 'blogListSerif.xhtml'
  return synopsx.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};


(:~
 : resource function for a blog entry
 : 
:)
declare 
  %restxq:path('/blog/{$entryId}')
  %rest:produces("application/html")
function article($entryId as xs:string){
  let $data    := synopsx.models.tei:article($entryId)
  let $options := map {}
  let $layout  := $G:TEMPLATES || 'blogHtml5.xhtml'
  let $pattern  := $G:TEMPLATES || 'blogArticleSerif.xhtml'
  return synopsx.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};

(:~
 : resource function for a blog entry
 : 
:)
declare 
  %restxq:path('/blog/{$entryId}')
  %rest:produces("application/xml")
  %rest:produces("application/tei+xml")  
function articleXml($entryId as xs:string){
  let $lang := 'fr'
  let $data := synopsx.models.tei:getXmlTeiById($entryId) 
  return $data (: to serialize :)
};

(:~
 : resource function for comments (if supported)
 : 
 : Collection des commentaires d'un billet de blog : 
 : `guidesdeparis.net/blog/posts/{entryId}/{comments}`
 : Item de commentaires d'un billet de blog 
 : `guidesdeparis.net/blog/posts/{entryId}/{comments}/{commentId}`
 :)

(:~
 : resource function to search blog posts
 :
 : `guidesdeparis.net/blog/posts/search?q=query` 
 : ou bien `guidesdeparis.net/blog/posts?q=query`
 : ?? `added_after`, `blog`, `blog_tag`, `pmid`, `tag`, `term`
 : 
 :)
declare 
  %restxq:path('/blog/search')
function search(){
 <html>A faire :)</html>
};


(:~
 : resource function for collection of tags
 :
 :)
declare
  %restxq:path('/blog/tags')
function tags(){
  <html>A faire :)</html>
};


(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %restxq:path('/blog/tags/{$tagId}')
function entriesByTagId($tagId as xs:string){
  <html>A faire :)</html>
};


(:~
 : resource function for collection of category
 : 
 :)
declare
  %restxq:path('/blog/categories')
function categories(){
  <html>A faire :)</html>
};


(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %restxq:path('/blog/categories/{$categoryId}')
function entriesByCategoryId($categoryId as xs:string){
  <html>A faire :)</html>
};


(:~
 : resource function for collection of authors
 : 
 :)
declare
  %restxq:path('/blog/authors')
function entriesByCategoryId(){
  <html>A faire :)</html>
};


(:~
 : resource function for collection of category
 : 
 :)
declare
  %restxq:path('/blog/authors/{$authorId}')
function categories($authorId as xs:string){
  <html>A faire :)</html>
};
