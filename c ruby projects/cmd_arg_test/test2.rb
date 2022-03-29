require 'optparse'
require 'ostruct'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-f', '--first_name FIRSTNAME', 'The first name') { |o| options.first_name = o }
  opt.on('-l', '--last_name LASTNAME', 'The last name') { |o| options.last_name = o }
end.parse!

puts options.first_name + ' ' + options.last_name
