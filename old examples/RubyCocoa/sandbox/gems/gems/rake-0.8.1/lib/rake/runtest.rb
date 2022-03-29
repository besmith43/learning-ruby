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
require 'test/unit/assertions'

module Rake
  include Test::Unit::Assertions

  def run_tests(pattern='test/test*.rb', log_enabled=false)
    Dir["#{pattern}"].each { |fn|
      puts fn if log_enabled
      begin
        load fn
      rescue Exception => ex
        puts "Error in #{fn}: #{ex.message}"
        puts ex.backtrace
        assert false
      end
    }
  end

  extend self
end
