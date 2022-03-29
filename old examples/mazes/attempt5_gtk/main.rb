require 'chunky_png'
require 'pp'
require 'ruby-progressbar'
require 'highline'
require 'gtk3'
require_relative 'functions'
require_relative 'graph'
require_relative 'node'
require_relative 'edge'
require_relative 'dijkstra'

=begin
maze_filename = select_maze

maze, rows, cols = read_image(maze_filename)

graph, num_nodes = get_nodes(maze, rows, cols)

shortest_path = solve(graph, num_nodes, maze, rows, cols)

finished_maze = graph_solution(shortest_path, num_nodes, maze, rows, cols)

write_image(finished_maze, rows, cols)
=end

app = Gtk::Application.new("org.gtk.example", :flags_none)

app.signal_connect "activate" do |application|
	window = Gtk::ApplicationWindow.new(application)
	window.set_title("Window")
	window.set_default_size(500, 500)
	window.show_all
end

puts app.run
