#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../../sandbox")
require 'testutil'


def exclaimify(notification)
  s = notification.object.string
  s.replaceCharactersInRange_withString(NSRange.new(0, 1), "!")
end

# There are some oddities when it comes to mocking delegate objects.

class DelegateExample < Test::Unit::TestCase

  class Delegate < NSObject
    def textStorageWillProcessEditing(notification)
      exclaimify(notification)
    end
  end

  context "NSTextStorage" do
    setup do 
      @sut = NSTextStorage.alloc.init
    end
    
    should "obey delegate edits" do
      @delegate = Delegate.alloc.init
      @sut.delegate = @delegate
      @sut.replaceCharactersInRange_withString(NSRange.new(0,0), "FF")
      assert { @sut.string == "!F" }
    end

    should "obey delegate edits (flexmock version)" do
      @delegate = flexmock(NSObject.alloc.init)
      @sut.delegate = @delegate
      during { 
        @sut.replaceCharactersInRange_withString(NSRange.new(0,0), "FF")
      }.behold! {
        # NSTextStorage can't see mock methods.
        @delegate.should_receive(:textStorageWillProcessEditing).never
      }
      # Therefore nothing gets changed.
      assert { @sut.string == "FF" }
    end

    should "obey delegate edits (mysteriously broken rubycocoa_flexmock version)" do
      @delegate = rubycocoa_flexmock
      @sut.delegate = @delegate
      during { 
        @sut.replaceCharactersInRange_withString(NSRange.new(0,0), "FF")
      }.behold! {
        # Why is this delegate method not found?
        @delegate.should_receive(:textStorageWillProcessEditing, 1).never
      }
      # Because it wasn't found, nothing gets changed.
      assert { @sut.string == "FF" }
    end

    should "obey delegate edits (rubycocoa_flexmock version)" do
      @delegate = rubycocoa_flexmock
      @delegate.should_receive(:textStorageWillProcessEditing, 1).once.
        and_return { | notification |
        exclaimify(notification)
        nil  # method declared with void type
      }
      @sut.delegate = @delegate

      @sut.replaceCharactersInRange_withString(NSRange.new(0,0), "FF")
      assert { @sut.string == "!F" }
    end

  end

end
