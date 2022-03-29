#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Notifiable'

module Translators
  class Translator < OSX::NSObject
    include OSX
    include Announcements
    include Notifiable

    def initForApp(app) 
      @app = app
      @outgoing = NotificationOutbox.new(:local, :sender => self)
      init
    end
    
    def listen
      connect_all_notification_observers
    end

    def translate_as(string)
      @outgoing.post(AppFactAvailable, :message => string)
    end

    on_local_notification TimeToForgetApp do | notification |
      disconnect_all_notification_observers
    end

    testable

    attr_reader :app
  end
end
