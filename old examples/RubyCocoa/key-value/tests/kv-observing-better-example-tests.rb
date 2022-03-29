#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'util'
require 'stock-classes'


class ObservableValueHolder2 < NSObject
  kvc_accessor :value 

  def initWithValue(value)
    @value = value
    self
  end
end

class KeyValueObservingTestsBetter < Test::Unit::TestCase
  CALLBACK=:observeValueForKeyPath_ofObject_change_context # (1) 

  context "change callbacks" do 	
    setup do

      @watcher = rubycocoa_flexmock("watcher")    # (2) 

      @observed = ObservableValueHolder2.alloc.initWithValue('original')
    end

    should "include the keypath and changed object" do
      add_observer(:watcher => @watcher, :forKeyPath => 'value')

      during {                  # (3)
        @observed.value = "hello"
      }.behold! {
        @watcher.should_receive(CALLBACK, 4).once.  # (4)
                 with('value', @observed, any, any)
      }

    end


    should "contain old and new values (if requested)" do
      add_observer(:options => NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionOld)
      during {
        @observed.value = "new"
      }.behold! {

        @watcher.should_receive(CALLBACK, 4).
                 once.
                 with('value',
                      @observed,
                      on { | change |          # No longer accept anything
                        change['old'] == 'original' &&
                        change['new'] == 'new'
                      },  
                      any)

      }
    end
  end


  def add_observer(hash = {})
    @observed.objc_send(:addObserver, hash.fetch(:watcher, @watcher), 
                        :forKeyPath, hash.fetch(:forKeyPath, 'value'),
                        :options, hash.fetch(:options, nil),
                        :context, hash.fetch(:context, nil))

  end
end

