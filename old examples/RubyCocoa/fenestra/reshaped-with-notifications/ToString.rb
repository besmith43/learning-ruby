#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Translators
  class ToString < OSX::NSObject
    include OSX
    include Announcements

    def initForApp(app)  #(1) 
      @app = app
      init
    end

    def listen  # (2) 
      center = NSDistributedNotificationCenter.defaultCenter
      center.addObserver_selector_name_object(self, :translate,
                                              nil, @app)
    end

    def translate(notification)   # (3)
      center = NSNotificationCenter.defaultCenter
      center.postNotificationName_object_userInfo(
                  AppFactAvailable, self,
                  :message => notification.to_s)
    end

  end
end
