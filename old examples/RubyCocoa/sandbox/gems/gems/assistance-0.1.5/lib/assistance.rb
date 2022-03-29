#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
dir = File.join(File.dirname(__FILE__), "assistance")
%w[
  core_ext
  time_calculations
  connection_pool
  inflector
  blank
  extract_options
  validation
].each {|f| require(File.join(dir, f))}
