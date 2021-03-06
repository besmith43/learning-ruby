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
#
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#+++

require 'flexmock/noop'

class FlexMock
  ####################################################################
  # Match any object
  class AnyMatcher
    def ===(target)
      true
    end
    def inspect
      "ANY"
    end
  end

  ####################################################################
  # Match only things that are equal.
  class EqualMatcher
    def initialize(obj)
      @obj = obj
    end
    def ===(target)
      @obj == target
    end
    def inspect
      "==(#{@obj.inspect})"
    end
  end

  ANY = AnyMatcher.new

  ####################################################################
  # Match only things where the block evaluates to true.
  class ProcMatcher
    def initialize(&block)
      @block = block
    end
    def ===(target)
      @block.call(target)
    end
    def inspect
      "on{...}"
    end
  end
  
  
end
