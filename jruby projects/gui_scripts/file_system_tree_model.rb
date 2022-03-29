require 'java_imports.rb'

class FileSystemTreeModel 
  include TreeModel

  attr_accessor :root
  
  def initialize(path)
    @root = JavaFile.new(path)
  end
  
  def get_root()
    return @root
  end
  
  def is_leaf(node)
    return node.file?
  end
  
  def get_child_count(parent)
    children = parent.list
    if children == nil
      return 0
    else
      return children.length
    end
  end
  
  def get_child(parent, index)
    children = parent.list
    if children == nil or children.length <= index
      return nil
    else
      return parent.list_files[index]
    end
  end
  
  def get_index_of_child(parent, child)
    entries = parent.list
    hash = Hash[entries.map.with_index.to_a]
    puts hash[child]
    return hash[child]
  end
  
  def value_for_path_changed(path, new_value)
  end
  
  def add_tree_model_listener(listener)
  end
  
  def remove_tree_model_listener(listener)
  end

end
