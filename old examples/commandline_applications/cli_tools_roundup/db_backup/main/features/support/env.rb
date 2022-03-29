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
require 'yaml'

include FileUtils

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}/usr/local/mysql/bin#{File::PATH_SEPARATOR}#{ENV['PATH']}"
Before do
  @old_home = ENV['HOME']
  ENV['HOME'] = '/tmp'
  @tmp_yaml_config = File.join(ENV['HOME'],'.db_backup.rc.yaml')
  @tmp_ruby_config = File.join(ENV['HOME'],'.db_backup.rc.rb')
end

After do
  ENV['HOME'] = @old_home
  ENV['PATH'] = @original_path if @original_path
end
