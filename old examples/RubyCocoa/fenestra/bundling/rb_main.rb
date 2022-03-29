#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'
require 'path-setting'   # (1) 

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  OSX::NSLog "RubyCocoa version is #{OSX::RUBYCOCOA_VERSION}."
  RubyCocoaLocations.restrict_load_path_to_OSX_defaults   # (2) 
  RubyCocoaLocations.make_chosen_libs_and_gems_available   # (3) 
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
