# A sample traject configuration, stripped down version of
# https://github.com/traject/traject/blob/master/test/test_support/demo_config.rb

# To run, `traject -c traject_config.rb marc_file.marc` 


# To have access to various built-in logic
# for pulling things out of MARC21, like `marc_languages`
require 'traject/macros/marc21_semantics'
extend  Traject::Macros::Marc21Semantics

# To have access to the traject marc format/carrier classifier
require 'traject/macros/marc_format_classifier'
extend Traject::Macros::MarcFormats

require 'traject/csv_writer'
require 'traject/delimited_writer'

# In this case for simplicity we provide all our settings in this one file. 
# But you could choose to separate them into antoher config file; divide things 
# between files however you like, you can call traject with as many
# config files as you like, `traject -c one.rb -c two.rb -c etc.rb`
settings do
  # Source type
  provide "marc_source.type", "binary" # default
  # provide "marc_source.type", "xml"
  # provide "marc_source.type", "json" 

  # Character encoding
  # Traject works with everything internally as UTF-8, but we need
  # to be able to consume MARC-8 content as well.
  provide "marc_source.encoding", 'UTF-8' # *usually* the default
  # provide "marc_source.encoding", 'MARC-8'

  # Tell it which kind of writer to use. 
  # provide "writer_class_name", "Traject::JsonWriter"
  # provide "writer_class_name", "Traject::SolrJsonWriter" # default
  # provide "writer_class_name", "Traject::YamlWriter"
  # provide "writer_class_name", "Traject::DebugWriter"
  # provide "writer_class_name", "Traject::DelimitedWriter" # default tsv
  # provide "delimited_writer.delimiter", "\t"
   provide "writer_class_name", "Traject::CSVWriter" 

  # If we were indexing into solr we would give its url
  #provide "solr.url", "http://solr.somewhere.edu:8983/solr/corename"

  # List of fields for DelimitedWriter and CSVWriter
  provide "delimited_writer.fields", "author_display, title_display"  
end

# Extract first 001, then supply code block to add "bib_" prefix to it
to_field "id", extract_marc("001", :first => true) do |marc_record, accumulator, context|
  accumulator.collect! {|s| "bib_#{s}"}
end

# An exact literal string, always this string:
to_field "source",              literal("traject_test_last")

to_field "publisher_t",         extract_marc("260abef:261abef:262ab:264ab")
to_field "published_display", extract_marc("260a", :trim_punctuation => true)

to_field "isbn_t",              extract_marc("020a:773z:776z:534z:556z")
to_field "issn",                extract_marc("022a:022l:022y:773x:774x:776x", :separator => nil)
to_field "lccn",                extract_marc("010a")

to_field "material_type_display", extract_marc("300a", :separator => nil, :trim_punctuation => true)

# Which "title" do we want?  
to_field "title_t",             extract_marc("245ak")
#to_field "title1_t",            extract_marc("245abk")
#to_field "title2_t",            extract_marc("245nps:130:240abcdefgklmnopqrs:210ab:222ab:242abcehnp:243abcdefgklmnopqrs:246abcdefgnp:247abcdefgnp")
#to_field "title3_t",            extract_marc("700gklmnoprst:710fgklmnopqrst:711fgklnpst:730abdefgklmnopqrst:740anp:505t:780abcrst:785abcrst:773abrst")

to_field "title_display",       extract_marc("245abk", :trim_punctuation => true, :first => true)

to_field "title_series_t",      extract_marc("440a:490a:800abcdt:400abcd:810abcdt:410abcd:811acdeft:411acdef:830adfgklmnoprst:760ast:762ast")
to_field "series_facet",        marc_series_facet

to_field "author_display",      extract_marc("100abcdq:110:111")

to_field "subject_t",           extract_marc("600:610:611:630:650:651avxyz:653aa:654abcvyz:655abcvxyz:690abcdxyz:691abxyz:692abxyz:693abxyz:656akvxyz:657avxyz:652axyz:658abcd")

# Built in logic for things that involve more than 
# a single field extraction.
# https://github.com/traject/traject/tree/master/lib/traject/macros
to_field "language_facet",      marc_languages
to_field "format",              marc_formats
to_field "subject_geo_facet",   marc_geo_facet
to_field "subject_era_facet",   marc_era_facet
to_field "pub_date",            marc_publication_date
to_field "oclcnum_t",           oclcnum
to_field "sortable_title",      marc_sortable_title
to_field "instrumentation_facet",       marc_instrumentation_humanized
to_field "instrumentation_code_unstem", marc_instrument_codes_normalized


# An example of more complex ruby logic 'in line' in the config file--
# too much more complicated than this, and you'd probably want to extract
# it to an external routine to keep things tidy.
#
# Use traject's LCC to broad category routine, but then supply
# custom block to also use our local holdings 9xx info, and
# also classify sudoc-possessing records as 'Government Publication' discipline
to_field "discipline_facet",  marc_lcc_to_broad_category(:default => nil) do |record, accumulator|
  # add in our local call numbers
  Traject::MarcExtractor.cached("991:937").each_matching_line(record) do |field, spec, extractor|
      # we output call type 'processor' in subfield 'f' of our holdings
      # fields, that sort of maybe tells us if it's an LCC field.
      # When the data is right, which it often isn't.
    call_type = field['f']
    if call_type == "sudoc"
      # we choose to call it:
      accumulator << "Government Publication"
    elsif call_type.nil? ||
          call_type == "lc" ||
        Traject::Macros::Marc21Semantics::LCC_REGEX.match(field['a'])
      # run it through the map
      s = field['a']
      s = s.slice(0, 1) if s
      accumulator << Traject::TranslationMap.new("lcc_top_level")[s]
    end
  end


  # If it's got an 086, we'll put it in "Government Publication", to be
  # consistent with when we do that from a local SuDoc call #.
  if Traject::MarcExtractor.cached("086a").extract(record).length > 0
    accumulator << "Government Publication"
  end

  # uniq it in case we added the same thing twice with GovPub
  accumulator.uniq!

  if accumulator.empty?
    accumulator << "Unknown"
  end
end
