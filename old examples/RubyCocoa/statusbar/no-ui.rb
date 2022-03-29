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

class AppDelegate < NSObject  # (1)
  def applicationDidFinishLaunching(aNotification)   # (2) 
    puts "#{aNotification.name} makes me say: Hello, world"
  end
end

our_object = AppDelegate.alloc.init # (3) 
NSApplication.sharedApplication          # Creates global NSApp
NSApp.setDelegate(our_object)       # (4) 
NSApp.run                         
