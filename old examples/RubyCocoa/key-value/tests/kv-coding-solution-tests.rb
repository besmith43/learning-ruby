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

class TryThisYourselfKeyValueCodingTests < Test::Unit::TestCase
  context "NSArray" do

    # I move @array_holder into the setup block because it's now 
    # used in two tests.
    setup do
      @things = [PlainThing.chain('1', '1.1'),
                PlainThing.chain('2', '2.2')].to_ns
      @array_holder = PlainThing.alloc.initWithValue(@things)
    end

    context "getters" do 

      should "act like they apply collect() to their values" do 
        assert { @things.valueForKey(:value) == ['1', '2'] }
        assert { @things.valueForKeyPath('sibling.value') == ['1.1', '2.2'] }
      end

      should "behave that way even if not at head of keypath" do
        assert {
          @array_holder.valueForKeyPath("value.sibling.value") == ['1.1', '2.2'] 
        }
      end
    end

    context "setters" do 

      # Notice that I'm setting the new values to an integer and a float
      # (one that can be represented precisely). My habit is to introduce
      # irrelevant variety into tests when it's easy to do so. Sometimes
      # I'm surprised into realizing that I only *thought* it was irrelevant. 

      should "change the value in each element" do
        @things.setValue_forKey(9, :value)
        assert { @things.valueForKey(:value) == [9, 9] }
        
        @things.setValue_forKeyPath(2.0, 'sibling.value')
        assert { @things.valueForKeyPath('sibling.value') == [2.0, 2.0] }
      end

      should "behave that way even if not at head of keypath" do
        assert {
          @array_holder.setValue_forKeyPath('new', 'value.sibling.value')
          @array_holder.valueForKeyPath("value.sibling.value") == ['new', 'new'] 
        }
      end
    end
  end
end

