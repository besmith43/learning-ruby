#!/usr/bin/env jruby

require 'optparse'
require 'ostruct'

$options = OpenStruct.new
$options.message = 'default message text'
$options.title = 'default title text'

OptionParser.new do |opt|
  opt.on('-m', '--message MESSAGE', 'The message you want to be displayed') { |o| $options.message = o }
  opt.on('-t', '--title TITLE', 'The message that you want to be displayed next') { |o| $options.title = o }
end.parse!

puts $options.title
puts $options.message
gets
