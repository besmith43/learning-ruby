#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'
require 'ostruct'
include OSX


class FakeTextField < NSObject

  attr_accessor :value


  def bind_toObject_withKeyPath_options(myProperty, 
            thatObject, thatProperty, options)
    if myProperty == "value"
      @value_binder = OpenStruct.new(:object => thatObject,
                                    :property => thatProperty)
                                                 
    end
    super_bind_toObject_withKeyPath_options(myProperty,
            thatObject, thatProperty, options)
  end




  def user_changes_text(newValue)
    @value = newValue
    if @value_binder
      @value_binder.object.setValue_forKeyPath(newValue, 
                                        @value_binder.property)
    end

  end
end


require 'util'

class PretendViewTests < Test::Unit::TestCase

  class FakeController < NSObject
    kvc_accessor :source
  end

  context "a binding" do
    setup do
      @textField = FakeTextField.alloc.init
      @controller = FakeController.alloc.init
      @controller.source = "original"
      @textField.bind_toObject_withKeyPath_options(
           "value", @controller, 'source', nil)
    end

    should "reflect changed controller value into text field" do
      @controller.source = "new value"
      assert_equal("new value", @textField.value)
    end

    should "reflect changed text field value into controller" do
      @textField.user_changes_text("some typing")
      assert_equal("some typing", @controller.source)
    end
  end
end
