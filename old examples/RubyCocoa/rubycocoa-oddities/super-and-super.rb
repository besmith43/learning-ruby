#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'

# This file shows that the RubyCocoa super_x way of calling a
# superclass method ONLY looks in an Objective-C object, not a
# superclass that's defined in Ruby.

class RubyFromObjC < OSX::NSObject
  def description
    "Some kind of RubyFromObjC"
  end
end

class RubyFromRuby < RubyFromObjC
  def description
    "super_description says: " + super_description +
      "\nbut super says: " + super + 
      "\nThe super_description comes from NSObject#description."
  end
end

if $0 == __FILE__
  puts RubyFromRuby.alloc.init.description
end
    
