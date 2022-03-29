#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module PrefsWindowTests
  module TableViewUtils
    include OSX
    include UserDefaultsHelpers
    include TableCreation
    include TableOperations
    include NotificationTestSupport

    def the_universe_revolves_around(ignored_sut_only_for_documentation)
      @preferences_controller = rubycocoa_flexmock(PreferencesController)
      @window = NSWindow.alloc.objc_send(:initWithContentRect, NSRect.new(3000, 3000, 500, 500),
                                         :styleMask, NSTitledWindowMask,
                                         :backing, NSBackingStoreBuffered,
                                         :defer, true)
      yield if block_given?
    end

    def connect_objects_in_universe
      make_fake_defaults_controller unless @defaults_controller
      @preferences_controller.useDefaultsController(@defaults_controller)
      @preferences_controller.table = @table
      @window.contentView.addSubview(@table)
    end

    def put_table_frame_at(point)
      @table.frame = 
        NSRect.new(point.x, point.y, @table.frame.width, @table.frame.height)
    end

    def disconnect_objects_in_universe
      @preferences_controller.disconnect_all_notification_observers
      no_more_watchers
    end

    def awaken_all_objects
      @preferences_controller.awakeFromNib
      @table.awakeFromNib
    end
  end
end
