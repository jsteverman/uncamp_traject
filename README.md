Traject
-------
https://github.com/traject/traject

For options: 
$ traject -h

Source Data
-----------
https://github.com/usgpo/cataloging-records/

~~~
traject -x marcout gpo_records_utf8.mrc -o gpo_records_utf8.xml -s marcout.type=xml

traject -c traject_config.rb cataloging-records/cataloging_records_December17_5463_utf8.mrc -o GPO_December.ndj

traject -c traject_config.rb -s marc_source.encoding=MARC-8 cataloging-records/cataloging_records_December17_5463_marc8.mrc -o GPO_December.ndj
~~~
