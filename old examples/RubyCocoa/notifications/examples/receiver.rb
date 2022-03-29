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

class Controller < NSObject
  def init
    super_init
    center = NSDistributedNotificationCenter.defaultCenter  # (1) 
    center.addObserver_selector_name_object(self, :next_number,
                                            "next number",
                                            "com.exampler.sender")
    self
  end
  
  def next_number(notification)
    name = notification.name
    app = notification.object
    info = notification.userInfo
    number = info['value']
    puts "#{app} sez #{name} #{number}"
  end
end

if $0 == __FILE__
  Controller.alloc.init
  NSApplication.sharedApplication
  NSApp.run  # (2) 
end
