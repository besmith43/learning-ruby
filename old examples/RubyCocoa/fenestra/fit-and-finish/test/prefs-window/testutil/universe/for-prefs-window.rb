#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module PrefsWindowTests

  module PrefsWindowUtils
    include OSX
    include NotificationTestSupport
    include TableCreation
    include UserDefaultsHelpers
    include TableOperations

    def the_universe_revolves_around(ignored_sut_only_for_documentation)
      create_table_with(real_columns)
      @add_button = NSButton.alloc.init
      @remove_button = NSButton.alloc.init
      yield if block_given?
    end

    def connect_objects_in_universe
      make_fake_defaults_controller unless @defaults_controller
      @preferences_controller.useDefaultsController(@defaults_controller)
      @preferences_controller.table = @table

      @add_button.target = @remove_button.target = @preferences_controller
      @add_button.action = 'add:'
      @remove_button.action = 'remove:'
      # Above: The reasons for the colons (that is, for using the
      # 'true' selector name): IFF there is a Ruby method w/o colon
      # defined in a class, the Cocoa selector-lookup process will
      # locate it. If that method is only defined in the superclass,
      # selector lookup won't see it.
    end

    def disconnect_objects_in_universe
      @preferences_controller.disconnect_all_notification_observers
      no_more_watchers
    end

    def awaken_all_objects
      @preferences_controller.awakeFromNib
    end

  end


end
