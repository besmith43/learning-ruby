#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../../sandbox")
require 'test/unit'

class SandboxTests < Test::Unit::TestCase
  def test_can_still_load_apple_provided_gems
    require 'needle'
  end

  def test_can_still_load_stdlib
    require 'net/http'
  end

  def test_can_now_load_sandbox_libs
    require 'library-used-by-sandbox-tests'
  end

  def test_can_now_load_sandbox_gems
    require 'shoulda'
  end

  def test_can_no_longer_load_site_gems
    assert_raises(LoadError) do
      require 'sinatra'
    end
  end

  def test_can_no_longer_load_site_libs
    assert_raises(LoadError) do
      require "site_ruby_sandbox_test"
    end
  end
end
