# Sample settings file for Traject

# To have access to various built-in logic
# for pulling things out of MARC21, like `marc_languages`
require 'traject/macros/marc21_semantics'
extend  Traject::Macros::Marc21Semantics

# To have access to the traject marc format/carrier classifier
require 'traject/macros/marc_format_classifier'
extend Traject::Macros::MarcFormats

# Additional output writers
require 'traject/csv_writer'
require 'traject/delimited_writer'

settings do
  # Source type
  # Traject can consume MARC in binary, MARCXML and MARC in JSON
  provide "marc_source.type", "binary" # default
  provide "marc_source.type", "xml"
  provide "marc_source.type", "json" 

  # Character encoding
  # Traject works with everything internally as UTF-8, but we need
  # to be able to consume MARC-8 content as well.
  provide "marc_source.encoding", 'UTF-8' # *usually* the default
  provide "marc_source.encoding", 'MARC-8'

  # Tell it which kind of writer to use. 
  # Traject primary purpose is as a MARC to Solr indexer, 
  # but there are a handful of different "Writer" options  
  provide "writer_class_name", "Traject::CSVWriter" 
  provide "writer_class_name", "Traject::SolrJsonWriter" # default
  provide "writer_class_name", "Traject::JsonWriter"
  provide "writer_class_name", "Traject::YamlWriter"
  provide "writer_class_name", "Traject::DebugWriter"
  provide "writer_class_name", "Traject::DelimitedWriter" # defaults to tsv
  provide "delimited_writer.delimiter", "\t"

  # If we were indexing into solr we would give its url
  # provide "solr.url", "http://solr.somewhere.edu:8983/solr/corename"

  # List of fields for DelimitedWriter and CSVWriter
  provide "delimited_writer.fields", "author,title,publisher"  
end


