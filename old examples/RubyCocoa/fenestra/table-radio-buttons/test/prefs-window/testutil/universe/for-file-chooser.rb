#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module PrefsWindowTests
  module RubyFileChooserControllerUniverse
    include OSX
    include NotificationTestSupport

    def the_universe_revolves_around(ignored_sut_only_for_documentation)
      unless @chooser_panel
        @chooser_panel = rubycocoa_flexmock(NSOpenPanel) do | klass | 
          klass.openPanel
        end
        @chooser_panel.should_receive(:runModalForTypes, 1). # and ignore
                       by_default
      end 
      yield if block_given?
    end

    def connect_objects_in_universe
      @ruby_chooser_controller.initWithPanel(@chooser_panel)
    end

    def disconnect_objects_in_universe
      no_more_watchers
      @ruby_chooser_controller.disconnect_all_notification_observers
    end

    def awaken_all_objects
      @ruby_chooser_controller.awakeFromNib
    end
  end

end
