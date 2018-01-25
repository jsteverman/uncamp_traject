# Traject has built in logic for things that involve more than
# a single field extraction. These tend to be "opinionated", meaning
# they may make assumptions that do not always apply or serve your needs.
# https://github.com/traject/traject/tree/master/lib/traject/macros

# Searches the 035 for strings that *look* like OCLC numbers. 
to_field "oclcnum",       oclcnum

# Takes dates from 008 or 260c and makes a best guess.
# Assumes any pub date before 500 is garbage (which it usually is).
# Probably not suitable for copyright determination,
# but good for corpus analysis/search. 
to_field "pub_date",      marc_publication_date

# So we don't have to become fluent in MARC language codes.
to_field "language",      marc_languages

# Determining and describing can be a bit of a head ache. 
to_field "format",        marc_formats

# TODO: figure out what these do
to_field "series",        marc_series_facet
to_field "subject_geo",   marc_geo_facet
to_field "subject_era",   marc_era_facet

# Sometimes you want the title, but without the A/For/The cruft 
to_field "sortable_title",      marc_sortable_title

# For audio recordings, we can convert MARC codes into something readable.
to_field "instrumentation",       marc_instrumentation_humanized
to_field "instrumentation_code", marc_instrument_codes_normalized
