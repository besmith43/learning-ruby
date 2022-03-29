require 'chunky_png'
require 'pp'
require_relative 'graph'
require_relative 'node'
require_relative 'edge'
require_relative 'dijkstra'
require_relative 'breadth_first_search'

# methods for main function

def read_image(png_file)
	image = ChunkyPNG::Image.from_file(png_file)

	rows = image.dimension.width
	cols = image.dimension.height

	maze = Array.new(cols) { Array.new(rows) }

	(0..image.dimension.width-1).each do |x|
		(0..image.dimension.height-1).each do |y|
			r = ChunkyPNG::Color.r(image[x,y])
			g = ChunkyPNG::Color.g(image[x,y])
			b = ChunkyPNG::Color.b(image[x,y])

			if r == 255 || g == 255 || b == 255
				#puts "Pixel at (#{x},#{y}) is white"
				maze[y][x] = 0
			elsif r == 0 || g == 0 || b == 0
				#puts "Pixel at (#{x},#{y}) is black"
				maze[y][x] = 1
			else
				puts "Pixel at (#{x},#{y}) is not black or white"
			end
		end
	end

	return maze, rows, cols
end

def write_image(maze, rows, cols)
	image = ChunkyPNG::Image.new rows, cols

	(0..cols-1).each do |x|
		(0..rows-1).each do |y|
			if maze[y][x] == 0
				image[x,y] = ChunkyPNG::Color(255, 255, 255)
			elsif maze[y][x] == 1
				image[x,y] = ChunkyPNG::Color(0, 0, 0)
			elsif maze[y][x] == 2
				image[x,y] = ChunkyPNG::Color(255, 0, 0)
			end
		end
	end

	image.save 'test.png'

end

def dumb_solution(maze, rows, cols)

	entrance = 0
	curr_loc_x = 0
	curr_loc_y = 0
	finish = 0

	# Maze Entrance and Exit
	(0..cols-1).each do |x|
		if maze[0][x] == 0
			entrance = x
			curr_loc_x = x
			curr_loc_y = 0
		end

		if maze[rows-1][x] == 0
			finish = x
		end
	end

	# solve it
	
	maze[0][entrance] = 2

	until curr_loc_y == rows-1 && curr_loc_x == finish
		if maze[curr_loc_y+1][curr_loc_x] == 0
			curr_loc_y += 1
			maze[curr_loc_y][curr_loc_x] = 2
		elsif maze[curr_loc_y][curr_loc_x+1] == 0
			curr_loc_x += 1
			maze[curr_loc_y][curr_loc_x] = 2
		elsif maze[curr_loc_y-1][curr_loc_x] == 0
			curr_loc_y -= 1
			maze[curr_loc_y][curr_loc_x] = 2
		elsif maze[curr_loc_y][curr_loc_x-1] == 0
			curr_loc_x -= 1
			maze[curr_loc_y][curr_loc_x] = 2
		end
	end

	maze
end

