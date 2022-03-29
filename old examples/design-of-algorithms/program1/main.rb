require_relative 'graph'
require_relative 'node'
require_relative 'edge'
require_relative 'breadth_first_search'
require_relative 'depth_first_search'

file1, file2, file3 = ARGV

if file2.nil?
	puts "not enough arguments"
	exit 1
end

if !file3.nil?
	puts "too many arguments"
	exit 1
end

@graph = Graph.new

File.open(file1, 'r') do |f1|
	while line = f1.gets
		line.chomp!
		line.downcase!
		instance_variable_set("@#{line}", Node.new(line.capitalize))
		@graph.add_node(eval("@#{line}"))
	end
end

File.open(file2, 'r') do |f2|
	while line = f2.gets
		edge1, edge2, weight = line.split
		edge1.chomp!
		edge1.downcase!
		edge2.chomp!
		edge2.downcase!
		@graph.add_edge(eval("@#{edge1}"), eval("@#{edge2}"))
	end
end

first_node = @graph.nodes.first
last_node = @graph.nodes.last

bfs_path = BreadthFirstSearch.new(@graph, first_node).shortest_path_to(last_node)

puts ""
puts "Breadth First Search"
puts ""

bfs_path.each do |node|
	puts node
end

dfs_path = DepthFirstSearch.new(@graph, first_node).path_to(last_node)

puts ""
puts "Depth First Search"
puts ""

dfs_path.each do |node|
	puts node
end

