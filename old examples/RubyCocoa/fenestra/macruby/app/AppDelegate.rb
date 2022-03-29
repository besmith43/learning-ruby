#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

class AppDelegate

  def self.starting_defaults
    only = TranslatorPreference.alloc.initWithHash(
                :display_name => "sample webapp com.exampler.counting",
                :app_name => "com.exampler.counting",
                :class_name => 'CountingApp',
                :favorite => true,
                :source => '')
    defaults = NSUserDefaults.standardUserDefaults
    transformer = DataArrayTransformer.alloc.init
    archived = transformer.reverseTransformedValue([only])
    defaults.registerDefaults(:translators => archived)

  end

  starting_defaults

  def changePreferences(sender)
    unless @wc
      @wc = NSWindowController.alloc.initWithWindowNibName("Preferences")
    end
    @wc.showWindow(self)
    @wc.window.makeKeyWindow
  end
end
