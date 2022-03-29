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


class NaiveContextWatcher < NSObject
  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, context)
    puts "Context: #{context}" 
  end
end

class CastingContextWatcher < NSObject

  def observeValueForKeyPath_ofObject_change_context(
             keyPath, object, change, rawContext)
    context = rawContext.cast_as('@')
    # ...

    puts "Context: #{context.inspect}" 

  end

end

observed = ObservableValueHolder.alloc.init


puts "1. This trial demonstrates that NSString used as context"
puts "   is received as an ObjcPtr."
watcher = NaiveContextWatcher.alloc.init
observed.objc_send(:addObserver, watcher, :forKeyPath, 'value',
                   :options, nil,
                   :context, "I am a context".to_ns)
observed.value = 3
observed.removeObserver_forKeyPath(watcher, 'value')



puts "2. This trial demonstrates that the ObjcPtr can be cast back into"
puts "   an NSString."
watcher = CastingContextWatcher.alloc.init

observed.objc_send(:addObserver, watcher, :forKeyPath, 'value',
                   :options, nil,
                   :context, "I am a context".to_ns)

observed.value = 33
observed.removeObserver_forKeyPath(watcher, 'value')

puts "3. In this trial, a Ruby String will be passed in as context."
puts "   The program will die a horrible death when it tries to cast it "
puts "   into an Objective-C object."
watcher = CastingContextWatcher.alloc.init

observed.objc_send(:addObserver, watcher, :forKeyPath, 'value',
                   :options, nil,
                   :context, "I am a Pure Ruby context")

observed.value = 333
puts "No crash? You should never see this."
observed.removeObserver_forKeyPath(watcher, 'value')
