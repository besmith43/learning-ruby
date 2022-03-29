#---
# Excerpted from "Build Awesome Command-Line Applications in Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/dccar2 for more book information.
#---
require 'aruba/cucumber'
require 'fileutils'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

at_exit do
  %x[yes | gem uninstall db_backup -a]
end

