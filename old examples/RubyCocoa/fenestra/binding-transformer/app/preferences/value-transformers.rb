#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

class DataArrayTransformer < OSX::NSFormatter
  # ...

  include OSX


  def transformedValue(nsdata_array)
    nsdata_array.collect do | datum | 
      NSKeyedUnarchiver.unarchiveObjectWithData(datum)
    end
  end

  def reverseTransformedValue(pref_array)
    pref_array.collect do | pref | 
      NSKeyedArchiver.archivedDataWithRootObject(pref)
    end
  end


  def self.allowsReverseTransformation; true; end

end

