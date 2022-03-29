$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

begin
  require 'ruby_newt'
rescue
end

# Ruby Bindings for the Newt Library
module Newt
  # Gem version
  VERSION = '0.9.3'
end