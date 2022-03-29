class Node
  attr_accessor :name, :graph, :x, :y

  def initialize(name, y, x)
    @name = name
	@x = x
	@y = y
  end

  def get_x
	  @x
  end

  def get_y
	  @y
  end

  def adjacent_edges
    graph.edges.select{|e| e.from == self}
  end

  def to_s
    @name
  end
end
