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

class RubyCocoaFlexmockExample < Test::Unit::TestCase

  # If the Cocoa code requires a method to be defined but it's not 
  # used, it has to be declared with the special form of 
  # 'should_receive'.
  context "a combo box" do

    setup do
      @sut = NSComboBox.alloc.init
      @mock = rubycocoa_flexmock
      @mock.should_receive(:comboBox_objectValueForItemAtIndex, 2).
            zero_or_more_times.by_default
    end

    should "ask twice for number of items upon initialization" do
      during {
        @sut.usesDataSource = true
        @sut.setDataSource(@mock)
      }.behold! {
        @mock.should_receive(:numberOfItemsInComboBox, 0).twice
      }
    end
  end
end
