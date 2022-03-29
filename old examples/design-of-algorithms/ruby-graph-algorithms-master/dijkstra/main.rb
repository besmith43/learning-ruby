require "pp"
require_relative "graph"
require_relative "node"
require_relative "edge"
require_relative "dijkstra"

file1, file2, start_node, end_node = ARGV

starting_node = start_node.dup
ending_node = end_node.dup

starting_node.chomp!
starting_node.downcase!
ending_node.chomp!
ending_node.downcase!

graph = Graph.new

File.open(file1, 'r') do |f1|
	while line = f1.gets
		puts line
		line.chomp!
		line.downcase!
		instance_variable_set("@#{line}", Node.new(line.capitalize))
		graph.add_node(eval("@#{line}"))
	end
end

File.open(file2, 'r') do |f2|
	while line = f2.gets
		edge1, edge2, weight = line.split
		edge1.chomp!
		edge1.downcase!
		edge2.chomp!
		edge2.downcase!
		graph.add_edge(eval("@#{edge1}"), eval("@#{edge2}"), weight.to_i)
	end
end

shortest_path = Dijkstra.new(graph, eval("@#{starting_node}")).shortest_path_to(eval("@#{ending_node}"))
pp shortest_path.map(&:to_s)
# => ["Node #0", "Node #4", "Node #5", "Node #2", "Node #3"]
