def read_image(png_file)
	puts "Reading Image from File"

	image = ChunkyPNG::Image.from_file(png_file)

	rows = image.dimension.width
	cols = image.dimension.height

	maze = Array.new(cols) { Array.new(rows) }

	(0..image.dimension.width-1).each do |x|
		(0..image.dimension.height-1).each do |y|
			r = ChunkyPNG::Color.r(image[x,y])
			g = ChunkyPNG::Color.g(image[x,y])
			b = ChunkyPNG::Color.b(image[x,y])

			if r == 255 or g == 255 or b == 255
				maze[y][x] = 0
			elsif r == 0 or g == 0 or b == 0
				maze[y][x] = 1
			else
				exit 1
			end
		end
	end

	return maze, rows, cols
end

def write_image(maze, rows, cols)
	puts "Writing Maze to File"

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

	cli = HighLine.new

	filename = cli.ask("Solved Maze File Name: ") { |q| q.default = "test.png" }
	image.save filename

end

def get_nodes(maze, rows, cols)
	prog_bar = ProgressBar.create(:title => "Collecting Nodes", :total => rows*cols, format: 'Progress %c %C |%b>%i| %a %e')

	node_maze = Array.new(cols) { Array.new(rows) {0} }

	num_nodes = 0
	num_edges = 0
	connected_to_start = false
	num_possible_paths = 0
	entrance = 0
	finish = 0
	graph = Graph.new

	(0..cols-1).each do |x|
		prog_bar.increment
		if maze[0][x] == 0
			entrance = x
			num_nodes += 1
			@node1 = Node.new("node1", 0, x)
			graph.add_node(@node1)
			node_maze[0][x] = num_nodes
		end
	end

	(0..cols-1).each do |x|
		(1..rows-2).each do |y|
			prog_bar.increment
			if maze[y][x] == 0
				if maze[y][x+1] == 0 and maze[y][x-1] == 0 and maze[y+1][x] == 1 and maze[y-1][x] == 1
					# corridor
				elsif maze[y][x+1] == 1 and maze[y][x-1] == 1 and maze[y+1][x] == 0 and maze[y-1][x] == 0
					# corridor
				else
					num_nodes += 1
					instance_variable_set("@node#{num_nodes}", Node.new("node#{num_nodes}", y, x))
					graph.add_node(eval("@node#{num_nodes}"))
					node_maze[y][x] = num_nodes

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
		prog_bar.increment
		if maze[rows-1][x] == 0
			finish = x
			num_nodes += 1
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
					num_edges += 1
					break
				end
			end
		end
	end

	return graph, num_nodes
end

def solve(graph, num_nodes, maze, rows, cols)
	puts "Solving the Maze"

	shortest_path = Dijkstra.new(graph, @node1).shortest_path_to(eval("@node#{num_nodes}"))

	shortest_path
end

def graph_solution(shortest_path, num_nodes, maze, rows, cols)
	puts "Graphing the Solution to the Maze"

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

	maze
end

def select_maze
	cli = HighLine.new
	png_files = []

	png_files = Dir.glob('examples/*.png')

	cli.choose do |menu|
		menu.prompt = "Please choose which Maze you would like to solve"
		menu.choices(*png_files) do |chosen|
			puts "Maze Chosen: #{chosen}"
			return chosen
		end
	end
end

