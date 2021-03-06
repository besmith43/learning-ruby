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
class TestAnEmptyInvocationChain < Test::Unit::TestCase

  def setup
    @empty = Rake::InvocationChain::EMPTY
  end

  def test_should_be_able_to_add_members
    assert_nothing_raised do
      @empty.append("A")
    end
  end

  def test_to_s
    assert_equal "TOP", @empty.to_s
  end
end

######################################################################
class TestAnInvocationChainWithOneMember < Test::Unit::TestCase
  def setup
    @empty = Rake::InvocationChain::EMPTY
    @first_member = "A"
    @chain = @empty.append(@first_member)
  end

  def test_should_report_first_member_as_a_member
    assert @chain.member?(@first_member)
  end

  def test_should_fail_when_adding_original_member
    ex = assert_raise RuntimeError do
      @chain.append(@first_member)
    end
    assert_match(/circular +dependency/i, ex.message)
    assert_match(/A.*=>.*A/, ex.message)
  end

  def test_to_s
    assert_equal "TOP => A", @chain.to_s
  end

end

######################################################################
class TestAnInvocationChainWithMultipleMember < Test::Unit::TestCase
  def setup
    @first_member = "A"
    @second_member = "B"
    ch = Rake::InvocationChain::EMPTY.append(@first_member)
    @chain = ch.append(@second_member)
  end

  def test_should_report_first_member_as_a_member
    assert @chain.member?(@first_member)
  end

  def test_should_report_second_member_as_a_member
    assert @chain.member?(@second_member)
  end

  def test_should_fail_when_adding_original_member
    ex = assert_raise RuntimeError do
      @chain.append(@first_member)
    end
    assert_match(/A.*=>.*B.*=>.*A/, ex.message)
  end
end


