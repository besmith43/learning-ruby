#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'osx/cocoa'
include OSX

Center = NSNotificationCenter.defaultCenter

class Receiver < NSObject
  def init
    Center.addObserver_selector_name_object(self, 'handle_notification',
                                            "notification name", nil)
  end
  
  def handle_notification(notification)
    puts notification
  end
end

class Sender < NSObject
  def announce

    Center.postNotificationName_object("notification name", self)

  end
end

if $0 == __FILE__
  Receiver.alloc.init
  Sender.alloc.init.announce
end
