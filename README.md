Traject
-------
https://github.com/traject/traject

For options: 
$ traject -h

Source Data
-----------
https://github.com/usgpo/cataloging-records/

~~~
traject -x marcout source_data/gpo_records_utf8.mrc -o output/gpo_records_utf8.xml -s marcout.type=xml

traject -c traject_config.rb source_data/gpo_records_utf8.mrc -o output/gpo_extracted.ndj

traject -c traject_config.rb -s marc_source.encoding=MARC-8 source_data/gpo_records_marc8.mrc -o output/gpo_extracted.ndj
~~~
