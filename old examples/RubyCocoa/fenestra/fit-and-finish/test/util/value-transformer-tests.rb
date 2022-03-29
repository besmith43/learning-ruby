#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")
require File.dirname(__FILE__) + "/testutil"


class ValueTransformerTests < Test::Unit::TestCase
  include OSX

  context "OffStateMeansTrueTransformer" do
    setup do
      @transformer = OffStateMeansTrueTransformer.alloc.init
    end
    
    should "convert NSOffState to true" do
      assert { @transformer.transformedValue(NSOffState) }
    end

    should "convert NSOnState to false" do 
      deny { @transformer.transformedValue(NSOnState) }
    end

    # There is such a thing as the mixed state, but we don't support it.
    should "raise otherwise" do
      assert_raises(RuntimeError) {
        @transformer.transformedValue(NSMixedState)
      }
    end
  end  

  context "OffStateMeansEnabledColorTransformer" do

    setup do
      @transformer = OffStateMeansEnabledColorTransformer.alloc.init
    end
    
    should "convert button-off to enabled color" do
      assert { ENABLED_COLOR == @transformer.transformedValue(NSOffState) }
    end

    should "convert button-on to disabled color" do
      assert { DISABLED_COLOR == @transformer.transformedValue(NSOnState) }
    end

    should "raise otherwise" do
      assert_raises(RuntimeError) {
        @transformer.transformedValue(NSMixedState)
      }
    end
  end

end
