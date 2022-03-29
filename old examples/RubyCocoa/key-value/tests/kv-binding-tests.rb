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

class KVOTests < Test::Unit::TestCase
  
  def setup
    @changer = ObservableValueHolder.alloc.initWithValue("initial CHANGER value")
    @tracker = ObservableValueHolder.alloc.initWithValue("initial TRACKER value")
  end

  context "basic key-value binding" do

    setup do
      @tracker.bind_toObject_withKeyPath_options(
                                "value", @changer, "value", nil)
    end

    should "allow one object to track another's values" do
      @changer.value = "new value"
      assert_equal("new value", @tracker.value)
    end

    should "synchronize values when binding is established" do
      assert_equal("initial CHANGER value", @tracker.value)
    end

    should "be unidirectional w/o bound object action" do    # The documentation misleads.
      @tracker.value = "some new tracker value"
      assert_not_equal("some new tracker value",
                       @changer.value)
    end
  end

  context "value transformers" do

    class LengthValueTransformer < NSValueTransformer
      def transformedValue(value)
        value.length
      end
    end

    should "change tracked values before update" do
      @tracker.bind_toObject_withKeyPath_options(
                   "value", @changer, "value", 
                   NSValueTransformerBindingOption =>
                                  LengthValueTransformer.alloc.init)
      @changer.value = "new value"
      assert_equal("new value".length, @tracker.value)
    end

    should "have names that can be used instead of instances" do
      @changer.value = false
      @tracker.value = "some value clearly not boolean"
      @tracker.bind_toObject_withKeyPath_options(
                   "value", @changer, "value", 
                   NSValueTransformerNameBindingOption =>
                                  NSNegateBooleanTransformerName)
      assert_equal(true, @tracker.value.to_ruby)
    end

  end

end


