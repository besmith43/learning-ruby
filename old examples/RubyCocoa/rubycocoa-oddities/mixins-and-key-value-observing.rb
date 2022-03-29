#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# This is derived from key-value/howtos/kv-binding-by-hand.rb. 
# Unlike it, the binding code is put in a module and mixed 
# into the object we want to bind. That doesn't work because the 
# key-value observing mechanism will look for the observeValueForKeyPath... 
# method on the object, not on the mixin module. It doesn't find it and whines.


load '../sandbox.rb'

require 'osx/cocoa'
include OSX

require '../key-value/tests/stock-classes'

module BindableObject

  def bind_toObject_withKeyPath(myKeyPath, observed, observedKeyPath)
    # Grab the initial value.
    setValue_forKeyPath(observed.valueForKeyPath(observedKeyPath), 
                        myKeyPath)
    # Observe further values. Use the context argument to stash 
    # my property's keyPath.
    observed.addObserver_forKeyPath_options_context(
                            self, observedKeyPath,
                            NSKeyValueObservingOptionNew, 
                            myKeyPath.to_ns)
  end

  # When I am notified of a change, update the property (whose
  # keyPath comes out of the context).
  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, context)
    myKeyPath = context.cast_as("@")
    setValue_forKeyPath(change['new'], myKeyPath) 
  end

end

class Tracker < NSObject
  include BindableObject
  attr_accessor :synced_value
end


if $0 == __FILE__

  observed = ObservableValueHolder.alloc.initWithValue('initial')
  puts "Create an object to be observed. Its initial value is " + 
       observed.value.inspect
  tracker = Tracker.alloc.init
  puts "Create an object to track it. Its initial value is " + 
       tracker.synced_value.inspect
  tracker.bind_toObject_withKeyPath("synced_value", observed, "value")
  puts "After binding, the tracking object's value is " + 
       tracker.synced_value.inspect

  puts "==> Now the action: about to change the observed object's value."
  begin
    observed.value = "something else"
  rescue Exception => ex
    puts "Got this exception:"
    puts ex.message
  end
  puts "After setting observed object's value to #{observed.value.inspect}, " 
  puts "the tracker's value is... still #{tracker.synced_value.inspect}"
  exit
end
