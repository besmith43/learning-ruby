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

class App < NSObject
  def applicationDidFinishLaunching(aNotification)
    statusbar = NSStatusBar.systemStatusBar  # (1) 
    status_item = statusbar.statusItemWithLength(NSVariableStatusItemLength)  # (2) 

    image = NSImage.alloc.initWithContentsOfFile("stretch.tiff")  # (3) 
    raise "Icon file 'stretch.tiff' is missing." unless image # (4)

    status_item.setImage(image)  # (5) 
  end
end


NSApplication.sharedApplication
NSApp.setDelegate(App.alloc.init)
NSApp.run
