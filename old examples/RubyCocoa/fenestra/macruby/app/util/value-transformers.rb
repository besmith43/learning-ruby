#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class Snooper < NSValueTransformer

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

class DataArrayTransformer < NSValueTransformer

  def transformedValue(nsdata_array)
    $stderr.puts "Data array transformer called with #{nsdata_array.inspect}."
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

class OffStateMeansTrueTransformer < NSValueTransformer

  def transformedValue(state)
    $stderr.puts "state -> bool transforming #{state.inspect}"
    case state.intValue  # PORT: cast required
    when NSOffState then $stderr.puts('returning true'); true
    when NSOnState then $stderr.puts('returning false'); false
    else
      raise "The value to transform should be either NSOffState or NSOnState."
    end
  end
end

class OffStateMeansEnabledColorTransformer < NSValueTransformer
  def transformedValue(state)
    $stderr.puts "state -> color transforming #{state.inspect}"
    case state.intValue
    when NSOffState then ENABLED_COLOR
    when NSOnState then DISABLED_COLOR
    else
      raise "The value to transform should be either NSOffState or NSOnState."
    end
  end
end
