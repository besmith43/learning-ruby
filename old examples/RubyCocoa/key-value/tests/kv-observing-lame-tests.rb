#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'util'

# These examples justify mock objects. They test nothing that isn't 
# tested in kv-observing-examples.rb


class ObservableValueHolder1 < NSObject
  kvc_accessor :value    # (1) 

  def initWithValue(value)
    @value = value
    self
  end
end

class Watcher1 < NSObject    # (2) 
  attr_reader :call_count, :last_keypath, :last_object

  def init
    @call_count = 0;
    self
  end

  def observeValueForKeyPath_ofObject_change_context(keypath, object,     # (3) 
                                                     change, context)
    @call_count += 1
    @last_keypath = keypath
    @last_object = object
  end
end

class KeyValueObservingLameTests < Test::Unit::TestCase

  context "change callbacks" do 	
    setup do
      @observed = ObservableValueHolder1.alloc.initWithValue('original')
      @watcher = Watcher1.alloc.init
    end

    should "include the keypath and changed object" do
      add_observer(:watcher => @watcher,   # (4) 
                   :forKeyPath => 'value') # shorthand - allows defaults
      @observed.value = "hello"            # (5)
      assert { @watcher.call_count == 1 }  # (6)
      assert { @watcher.last_keypath == 'value' }
      assert { @watcher.last_object == @observed }
    end
  end

  def add_observer(hash = {})  # (7)
    @observed.objc_send(:addObserver, hash.fetch(:watcher, @watcher), # ...

                        :forKeyPath, hash.fetch(:forKeyPath, 'value'),
                        :options, hash.fetch(:options, nil),
                        :context, hash.fetch(:context, nil))

  end
end






