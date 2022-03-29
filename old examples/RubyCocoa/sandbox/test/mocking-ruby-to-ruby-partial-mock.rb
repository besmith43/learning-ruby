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

class RubyToRubyWithPartialExample < Test::Unit::TestCase

  class R2RPartialControllerUnderTest < NSObject
    ib_outlet :button

    def awakeFromNib
      @button.enabled = false
      # ...
    end

    ib_action :do_something_changing_button do | ignored_sender |
      @button.enabled = true
      @button.performKeyEquivalent(key_event(NSControlKeyMask, 'a'))
      # ... more work ...
    end
  end

  context "action that coincidentally changes a button" do
    setup do
      @sut = R2RPartialControllerUnderTest.alloc.init
      @sut.button = @button = flexmock(NSButton.alloc.init, 'button')
      @sut.awakeFromNib
    end

    should "send a control-a key event" do
      during { 
        @sut.do_something_changing_button(nil)
      }.behold! {
        @button.should_receive(:performKeyEquivalent).
                ordered.once.with(on { | event | control_a(event) } )
      }
    end

    should "enable disabled button (mock version)" do 
      during {
        @sut.do_something_changing_button(nil)
      }.behold! {
        @button.should_receive(:enabled=).
                ordered.once.with(true)
      }
      # assert { @button.enabled? }
    end

    should "enable disabled button" do
      @button.enabled = false
      @sut.do_something_changing_button(nil)
      assert { @button.enabled? } 
    end

    should "enable button before key event" do
      during {
        @sut.do_something_changing_button(nil)
      }.behold! {
        @button.should_receive(:enabled=).
                ordered.once.with(true)
        @button.should_receive(:performKeyEquivalent).
                ordered.once.with(on { | event | control_a(event) } )
      }
    end

  end

end
