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
    @speech_controller = SpeechController.alloc.init
    @speech_controller.add_menu_to(status_item)
  end

  def applicationShouldTerminate(sender)
    @speech_controller.number_of_utterances >= 2
  end
end

class SpeechController < NSObject
  attr_reader :number_of_utterances
  
  def init
    super_init
    @synthesizer = NSSpeechSynthesizer.alloc.init
    @number_of_utterances = 0
    self
  end
  
  def add_menu_to(container)           
    menu = NSMenu.alloc.init           
    container.setMenu(menu)

    menu_item = menu.addItemWithTitle_action_keyEquivalent( 
                         "Speak", "speak:", '')
    menu_item.setTarget(self)          

    menu_item = menu.addItemWithTitle_action_keyEquivalent(
                         "Quit", "terminate:", 'q')   
    menu_item.setKeyEquivalentModifierMask(NSCommandKeyMask) 
    menu_item.setTarget(NSApp)         
  end

  def speak(sender)     
    @synthesizer.startSpeakingString("I have nothing to say.")
    @number_of_utterances += 1
  end
end

NSApplication.sharedApplication
NSApp.setDelegate(App.alloc.init)
NSApp.run
