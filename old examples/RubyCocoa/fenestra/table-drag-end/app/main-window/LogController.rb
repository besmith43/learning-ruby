#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class LogController < Controller
  ib_outlets :log

  def awakeFromNib
    @log.clear
    super
  end

  on_local_notification AppChosen do | notification | 
    @log.addLine("Logging started for '#{notification.userInfo[:app_name]}'...")
  end

  on_local_notification TimeToForgetApp do | notification | 
    @log.addLine("Logging finished for '#{notification.userInfo[:app_name]}'.")
  end

  on_local_notification AppFactAvailable do | notification | 
    @log.addLine(notification.userInfo[:message])
  end
  
end
