#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class MainWindowController < Controller
  ib_outlet :window

  def awakeFromNib
    @window.title = NO_APP_DESIGNATION
    super 
  end
  
  on_local_notification AppChosen do | notification |
    @window.title = notification[:app_name]
  end

  on_local_notification TimeToForgetApp do | notification | 
    @window.title = NO_APP_DESIGNATION
  end

  delegate_method :windowWillClose do | notification | 
    NSApp.terminate(self)
  end
end
