#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Complicated rigamarole to get sandbox contents into the path.
# You can load app files with (for example)
#    require 'preferences/PreferencesController'
# So File.expand_path('../app') is in the path.
#
# You can load test files like this:
#    require 'test/util'
# So File.expand_path('..') is in the path.
# 
# The sandbox library (File.expand_path('../../../sandbox/lib') is in the path.
#

require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")

def RubyCocoaLocations.root_for_ruby_files   # overriding version from above.
  RubyCocoaLocations.dir_containing('app')
end
RubyCocoaLocations.set_hierarchical_app_load_paths

def RubyCocoaLocations.sandbox_root
  File.join(RubyCocoaLocations.dir_containing('sandbox.rb'), 'sandbox')
end


Gem.use_paths(nil, Gem.path + [File.join(RubyCocoaLocations.sandbox_root, 'gems')])
$: << File.join(RubyCocoaLocations.sandbox_root, 'lib')
$: << RubyCocoaLocations.root_for_ruby_files   # To load files like 'test/util'
$: << '.'

require 'test/unit'
require 'Shoulda'
RubyCocoaLocations.load_ruby_files

require 'flexmock/test_unit'
require 'test/mock-talk'

# puts '=== path-setting'
# puts $:
