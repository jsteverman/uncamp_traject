Traject
-------
https://github.com/traject/traject

For options: 
$ traject -h

Source Data
-----------
https://github.com/usgpo/cataloging-records/

Using marcout to convert from MARC binary to MARCXML:
~~~
traject -x marcout source_data/gpo_records_utf8.mrc -o output/gpo_records_utf8.xml -s marcout.type=xml
~~~

Using the traject_config to extract fields from MARC binary:
~~~
traject -c traject_config.rb source_data/gpo_records_utf8.mrc -o output/gpo_extracted.ndj
~~~

Using a command line argument to override a configuration to deal 
with a different text encoding:
~~~
traject -c traject_config.rb -s marc_source.encoding=MARC-8 source_data/gpo_records_marc8.mrc -o output/gpo_extracted.ndj
~~~

Writing to a CSV file:
~~~
traject -c traject_config.rb source_data/gpo_records_utf8.mrc -w "Traject::CSVWriter" -o output/gpo_extracted.csv
~~~
