# Simple extractions consist of naming the field with to_field,
# then telling extract_marc which fields/subfields to grab.

# Field 100 consisting of subfields a, b, c, d, and q
# Fields 110 and 111, all subfields
to_field "author", extract_marc("100abcdq:110:111")

# Field 245, subfields a, b, and k
# We can tell extract_marc to trim any trailing punctuation.
# 245 is a repeating field, in this case we only want the first. 
to_field "title", extract_marc("245abk", 
                               :trim_punctuation => true,
                               :first => true)

to_field "publisher", extract_marc("260abef:261abef:262ab:264ab")

# Default behavior is concatenation of subfields with a space. 
# Sometimes we want to keep them as separate fields. 
to_field "corp_author", extract_marc("110", :separator => nil, :trim_punctuation => true)
