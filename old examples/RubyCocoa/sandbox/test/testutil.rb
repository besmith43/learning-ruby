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

require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'test/mock-talk'
require 'assert2'

def key_event(modifier, key)
  NSEvent.objc_send(:keyEventWithType, NSKeyDown,
                    :location, NSPoint.new(0, 0),
                    :modifierFlags, modifier,
                    :timestamp, 1.0,
                    :windowNumber, 1,
                    :context, nil,
                    :characters, key,
                    :charactersIgnoringModifiers, key,
                    :isARepeat, false,
                    :keyCode, 3)
end

def control_a(event)
  event.charactersIgnoringModifiers == 'a'  &&
    event.modifierFlags == NSControlKeyMask
end

def command_a(event)
  event.charactersIgnoringModifiers == 'a'  &&
    event.modifierFlags == NSCommandKeyMask
end

def center; NSNotificationCenter.defaultCenter; end
