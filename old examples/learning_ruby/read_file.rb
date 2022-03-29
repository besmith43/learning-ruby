#!/usr/bin/env ruby

File.open('test.txt', 'r') do |f1|
	while line = f1.gets
		puts line
	end
end

