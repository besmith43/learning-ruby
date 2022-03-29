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
    statusbar = NSStatusBar.systemStatusBar
    status_item = statusbar.statusItemWithLength(NSVariableStatusItemLength)

    image = NSImage.alloc.initWithContentsOfFile("stretch.tiff")

    status_item.setImage(image)
    SpeechController.alloc.init.add_menu_to(status_item) # (1)
  end
end



class SpeechController < NSObject
  def init 
    super_init        #(2)

    @synthesizer = NSSpeechSynthesizer.alloc.init 

    self              #(3)
  end

  

  def add_menu_to(container)
    menu = NSMenu.alloc.init                    # (4)
    container.setMenu(menu)


    menu_item = menu.addItemWithTitle_action_keyEquivalent(     # (5)
                         "Speak", "speak:", '')
    menu_item.setTarget(self)                         # (6)


    menu_item = menu.addItemWithTitle_action_keyEquivalent(
                         "Quit", "terminate:", 'q')                # (7) 
    menu_item.setKeyEquivalentModifierMask(NSCommandKeyMask)   # (8)
    menu_item.setTarget(NSApp)                       # (9)
  end

  def speak(sender)         # (10)
    @synthesizer.startSpeakingString("I have nothing to say.")
  end
end


NSApplication.sharedApplication
NSApp.setDelegate(App.alloc.init)
NSApp.run
