#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

framework 'Cocoa'

require 'path-setting'

if $0 == __FILE__ then
  NSLog "MacRuby version is #{MACRUBY_VERSION}."
  NSLog "Using Ruby files in #{RubyCocoaLocations::app_root}."
  RubyCocoaLocations.set_hierarchical_app_load_paths
  RubyCocoaLocations.load_ruby_files
  NSApplicationMain(0, nil)
end
