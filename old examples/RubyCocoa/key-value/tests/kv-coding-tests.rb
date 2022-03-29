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

class KeyValueCodingTests < Test::Unit::TestCase   # (1) 

  context "An attr_accessor in an NSObject" do  # (2)
    
    should "define valueForKey() and setValue_forKey()" do  # (3)
      # ...

      class WithAttr < NSObject
        attr_accessor :attribute
      end

      object = WithAttr.alloc.init


      assert { object.attribute == nil }


      assert { object.valueForKey('attribute') == nil }   # (4)
      # ...

      object.setValue_forKey('new value', 'attribute')
      # Note: setValue_forKey has no defined return value, unlike attr=
      assert { object.valueForKey('attribute') == 'new value' }

    end

    should "also define keypath methods" do
      #...

      object = PlainThing.chain(1, 2, 3)

      assert { object.sibling.sibling.value == 3 }
      assert { object.valueForKeyPath('sibling.sibling.value') == 3 }
      object.setValue_forKeyPath('new', 'sibling.value')
      assert { object.valueForKeyPath('sibling.value') == 'new' }

    end
  end


  context "An NSObject descendent that doesn't use attr_*" do

    should "support KVC methods if it defines x() and x=()" do
      class HandDefined < NSObject
        def attribute; @attribute; end
        def attribute=(new_value); @attribute = new_value; end
      end

      object = HandDefined.alloc.init


      deny { object.attribute }

      assert { object.valueForKey('attribute') == nil }
      object.setValue_forKey('new value', 'attribute')
      assert { object.valueForKey('attribute') == 'new value' }
    end

    should "also be able to define valueForKey by hand" do
      class ReallyByHand < NSObject
        def init; 
          @attribute = "initial value"
          self
        end
        
        def valueForKey(key);
          instance_variable_get("@#{key}")
        end
        def setValue_forKey(value, key)
          instance_variable_set("@#{key}", value)
        end
      end

      object = ReallyByHand.alloc.init

      assert_raises (OSX::OCMessageSendException) { object.attribute } 

      
      assert { object.valueForKey(:attribute) == "initial value" }

      object.setValue_forKey("new", :attribute)
      assert { object.valueForKey(:attribute) == "new" }
    end

    # If you define both attribute() and valueForKey(:attribute), 
    # the latter takes precedence. It would be odd to do so, so 
    # I'm not going to bother with a test.
  end


  context "Data conversions" do
    should "apply when an object value is fetched via valueForKey" do
      random_nsobject = PlainThing.alloc.initWithValue("one")
      
      assert { random_nsobject.value == "one" }
      assert { random_nsobject.valueForKey(:value) == "one".to_ns }
      assert { random_nsobject.valueForKey(:value).is_a? NSString }
    end

    should "be done to objects set with setValue_forKey" do
      random_nsobject = PlainThing.alloc.init
      random_nsobject.setValue_forKey("one", :value)
      assert { random_nsobject.value == "one".to_ns }
      assert { random_nsobject.value.is_a? NSString }
    end
  end



  #...

  context "NSDictionaries" do
    should "allow key-value methods to get at their values" do
      # ...

      dict = { '1' => 1 }.to_ns
      assert { dict.valueForKey('1') == 1 }
      dict.setValue_forKey(2, '2')
      assert { dict.valueForKey('2') == 2 }
    end

    should "only use string keys when KVC methods will be used" do
      dict = { 1 => '1' }.to_ns
      assert_raise(OSX::OCException) do 
        silently do dict.valueForKey(1) end
      end

    end
  end



  context "NSArray getters" do
    setup do
      @things = [PlainThing.chain('1', '1.1'),
                PlainThing.chain('2', '2.2')].to_ns
    end

    should "act like they apply collect() to their values" do 
      # ...

      assert { @things.valueForKey(:value) == ['1', '2'] }
      assert { @things.valueForKeyPath('sibling.value') == ['1.1', '2.2'] }

    end

    should "behave that way even if not at head of keypath" do 
      # ...

      @array_holder = PlainThing.alloc.initWithValue(@things)
      assert {
        @array_holder.valueForKeyPath("value.sibling.value") == ['1.1', '2.2'] 
      }

    end
  end


end

