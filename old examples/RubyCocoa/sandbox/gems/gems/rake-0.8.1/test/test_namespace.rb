#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

begin
  require 'rubygems'
rescue LoadError
  # got no gems
end

require 'test/unit'
require 'flexmock/test_unit'
require 'rake'

class TestNameSpace < Test::Unit::TestCase

  def test_namespace_creation
    mgr = flexmock("TaskManager")
    ns = Rake::NameSpace.new(mgr, [])
    assert_not_nil ns
  end

  def test_namespace_lookup
    mgr = flexmock("TaskManager")
    mgr.should_receive(:lookup).with(:t, ["a"]).
      and_return(:dummy).once
    ns = Rake::NameSpace.new(mgr, ["a"])
    assert_equal :dummy, ns[:t]
  end

  def test_namespace_reports_tasks_it_owns
    mgr = flexmock("TaskManager")
    mgr.should_receive(:tasks).with().
      and_return([:x, :y, :z]).once
    ns = Rake::NameSpace.new(mgr, ["a"])
    assert_equal [:x, :y, :z], ns.tasks
  end
end
