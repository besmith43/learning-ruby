#!/usr/bin/env ruby
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

require 'test/unit'
require 'rake'

######################################################################
class TestTaskArguments < Test::Unit::TestCase
  def teardown
    ENV.delete('rev')
    ENV.delete('VER')
  end

  def test_empty_arg_list_is_empty
    ta = Rake::TaskArguments.new([], [])
    assert_equal({}, ta.to_hash)
  end

  def test_multiple_values_in_args
    ta = Rake::TaskArguments.new([:a, :b, :c], [:one, :two, :three])
    assert_equal({:a => :one, :b => :two, :c => :three}, ta.to_hash)
  end

  def test_to_s
    ta = Rake::TaskArguments.new([:a, :b, :c], [1, 2, 3])
    assert_equal ta.to_hash.inspect, ta.to_s
    assert_equal ta.to_hash.inspect, ta.inspect
  end

  def test_enumerable_behavior
    ta = Rake::TaskArguments.new([:a, :b, :c], [1, 2 ,3])
    assert_equal [10, 20, 30], ta.collect { |k,v| v * 10 }.sort
  end

  def test_named_args
    ta = Rake::TaskArguments.new(["aa", "bb"], [1, 2])
    assert_equal 1, ta.aa
    assert_equal 1, ta[:aa]
    assert_equal 1, ta["aa"]
    assert_equal 2, ta.bb
    assert_nil ta.cc
  end

  def test_args_knows_its_names
    ta = Rake::TaskArguments.new(["aa", "bb"], [1, 2])
    assert_equal ["aa", "bb"], ta.names
  end

  def test_extra_names_are_nil
    ta = Rake::TaskArguments.new(["aa", "bb", "cc"], [1, 2])
    assert_nil ta.cc
  end

  def test_args_can_reference_env_values
    ta = Rake::TaskArguments.new(["aa"], [1])
    ENV['rev'] = "1.2"
    ENV['VER'] = "2.3"
    assert_equal "1.2", ta.rev
    assert_equal "2.3", ta.ver
  end

  def test_creating_new_argument_scopes
    parent = Rake::TaskArguments.new(['p'], [1])
    child = parent.new_scope(['c', 'p'])
    assert_equal({:c => nil, :p=>1}, child.to_hash)
    assert_equal 1, child.p
    assert_equal 1, child["p"]
    assert_equal 1, child[:p]
    assert_nil child.c
  end

  def test_child_hides_parent_arg_names
    parent = Rake::TaskArguments.new(['aa'], [1])
    child = Rake::TaskArguments.new(['aa'], [2], parent)
    assert_equal 2, child.aa
  end
end
