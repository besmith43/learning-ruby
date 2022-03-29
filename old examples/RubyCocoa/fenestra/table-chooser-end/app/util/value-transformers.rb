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

  def transformedValue(value)           
    NSLog "Transforming: #{value.inspect}"
    value
  end

  def reverseTransformedValue(value)
    NSLog "Reverse transforming: #{value.inspect}"
    value
  end

  def self.allowsReverseTransformation; true; end
end

class DataArrayTransformer < OSX::NSValueTransformer
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

class OffStateMeansTrueTransformer < OSX::NSValueTransformer
  include OSX

  def transformedValue(state)
    case state
    when NSOffState: true
    when NSOnState: false
    else
      raise "The value to transform should be either NSOffState or NSOnState."
    end
  end
end

class OffStateMeansEnabledColorTransformer < OSX::NSValueTransformer
  include OSX

  def transformedValue(bool)
    case bool
    when false.to_ns: ENABLED_COLOR
    when true.to_ns: DISABLED_COLOR
    else
      raise "The value to transform should be either NSOffState or NSOnState."
    end
  end
end
