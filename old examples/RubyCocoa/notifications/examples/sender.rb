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
    count = 100
    1.upto(count) do | i |
      puts "#{count - i} more notifications to post." if i % 25 == 0 
      announce(i)
      sleep 1
    end
    puts "Sender will now stop posting notifications."
    exit
  end
  
  def announce(number)
    center = NSDistributedNotificationCenter.defaultCenter  # (1) 
    name = "next number"
    app = "com.exampler.sender"  
    center.postNotificationName_object_userInfo(name, app,  # (2)
                                                'value' => number)
  end
end

if $0 == __FILE__
  Controller.alloc.init   # (3) 
end
