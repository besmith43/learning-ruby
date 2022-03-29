#!/usr/local/bin/ruby -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

pat = "test_*.rb"
if File.basename(Dir.pwd) != "test" then
  $: << "test"
  pat = File.join("test", pat)
end

Dir.glob(pat).each do |f|
  require f
end

require 'test/unit'
