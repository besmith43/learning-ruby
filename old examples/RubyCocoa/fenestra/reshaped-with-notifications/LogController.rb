#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Controller'

class LogController < Controller
  ib_outlets :log


  def awakeFromNib
    @log.clear

    Center.addObserver_selector_name_object(self, :note_choice,  # (1) 
                                            AppChosen, nil)
    Center.addObserver_selector_name_object(self, :forget_app,
                                            TimeToForgetApp, nil)
    Center.addObserver_selector_name_object(self, :log_app_fact,
                                            AppFactAvailable, nil)
  end



  def note_choice(notification)
    @log.addLine("Logging started for '#{notification.userInfo[:app_name]}'...")
  end


  def forget_app(notification)
    @log.addLine("Logging finished for '#{notification.userInfo[:app_name]}'.")
  end
  
  def log_app_fact(notification)
    @log.addLine(notification.userInfo[:message])
  end
  
end
