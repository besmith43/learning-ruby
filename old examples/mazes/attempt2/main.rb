require 'chunky_png'
require 'pp'
require_relative 'functions'
require_relative 'edge'
require_relative 'graph'

maze, rows, cols = read_image('examples/tiny.png')

graph, node_maze, num_nodes = populate_graph(maze, rows, cols)

solution =  graph.dijkstra(1, num_nodes)

pp graph
