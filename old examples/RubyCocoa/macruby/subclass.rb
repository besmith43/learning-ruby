#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
framework 'Cocoa'

 class Definitions
   def printThis(first, andThis: second)
     puts first, second
   end
 end


 class SubClass < Definitions
   def printThis first, andThis: second
     sorted = [first, second].sort
     super sorted[0], sorted[1]   # (1)
   end
 end


if $0 == __FILE__
  SubClass.alloc.init.printThis 3, andThis: 1
end
