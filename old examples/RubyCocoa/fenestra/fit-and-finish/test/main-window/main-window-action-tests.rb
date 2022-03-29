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

class MainWindowFenestrationTest < Test::Unit::TestCase
  include MainWindowNib

  def setup
    super
    make_fake_defaults_controller({ :display_name => 'other',
                                    :app_name => @app_name,
                                    :class_name => "ToString",
                                    :favorite => false },
                                  { :display_name => 'favorite name',
                                    :app_name => @app_name,
                                    :class_name => "ToString",
                                    :favorite => true })
    create_main_window_nib_objects
    connect_main_window_nib_objects
    main_window_awake_from_nib
  end

  def teardown
    disconnect_main_window_nib_objects
    super
  end

  context "The act of fenestration (one click)" do
    setup do
      # For this case, just choose the favorite.
      assert { "favorite name" == @combo_box.stringValue }
      @button.performClick('ignored sender')  
    end

    should "change the button text" do
      assert { /Heal/ =~ @button.displayed_text }
    end

    should "put a note in the logging text box" do
      assert { /started/ =~ @log.displayed_text } 
    end

    should "change the window title to the fenestrated app's displayed name" do
      assert { 'favorite name' == @main_window.title } 
    end

    should "disable the combo box" do
      deny { @combo_box.enabled? }
    end

    should "make the combo box's label look disabled" do
      assert { DISABLED_COLOR == @label.textColor }
    end

    should "log to the text box as notifications arrive from a remote app" do
      @outbox = NotificationOutBox.new(:local, :object => @app_name)
      @outbox.post("This will appear")
      assert { /This will appear/ =~ @log.displayed_text }
    end
  end

  context "The act of healing (two clicks)" do
    setup do
      # For this case, choose new app
      @combo_box.stringValue = 'new app'
      @button.performClick('ignored')
      @button.performClick('ignored')
    end

    should "revert the button text" do
      assert { /Fenestrate/ =~ @button.displayed_text }
    end

    should "put a note in the logging text box" do
      assert { /started.*new app.*finished.*new app/m =~ @log.displayed_text } 
    end

    should "change the window title back to original 'no app' value" do
      assert { NO_APP_DESIGNATION == @main_window.title } 
    end

    should "enable the combo box" do
      assert { @combo_box.enabled? }
    end

    should "make the combo box label look enabled" do
      assert { ENABLED_COLOR == @label.textColor }
    end

    should "no longer perform logging as notifications arrive" do
      @outbox = NotificationOutBox.new(:local, :object => @app_name)
      @outbox.post("This will NOT appear")
      deny { /This will NOT appear/ =~ @log.displayed_text }
    end
  end


  context "choosing non-favorite app to fenestrate" do
    should  "make that element the favorite" do
      @combo_box.pick_index(0)
      @button.performClick('ignored')
      assert { 'other' == @pref_facade.display_name_of_favorite_translator }
    end
  end

  context "typing in a new app name" do
    setup do 
      @combo_box.stringValue = "a new app name"
      @button.performClick('ignored')
    end
    
    should "add that app to the combo box list" do
      assert { @defaults_controller.find_by_display_name('a new app name') }
    end

    should "make that new app the favorite" do
      newbie = @defaults_controller.find_by_display_name('a new app name')
      assert { newbie.favorite } 
    end
  end

end

