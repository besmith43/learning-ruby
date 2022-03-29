#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

#---
# Copyright 2003, 2004, 2005, 2006, 2007 by Jim Weirich (jim@weirichhouse.org).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#+++

class FlexMock

  # Undefined is a self preserving undefined object.  The result of
  # any interaction with the undefined object will be the undefined
  # object itself.
  class Undefined
    def method_missing(sym, *args, &block)
      self
    end

    def to_s
      "-UNDEFINED-"
    end

    def inspect
      to_s
    end

    def clone
      self
    end
    
    def coerce(other)
      [FlexMock.undefined, FlexMock.undefined]
    end
  end

  # Single instance of undefined
  @undefined = Undefined.new

  # Undefined is normally available as FlexMock.undefined
  def self.undefined
    @undefined
  end
  
  class << Undefined
    private :new
  end
end 
