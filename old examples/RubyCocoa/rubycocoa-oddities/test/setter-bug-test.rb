#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# This demonstrates problems using setValue to change a property
# (attribute) value.

require 'test/unit'
require 'osx/cocoa'

class SetterProblemTest < Test::Unit::TestCase
  include OSX

  class Thing < OSX::NSObject
    attr_accessor :value, :sibling
    
    def initWithValue(value)
      @value = value
      init
    end
  end

  def setup
    @one = Thing.alloc.initWithValue(1)
  end

  def test_to_ns_required_for_int_conversions_on_setProperty
    # If the to_ns isn't used, the following will cause a core dump.
    # GCC 4.0.1, rubycocoa 0.13.1
    @one.setValue(-4.to_ns)
    assert_equal(-4, @one.value)

    # Notice that setting via simple assignment always works.
    @one.value = -33
    assert_equal(-33, @one.value)


    # ... as does setValue_forKey
    @one.setValue_forKey(-999, "value")
    assert_equal(-999, @one.value)
  end

  def test_strings_have_same_problem
    @one.setValue("one".to_ns)
    assert_equal("one", @one.value)
  end

  def test_nil_is_OK
    @one.setValue(nil)
    assert_equal(nil, @one.value)
  end

  def test_true_is_OK
    @one.setValue(true)
    assert_equal(true.to_ns, @one.value)
  end

  def test_NSObjects_are_OK
    @one.setValue(NSObject.alloc.init)
    assert_not_equal(1, @one.value)
  end

end

