#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Notifiable'

module Controllers
  class Controller < OSX::NSObject
    include OSX
    include Announcements
    include Notifiable
    include Delegatable

    def awakeFromNib
      connect_all_notification_observers
      @outbox = NotificationOutBox.new(:local, :object => self)
    end

    def post(*args); @outbox.post(*args); end
  end
end
