#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'
require 'path-setting'

if $0 == __FILE__ then
  OSX::NSLog "RubyCocoa version is #{OSX::RUBYCOCOA_VERSION}."
  OSX::NSLog "Using Ruby files in #{RubyCocoaLocations::app_root}."
  RubyCocoaLocations.set_hierarchical_app_load_paths
  RubyCocoaLocations.load_ruby_files
  OSX.NSApplicationMain(0, nil)
end
