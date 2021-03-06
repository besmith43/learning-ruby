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

require "flexmock/base"
require "flexmock/test_unit"

class TestFlexmockTestUnit < Test::Unit::TestCase
  def teardown
    super
  end

  # This test should pass.
  def test_can_create_mocks
    m = flexmock("mock")
    m.should_receive(:hi).once
    m.hi
  end
  
  # This test should fail during teardown.
  def test_should_fail__mocks_are_auto_verified
    m = flexmock("mock")
    m.should_receive(:hi).once
  end
end