require_relative "union_find"

class Kruskal
  def compute_mst(graph)
    mst = []
    edges = graph.edges.sort!

    union_find = UnionFind.new(graph.nodes)
    while edges.any? && mst.size <= graph.nodes.size
      edge = edges.shift
      if !union_find.connected?(edge.from, edge.to)
        union_find.union(edge.from, edge.to)
        mst << edge
      end
    end

    mst
  end
end
