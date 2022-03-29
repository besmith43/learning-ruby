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

class AppChoiceControllerTest < Test::Unit::TestCase
  include OSX
  include UserDefaultsHelpers

  def setup
    super
    make_fake_preferences_facade({ :display_name => 'other name',
                                   :favorite => false },
                                 { :display_name => 'favorite name',
                                   :favorite => true })

    @sut = AppChoiceController.alloc.init
    @sut.preferences = @pref_facade
    @sut.comboBox = @combo_box = NSComboBox.alloc.init
    @sut.button = @button = NSButton.alloc.init
    @sut.label = @label = NSTextField.alloc.init
    @sut.awakeFromNib
  end

  context "initialization" do

    should "set default choice of combo box to display name of favorite translator" do
      assert { @combo_box.stringValue == 'favorite name' }
    end

    should "set up the preferences object as combo box data source" do
      assert { @combo_box.usesDataSource } 
      assert { @sut == @combo_box.dataSource }
    end

    should "have enabled combo box (and label next to it, too)" do
      assert { @combo_box.enabled? } 
      assert { ENABLED_COLOR == @label.textColor }
    end
  end

  context "combo box" do
    should "be bound to button state" do
      assert { @combo_box.enabled? }
      @button.state = NSOnState
      deny { @combo_box.enabled? }
      @button.state = NSOffState
      assert { @combo_box.enabled? }
    end

    should "have label whose color is bound to button state" do
      assert { ENABLED_COLOR == @label.textColor }
      @button.state = NSOnState
      assert { DISABLED_COLOR == @label.textColor }
      @button.state = NSOffState
      assert { ENABLED_COLOR == @label.textColor }
    end
  end

  context "button clicks" do
    should "normally NOT inform observers of state changes" do 
      assert { @combo_box.enabled? }
      @button.performClick('ignored')
      assert { @combo_box.enabled? }
    end

    should "be made to inform observers when target is chooseOrHeal." do 
      @button.target = @sut
      @button.action = :chooseOrHeal
      @button.performClick('ignored')
      deny { @combo_box.enabled? } 
    end
  end
  
  context "objectValueForItemAtIndex" do
    setup do 
      @shorthand = lambda { | index |
        @sut.objc_send(:comboBox, @combo_box,
                       :objectValueForItemAtIndex, index)
      }
    end

    should "retrieve dispay names stored in preferences" do
      assert { "other name" ==  @shorthand.call(0)}
      assert { "favorite name" == @shorthand.call(1) }
    end
  end

  context "indexOfItemWithStringValue" do
    setup do 
      @shorthand = lambda { | string |
        @sut.objc_send(:comboBox, @combo_box,
                       :indexOfItemWithStringValue, string)
      }
    end

    should "discover display names that match" do 
      assert { 1 == @shorthand.call("favorite name") }
    end

    should "return NotFound indicator when no matching entry" do 
      assert { NSNotFound == @shorthand.call("favorite nam") }
    end
  end
end

