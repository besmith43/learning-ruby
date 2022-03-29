#!/usr/bin/env ruby

puts "this is a test of the looping capabilities of ruby and how to use it"

i = 0 

loop do
	i = i + 1

	puts "#{i}"

	# will output 10 then go through the if statement to break out of the loop do
	if i == 10
		break
	end
end

puts "Test that the loop do statement doesn't kill the script"

(10..0).each do |x|
	puts x
end
