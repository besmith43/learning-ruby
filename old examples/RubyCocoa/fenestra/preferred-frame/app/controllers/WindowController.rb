#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'controllers/Controller'

module Controllers


  class WindowController < Controller
    ib_outlet :logWindow, :preferences



    def awakeFromNib
      @logWindow.setFrame_display(@preferences.sole_window_frame, true)
    end

    
    on_local_notification AppChosen do | notification | 
      @logWindow.title = notification[:app_name]
    end

    on_local_notification TimeToForgetApp do | notification | 
      @logWindow.title = "- No App -" 
    end

    delegate_method :windowWillClose do | notification | 
      NSApp.terminate(self)
    end

  end
end
