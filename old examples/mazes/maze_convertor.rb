require 'chunky_png'
require 'ruby-progressbar'
require 'pp'

input_file, output_file, *everything_else = ARGV

if input_file.nil?
	exit 1
end

if output_file.nil?
	exit 1
end


input_maze = []
row_count = 0
col_count = 0

File.open(input_file, 'r') do |f1|
	while line = f1.gets
		line.chomp!
		input_maze << line
		col_count += 1
	end
end

test_line = input_maze[0]

test_line.each_char { |c| row_count += 1}

line_count = 0
char_count = 0

maze = Array.new(col_count) { Array.new(row_count) }

input_maze.each do |line|
	line.each_char do |c|
		maze[line_count][char_count] = c
		char_count += 1
	end
	char_count = 0
	line_count += 1
end

pp maze

image = ChunkyPNG::Image.new row_count, col_count

(0..col_count-1).each do |y|
	(0..row_count-1).each do |x|
		if  maze[y][x].include? "#"
			image[x,y] = ChunkyPNG::Color(0, 0, 0)
		else
			image[x,y] = ChunkyPNG::Color(255, 255, 255)
		end
	end
end

image.save output_file
