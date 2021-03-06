#!/usr/local/bin/ruby -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

$TESTING = true

require 'composite_sexp_processor'
require 'test/unit'

class FakeProcessor1 < SexpProcessor # ZenTest SKIP

  def initialize
    super
    self.warn_on_default = false
    self.default_method = :default_processor
    self.expected = Array
  end

  def default_processor(exp)
    result = []
    result << exp.shift
    until exp.empty? do
      result << exp.shift.to_s + " woot"
    end
    result
  end
end

class TestCompositeSexpProcessor < Test::Unit::TestCase

  def setup
    @p = CompositeSexpProcessor.new
  end

  def test_process_default
    data = [1, 2, 3]
    result = @p.process(data.dup)
    assert_equal(data.dup, result)
  end

  def test_process_fake1
    data = [:x, 1, 2, 3]
    @p << FakeProcessor1.new
    result = @p.process(data.dup)
    assert_equal [:x, "1 woot", "2 woot", "3 woot"], result
  end

  def test_process_fake1_twice
    data = [:x, 1, 2, 3]
    @p << FakeProcessor1.new
    @p << FakeProcessor1.new
    result = @p.process(data.dup)
    assert_equal [:x, "1 woot woot", "2 woot woot", "3 woot woot"], result
  end

  def test_processors
    # everything is tested by test_append
  end

  def test_append
    assert_equal([], @p.processors)

    assert_raises(ArgumentError) do
      @p << 42
    end

    fp1 = FakeProcessor1.new
    @p << fp1
    assert_equal([fp1], @p.processors)
  end

end