def get_nodes(maze, rows, cols)

	node_maze = Array.new(cols) { Array.new(rows) {0} }

	num_nodes = 0
	num_edges = 0
	connected_to_start = false
	num_possible_paths = 0
	entrance = 0
	finish = 0
	graph = Graph.new

	#pp node_maze

	(0..cols-1).each do |x|
		if maze[0][x] == 0
			entrance = x
			num_nodes += 1
			#puts "maze[0][#{x}] is the starting node"
			@node1 = Node.new("node1", 0, x)
			graph.add_node(@node1)
			node_maze[0][x] = num_nodes
		end
	end

	(1..cols-1).each do |x|
		(1..rows-2).each do |y|
			if maze[y][x] == 0
				if maze[y][x+1] == 0 && maze[y][x-1] == 0 && maze[y+1][x] == 1 && maze[y-1][x] == 1
					#puts "maze[#{y}][#{x}] is a horizontal corridor"
				elsif maze[y][x+1] == 1 && maze[y][x-1] == 1 && maze[y+1][x] == 0 && maze[y-1][x] == 0
					#puts "maze[#{y}][#{x}] is a vertical corridor"
				else
					#puts "maze[#{y}][#{x}] is a node#{num_nodes+1}"
					num_nodes += 1
					instance_variable_set("@node#{num_nodes}", Node.new("node#{num_nodes}", y, x))
					graph.add_node(eval("@node#{num_nodes}"))
					node_maze[y][x] = num_nodes

					# searches and creates edge connections

					search_x = x-1
					search_y = y-1
					distance = 1
					found_node = 0
					connected_to_start = false

					until maze[y][search_x] == 1
						if node_maze[y][search_x] == 0
							search_x -= 1
							distance += 1
						else
							found_node = node_maze[y][search_x]
							graph.add_edge(eval("@node#{num_nodes}"), eval("@node#{found_node}"), distance)
							graph.add_edge(eval("@node#{found_node}"), eval("@node#{num_nodes}"), distance)
							#puts "Edges Connecting @node#{num_nodes} and @node#{found_node} with a distance of #{distance}"
							distance = 1
							num_edges += 1
							break
						end
					end

					until maze[search_y][x] == 1 or connected_to_start == true
						if node_maze[search_y][x] == 0
							search_y -= 1
							distance += 1
						else
							found_node = node_maze[search_y][x]
							graph.add_edge(eval("@node#{num_nodes}"), eval("@node#{found_node}"), distance)
							graph.add_edge(eval("@node#{found_node}"), eval("@node#{num_nodes}"), distance)
							#puts "Edges Connecting @node#{num_nodes} and @node#{found_node} with a distance of #{distance}"
							if search_y == 0
								connected_to_start = true
							end
							distance = 1
							num_edges += 1
							break
						end
					end
				end
			end
		end
	end

	(0..cols-1).each do |x|
		if maze[rows-1][x] == 0
			finish = x
			num_nodes += 1
			#puts "maze[#{rows-1}][#{x}] is the exit node"
			instance_variable_set("@node#{num_nodes}", Node.new("node#{num_nodes}", rows-1, finish))
			graph.add_node(eval("@node#{num_nodes}"))
			node_maze[rows-1][x] = num_nodes

			search_y = rows-2
			distance = 1
			found_node = 0

			until maze[search_y][x] == 1
				if node_maze[search_y][x] == 0
					search_y -= 1
					distance += 1
				else
					found_node = node_maze[search_y][x]
					graph.add_edge(eval("@node#{num_nodes}"), eval("@node#{found_node}"), distance)
					graph.add_edge(eval("@node#{found_node}"), eval("@node#{num_nodes}"), distance)
					#puts "exit node#{num_nodes} connected to @node#{found_node} with a distance of #{distance}"
					num_edges += 1
					break
				end

				search_y -= 1
				distance += 1
			end
		end
	end

	#puts "Number of Nodes: #{num_nodes}"

	#pp maze
	#pp graph
	#pp node_maze
	
	#puts "Number of Edges: #{num_edges}"
	
	return graph, num_nodes
end

def solve(graph, num_nodes, maze, rows, cols)
	shortest_path = Dijkstra.new(graph, @node1).shortest_path_to(eval("@node#{num_nodes}"))
	#pp shortest_path.map(&:to_s)

	shortest_path
end

def graph_solution(shortest_path, num_nodes, maze, rows, cols)

	x = -1
	y = -1

	shortest_path.each do |node|
		temp_x = node.get_x
		temp_y = node.get_y

		maze[temp_y][temp_x] = 2

		if x > -1 and y > -1
			if x == temp_x and y > temp_y
				(temp_y..y).each do |new_y|
					maze[new_y][x] = 2
				end
			elsif x == temp_x and y < temp_y
				(y..temp_y).each do |new_y|
					maze[new_y][x] = 2
				end
			elsif x > temp_x and y == temp_y
				(temp_x..x).each do |new_x|
					maze[y][new_x] = 2
				end
			elsif x < temp_x and y == temp_y
				(x..temp_x).each do |new_x|
					maze[y][new_x] = 2
				end
			end
		end

		x = temp_x
		y = temp_y
	end

	#pp maze
	
	write_image(maze, rows, cols)
end

# main

maze, rows, cols = read_image('examples/combo400.png')

#puts maze[0][3]

puts ""

graph, num_nodes = get_nodes(maze, rows, cols)

puts ""

#pp graph

#graph.edges.each do |edge|
#	puts edge.to_s
#end

#puts num_nodes

shortest_path = solve(graph, num_nodes, maze, rows, cols)

graph_solution(shortest_path, num_nodes, maze, rows, cols)

#pp maze

#new_maze = dumb_solution(maze, rows, cols)

#write_image(new_maze, rows, cols)



