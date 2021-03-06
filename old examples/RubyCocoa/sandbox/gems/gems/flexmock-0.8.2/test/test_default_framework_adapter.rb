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

require "test/unit"
require "flexmock"

class TestFlexmockDefaultFrameworkAdapter < Test::Unit::TestCase
  def setup
    @adapter = FlexMock::DefaultFrameworkAdapter.new
  end

  def test_assert_block_raises_exception  
    ex = assert_raise(FlexMock::DefaultFrameworkAdapter::AssertionFailedError) { 
      @adapter.assert_block("failure message") { false }
    }
  end

  def test_assert_block_doesnt_raise_exception
    @adapter.assert_block("failure message") { true }
  end
  
  def test_assert_equal_doesnt_raise_exception
    @adapter.assert_equal("a", "a", "no message")
  end
  
  def test_assert_equal_can_fail
    ex = assert_raise(FlexMock::DefaultFrameworkAdapter::AssertionFailedError) {
      @adapter.assert_equal("a", "b", "a should not equal b")
    }
  end
end