synopsx
=======

Full XML corpus publishing system developped at ENS Lyon (http://ahn.ens-lyon.fr)

Installation
------------
```bash
cd <path_to_basex>/webapp
rm -fr *
git clone https://github.com/ahn-ens-lyon/synopsx.git .
```

Don't forget to change your admin password an


Configuration
-------------

If you use the BaseX Client use the default syntax : http://docs.basex.org/wiki/Commands
You can also use the command line syntax : http://docs.basex.org/wiki/REST#Command_Line


CREATE DB 'config' <!-- http://docs.basex.org/wiki/Commands#CREATE_DB -->
OPEN DB 'config'
ADD synopsx.xml <!-- http://docs.basex.org/wiki/Commands#ADD -->
```
<configuration name="synopsx">
  <output name="html" value="synopsx_html"/>
  <output name="oai" value="synopsx_oai"/>
</configuration>
```


CREATE DB 'myproject'
OPEN DB 'myproject'
ADD myproject_data.xml 
<!-- or ADD TO 'myproject/' myproject_data.zip -->


OPEN DB 'config'
ADD myproject.xml
```
<!-- config file for 'myproject' -->
<configuration name="myproject"> 
  <!-- The @value attribute gives the parent xqm module namespace -->
  <parent value="synopsx"/>  
  <!-- The @value attribute gives the output xqm module namespace -->
  <output name="html" value="myproject"/>  
  <!-- Uncomment this line to overwrite synopx oai default functions -->
  <!--<output name="oai" value="myproject_oai_namespace"/>-->
</configuration>
```
