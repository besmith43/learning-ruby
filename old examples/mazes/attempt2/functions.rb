

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
				maze[y][x] = 0
			elsif r == 0 || g == 0 || b == 0
				maze[y][x] = 1
			else
				exit 1
			end
		end
	end

	return maze, rows, cols
end

def populate_graph(maze, rows, cols)
	node_maze = Array.new(cols) { Array.new(rows) {0} }

	#pp node_maze

	num_nodes = 0
	entrance = 0
	finish = 0
	connected_to_start = false
	graph = Graph.new

	(0..cols-1).each do |x|
		if maze[0][x] == 0
			entrance = x
			num_nodes += 1
			graph.push num_nodes
			node_maze[0][x] = num_nodes
			#puts "Entrance to Maze at Maze[0][#{x}]"
		end
	end

	(1..cols-1).each do |x|
		(1..rows-2).each do |y|
			if maze[y][x] == 0
				if maze[y][x+1] == 0 and maze[y][x-1] == 0 and maze[y+1][x] == 1 and maze[y-1][x] ==1
				elsif maze[y][x+1] == 1 and maze[y][x-1] == 1 and maze[y+1][x] == 0 and maze[y-1][x] == 0
				else
					num_nodes += 1
					graph.push num_nodes
					node_maze[y][x] = num_nodes
					#puts "Node at Maze[#{y}][#{x}]"

					search_x = x-1
					search_y = y-1
					distance = 1
					connected_to_start = false
					
					until maze[y][search_x] == 1
						if node_maze[y][search_x] == 0
							search_x -= 1
							distance += 1
						else
							found_node = node_maze[y][search_x]
							graph.connect_mutually(num_nodes, found_node, distance)
							#puts "Edge connecting node#{num_nodes} to node#{found_node} with a distance of #{distance}"
							break
						end
					end

					distance = 1

					until maze[search_y][x] == 1 or connected_to_start == true
						if node_maze[search_y][x] == 0
							search_y -= 1
							distance += 1
						else
							found_node = node_maze[search_y][x]
							graph.connect_mutually(num_nodes, found_node, distance)
							if search_y == 0
								connected_to_start = true
							end
							#puts "Edge connecting node#{num_nodes} to node#{found_node} with a distance of #{distance}"
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
			graph.push num_nodes
			node_maze[rows-1][x] = num_nodes
			#puts "Exit node at Maze[#{rows-1}][#{x}]"

			search_y = rows-2
			distance = 1

			until maze[search_y][x] == 1
				if node_maze[search_y][x] == 0
					search_y -= 1
					distance += 1
				else
					found_node = node_maze[search_y][x]
					graph.connect_mutually(num_nodes, found_node, distance)
					#puts "Edge connecting node#{num_nodes} to node#{found_node} with a distance of #{distance}"
					break
				end
			end
		end
	end

	#pp node_maze

	return graph, node_maze, num_nodes
end
