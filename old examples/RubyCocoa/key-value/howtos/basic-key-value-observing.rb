#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'util'

class Observed < NSObject
  kvc_accessor :value

  # This is required due to a 0.13.1 (and earlier) bug. 
  # See checking-for-double-notification-kv-observing-bug.rb
  def self.automaticallyNotifiesObserversForKey(key)
    false
  end
end

class Watcher < NSObject
  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, context)
    puts "property '#{object}' (context #{context.inspect}) had " +
         "#{keyPath} changed:"
    puts change
  end
end

observed = Observed.alloc.init
watcher = Watcher.alloc.init

# Ask to receive info about both old and new values.
observed.addObserver_forKeyPath_options_context(watcher, 'value',
                                                NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
                                                nil)

observed.value = "first new value"
observed.value = "second new value"
observed.removeObserver_forKeyPath(watcher, 'value')

