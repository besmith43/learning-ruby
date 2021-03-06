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

require 'flexmock/base'

class FlexMock
  
  class RSpecFrameworkAdapter
    def assert_block(msg, &block)
      Spec::Expectations.fail_with(msg) unless yield
    end

    def assert_equal(a, b, msg=nil)
      message = msg || "Expected equal"
      assert_block(message + "\n<#{a}> expected, but was\n<#{b}>") { a == b }
    end

    class AssertionFailedError < StandardError; end
    def assertion_failed_error
      Spec::Expectations::ExpectationNotMetError
    end
  end

  @framework_adapter = RSpecFrameworkAdapter.new

end