#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'util'
require '../checked-examples/stock-classes'

class SnitchingValueTransformer < NSValueTransformer

  attr_accessor :verbose
  
  def transformedValue(value)
    if verbose
      puts "... The transformer receives #{value.inspect}, a #{value.class}."
      puts "... Ruby counts that value as #{value ? "true" : "false"}."
      if !!value != !!$expected
        puts "    ==> Note the difference between truth values of original and value received."
      end
      puts "... The transformer #{rubyable?(value) ? "may" : "may NOT"} use to_ruby on it."
    end
    value
  end

  def rubyable?(val)
    begin
      val.to_ruby
    rescue
      return false
    end
    true
  end
end

$source = ObservableValueHolder.alloc.initWithValue(nil)
$sink = ObservableValueHolder.alloc.init
$transformer = SnitchingValueTransformer.alloc.init
$sink.bind_toObject_withKeyPath_options('value', $source, 'value', 
        NSValueTransformerBindingOption => $transformer)

$transformer.verbose = true

def try(val)
  $expected = val
  puts "=== When you set a property to #{val.inspect}..."
  $source.value = val
  puts "Result is #{$sink.value.inspect}, a #{$sink.value.class}."
end

try(nil)
try(true)
try(false)
try(1)
try(0)
