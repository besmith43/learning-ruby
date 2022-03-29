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


class ArrayHolder < OSX::NSObject
  kvc_array_accessor :values   # (1) 

  def initWithValues(*initial_values)
    @values = NSMutableArray.arrayWithArray(initial_values)
    self
  end

  def values; @values; end     # (2)
end




class KeyValueObservingCollectionTests < Test::Unit::TestCase

  CALLBACK=:observeValueForKeyPath_ofObject_change_context


  def setup
    @watcher = rubycocoa_flexmock
    @observed = ArrayHolder.alloc.initWithValues('old_at_0', 'old_at_1') # (3) 
  end

  context "insert methods" do 	
    should "trigger observation" do
      # NSKeyValueObservingOptionOld is meaningless in case of insertion.
      add_observer(:options => NSKeyValueObservingOptionNew)
      during {
        @observed.insertObject_inValuesAtIndex('new_at_0', 0)  # (4) 
      }.behold! {
        watcher_should_receive_change { | actual |  # (5) 
          actual[:kind] == NSKeyValueChangeInsertion &&
          same_indexes(actual[:indexes], [0]) &&
          actual[:new] == ['new_at_0']
        }
      }
      assert { @observed.values == ['new_at_0', 'old_at_0', 'old_at_1' ] }  # (6) 
    end
  end


  context "remove methods" do 	
    should "trigger observation" do
      # NSKeyValueObservingOptionNew is meaningless in case of removal.
      add_observer(:options => NSKeyValueObservingOptionOld)
      during {
        @observed.removeObjectFromValuesAtIndex(1)
      }.behold! {
        watcher_should_receive_change { | actual |
          actual[:kind] == NSKeyValueChangeRemoval &&
          same_indexes(actual[:indexes], [1]) &&
          actual[:old] == ['old_at_1']
        }
      }
      assert { @observed.values == ['old_at_0' ] }
    end
  end


  context "replace methods" do 	
    should "trigger observation" do
      add_observer(:options => NSKeyValueObservingOptionOld |
                               NSKeyValueObservingOptionNew)
      during {
        @observed.replaceObjectInValuesAtIndex_withObject(1, 'new_at_1')
      }.behold! {
        watcher_should_receive_change { | actual |
          actual[:kind] == NSKeyValueChangeReplacement &&
          same_indexes(actual[:indexes], [1]) &&
          actual[:old] == ['old_at_1']
          actual[:new] == ['new_at_1']
        }
      }
      assert { @observed.values == ['old_at_0', 'new_at_1' ] }
    end
  end




  def add_observer(hash = {})
    @observed.objc_send(:addObserver, hash.fetch(:watcher, @watcher),
                        :forKeyPath, hash.fetch(:forKeyPath, 'values'),
                        :options, hash.fetch(:options, nil),
                        :context, hash.fetch(:context, nil))
  end

  
  def watcher_should_receive_change(&block)
    @watcher.should_receive(CALLBACK, 4).once.
             with('values', @observed,
                  on(&block),
                  any)
  end



  def same_indexes(actual, expected_array)
    expected = NSMutableIndexSet.alloc.init
    expected_array.each do | elt | 
      expected.addIndex(elt)
    end
    actual.isEqualToIndexSet(expected)
  end
end
