class Node
  attr_accessor :value, :left, :right, :name

	def initialize(options={})
		@value = options[:value]
		@name = options[:name]
	end

	def children
		[@left, @right].compact
	end

	def children?
		@left && @right
	end

	def no_children?
		!children?
	end
end

root = Node.new({:value => 1, :name => 'root'})
child_1 = Node.new({:value => 2, :name => 'child_1'})
child_2 = Node.new({:value => 3, :name => 'child_2'})
grand_child_1 = Node.new({:value => 4, :name => 'grand_child_1'})
grand_grand_child_1 = Node.new({:value => 5, :name => 'grand_grand_child_1'})
grand_child_1.left = grand_grand_child_1
child_1.left = grand_child_1
root.left = child_1
root.right = child_2

def bfs(node)
	queue = []
	queue.push(node)

	while(queue.size != 0)
		n = queue.shift
		puts n.value
		n.children.each do |child|
			queue.push(child)
		end
	end
end

bfs(root)

puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~'

def dfs(node)
	puts node.value
	node.children.each do |child|
		dfs(child)
	end
end

dfs(root)
