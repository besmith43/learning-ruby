require "test/unit"

$:.unshift File.dirname(__FILE__) + "/../ext/ruby_newt"
require "ruby_newt.so"

class TestRubyNewtExtn < Test::Unit::TestCase
  def test_truth
    assert true
  end
end