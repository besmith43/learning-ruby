#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'

# A PlainThing has a value, and can be chained to other things.
# Note that the properties are not declared with kvc_*, so 
# PlainThings are not observable.
class PlainThing < OSX::NSObject
  attr_accessor :value, :sibling
  
  def initWithValue(value)
    @value = value
    super_init
  end

  def init; initWithValue(nil); end

  def initWithValue_andSibling(value, sibling)
    @sibling = sibling
    initWithValue(value)
  end

  def self.chain(*values)    # Answer a connected chain of initialized things.
    return nil if values.empty?
    alloc.initWithValue_andSibling(values.first, 
                                   chain(*values[1..-1]))
  end
end

class PlainCollection < OSX::NSObject
  attr_accessor :content

  def initWithValues(array)
    @content = NSMutableArray.alloc.init
    array.each do | elt | 
      @content << elt
    end
    super_init
  end

  def init; initWithValues([]); end
end


# An ObservableValueHolder just has a value to observe. Notice that its accessor is
# declared with kvc_accessor.

class ObservableValueHolder < OSX::NSObject
  kvc_accessor :value    # (1) 

  def initWithValue(value)
    @value = value
    super_init
  end

  def init; initWithValue(nil); end

  # Does not go through any accessor method.
  def set_instance_variable_directly(new_value)
    @value = new_value
  end

  # This is due to a bug in 0.13.1. Without it, observers get notified
  # twice. 
  # TODO: should I provide a hacked value of kvc_accessor?
  def self.automaticallyNotifiesObserversForKey(key)
    false
  end
end


# A Watcher is something that observes an ObservableValueHolder.
class Watcher < OSX::NSObject
  # This is the method called when a watched object changes.
  # Tests replace this with a mock, but the method definition
  # is still required.
  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, context)
    puts "The watcher has been called for #{object} and #{keyPath.to_s.inspect}"
    puts "Here's the description of the change:"
    puts change
  end

end

