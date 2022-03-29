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

class MainWindowInitialAppearanceTest < Test::Unit::TestCase
  include OSX
  include MainWindowNib

  context "initial main window" do 

    setup do
      make_fake_defaults_controller({ :display_name => 'other', 
                                      :favorite => false },
                                    { :display_name => 'favorite name',
                                      :favorite => true })

      create_main_window_nib_objects
      connect_main_window_nib_objects
      main_window_awake_from_nib
    end

    teardown do 
      disconnect_main_window_nib_objects
    end

    context "window title bar" do
      should "show that no app app is being fenestrated" do
        assert { NO_APP_DESIGNATION ==  @main_window.title } 
      end
    end

    context "logging text box" do  
      should "be empty" do
        assert { @log.displayed_text.empty? }
      end
    end

    context "combo box" do
      should "show favorite display name in text box" do
        assert { 'favorite name' == @combo_box.stringValue }
      end

      should "be enabled" do
        assert { @combo_box.enabled? } 
      end

      should "have label that looks enabled" do
        assert { ENABLED_COLOR == @label.textColor }  
      end

      should "show all display names in dropdown list" do
        expected = ['other', 'favorite name'].sort
        @app_choice_controller.extend(Fenestrable)  
        actual = @app_choice_controller.fenestra.display_names.sort 
        assert { expected == actual }

        # Can get count, at least, though.
        assert { expected.length == @combo_box.numberOfItems } 
      end
    end
  end
end
