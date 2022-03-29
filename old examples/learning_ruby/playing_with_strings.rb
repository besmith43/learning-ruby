require 'pp'

test1 = "This is a test"
test2 = "This is not a test"
test3 = "I love solving mazes"

master = []

master << test1
master << test2
master << test3

final_array = []

master.each do |line|
	line.each_char do |c|
		final_array << c
	end
end

puts final_array
