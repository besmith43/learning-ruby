#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/testutil'
require 'ostruct'

module MainWindowNib
  include OSX
  include UserDefaultsHelpers

  def create_main_window_nib_objects
    @main_window = OpenStruct.new(:title => :some_invalid_value)
    @button = NSButton.alloc.init
    @combo_box = NSComboBox.alloc.init
    @log = NSTextView.alloc.init
    @label = NSTextField.alloc.init

    @pref_facade = NameOrientedPreferencesFacade.alloc
    @main_window_controller = MainWindowController.alloc.init
    @app_choice_controller = AppChoiceController.alloc.init
    @log_controller = LogController.alloc.init
  end

  def connect_main_window_nib_objects

    # We're forcing local notifications. They're delivered based on object
    # identity, so we have to use to_ns here.
    @app_name = "com.exampler.test-app".to_ns
    Notifiable.use_notification_object(@app_name)
    Notifiable.force_local_notifications

    @pref_facade.initWithDefaultsController(@defaults_controller)

    @main_window_controller.window = @main_window
    
    @button.target = @app_choice_controller
    @button.action = :chooseOrHeal
    
    @app_choice_controller.preferences = @pref_facade
    @app_choice_controller.comboBox = @combo_box
    @app_choice_controller.button = @button
    @app_choice_controller.label = @label

    @log_controller.log = @log
  end

  def disconnect_main_window_nib_objects
    @main_window_controller.disconnect_all_notification_observers
    @app_choice_controller.disconnect_all_notification_observers
    @log_controller.disconnect_all_notification_observers
    Notifiable.forget_notification_object
    Notifiable.resume_remote_notifications
  end

  def main_window_awake_from_nib
    @main_window_controller.awakeFromNib
    @log_controller.awakeFromNib
    @app_choice_controller.awakeFromNib
  end

end


