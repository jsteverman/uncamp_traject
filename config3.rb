# Custom Logic
# Complete documentation can be found: https://github.com/traject/traject/blob/master/doc/indexing_rules.md

# Traject configs are just ruby, so we can write our own custom logic as well.
# If we were using HT records this would create a link to the catalog:
to_field "catalog_link" do |record, accumulator, context|
  bib_id = record['001'].value
  link = 'https://hathitrust.org/catalog/'+bib_id

  # The accumulator is a list (array) of fields for this record
  accumulator << link
end

# Using a macro, then changing the results
to_field "worldcat", oclcnum do |record, accumulator|
  link = 'https://www.worldcat.org/oclc/'
  # Adding the link to all of the OCLCs in the accumulator
  accumulator.map! {|o| link + o}
end

# We can do something for each record, but not associated
# with any particular field.
each_record do |record, context|
  # A contrived example, skipping this record if the 100 field matches 
  if record['100'] =~ /Shakespeare/
    context.skip!('Give it a rest Bill')
  end
end  
