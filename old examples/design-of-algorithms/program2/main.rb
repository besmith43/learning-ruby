require "pp"
require_relative "graph"
require_relative "node"
require_relative "edge"
require_relative "dijkstra"
require_relative "kruskal"
require_relative "prim"

def solve(graph, start, finish)
	shortest_path = Dijkstra.new(graph,start).shortest_path_to(finish)
	pp shortest_path.map(&:to_s)
end

file1, file2, start_node, end_node = ARGV

starting_node = start_node.dup
ending_node = end_node.dup

starting_node.chomp!
starting_node.downcase!
ending_node.chomp!
ending_node.downcase!

prim_graph = Graph.new
kruskal_graph = Graph.new
dijkstra_graph = Graph.new

File.open(file1, 'r') do |f1|
	while line = f1.gets
		line.chomp!
		line.downcase!
		instance_variable_set("@#{line}", Node.new(line.capitalize))
		prim_graph.add_node(eval("@#{line}"))
		kruskal_graph.add_node(eval("@#{line}"))
		dijkstra_graph.add_node(eval("@#{line}"))
	end
end

File.open(file2, 'r') do |f2|
	while line = f2.gets
		edge1, edge2, weight = line.split
		edge1.chomp!
		edge1.downcase!
		edge2.chomp!
		edge2.downcase!
		prim_graph.add_edge(eval("@#{edge1}"), eval("@#{edge2}"), weight.to_i)
		kruskal_graph.add_edge(eval("@#{edge1}"), eval("@#{edge2}"), weight.to_i)
		dijkstra_graph.add_edge(eval("@#{edge1}"), eval("@#{edge2}"), weight.to_i)
	end
end

puts ""
puts "Prim's Algorithm"
puts ""

primList = Prim.new(prim_graph).compute_prim
pp primList.map(&:to_s)

puts ""
puts "Kruskal's Algorithm"
puts ""

pp Kruskal.new.compute_mst(kruskal_graph).map(&:to_s)

puts ""
puts "Dijkstra's Algorithm"
puts ""

#shortest_path = Dijkstra.new(dijkstra_graph, eval("@#{starting_node}")).shortest_path_to(eval("@#{ending_node}"))
#pp shortest_path.map(&:to_s)

solve(dijkstra_graph, eval("@#{starting_node}"), eval("@#{ending_node}"))
