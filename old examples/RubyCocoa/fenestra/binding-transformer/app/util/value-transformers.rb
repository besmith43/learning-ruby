#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Snooper < OSX::NSValueTransformer
  include OSX

  def transformedValue(value)           # (1) 
    NSLog "Transforming: #{value.inspect}"
    value
  end

  def reverseTransformedValue(value)    # (2) 
    NSLog "Reverse transforming: #{value.inspect}"
    value
  end

  def self.allowsReverseTransformation; true; end # (3) 


end

