#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class AppDelegate < OSX::NSObject
  include OSX

  def changePreferences(sender)
    puts "Will launch preference panel"
    unless @wc
      @wc = NSWindowController.alloc.initWithWindowNibName("Preferences")
    end
    @wc.showWindow(self)
    @wc.window.makeKeyWindow
  end
end
