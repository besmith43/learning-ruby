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

class TestEarlyTime < Test::Unit::TestCase
  def test_create
    early = Rake::EarlyTime.instance
    time = Time.mktime(1920, 1, 1, 0, 0, 0)
    assert early <= Time.now
    assert early < Time.now
    assert early != Time.now
    assert Time.now > early
    assert Time.now >= early
    assert Time.now != early
  end

  def test_equality
    early = Rake::EarlyTime.instance
    assert_equal early, early, "two early times should be equal"
  end

  def test_original_time_compare_is_not_messed_up
    t1 = Time.mktime(1920, 1, 1, 0, 0, 0)
    t2 = Time.now
    assert t1 < t2
    assert t2 > t1
    assert t1 == t1
    assert t2 == t2    
  end

  def test_to_s
    assert_equal "<EARLY TIME>", Rake::EARLY.to_s
  end
end
