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


class Unpatched < NSObject
  kvc_accessor :value
end

class Patched < NSObject
  kvc_accessor :value

  def self.automaticallyNotifiesObserversForKey(key)
    false
  end
end


class Watcher < NSObject
  attr_reader :buggy
  
  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, context)
    if @already_called_once
      puts "You DO have the key-value observing bug."
      puts "To see the fix, look at the Patched class in this file."
      @buggy = true
    end
    @already_called_once = true
  end
end




def buggy_observing?(observed)
  watcher = Watcher.alloc.init
  observed.addObserver_forKeyPath_options_context(watcher, 'value', nil, nil)
  observed.setValue_forKey(1, 'value')
  observed.removeObserver_forKeyPath(watcher, 'value')
  return watcher.buggy
end

if buggy_observing?(Unpatched.alloc.init)
  puts "Confirming that the Patched class fixes it."
  puts "You should see no more output."
  buggy_observing?(Patched.alloc.init)
else
  puts "You do not have the the key-value observing bug."
end




