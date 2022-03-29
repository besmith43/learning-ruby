require_relative './optparse.rb'
require_relative './ostruct.rb'

puts ARGV

$options = OpenStruct.new
$options.message = 'default message value'
$options.title = 'default title value'

OptionParser.new do |opt|
  opt.on('-m', '--message MESSAGE', 'The body of the message to be displayed') { |o| $options.message = o }
  opt.on('-t', '--title TITLE', 'The title of the messagebox') { |o| $options.title = o }
end.parse!

puts $options.title
puts $options.message
