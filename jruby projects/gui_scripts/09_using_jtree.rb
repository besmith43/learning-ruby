require 'pathname'
require 'java_imports.rb'
require 'file_system_tree_model.rb'

class TopFrame < JFrame

  attr_accessor :fs_tree, :scroll_pane

  def initialize
    super
    init_components()
    pack()
    set_visible(true)
  end
  
  def init_components()
  
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(300, 400))

    content_pane = get_content_pane()
        
    @fs_tree = FileSystemTree.new()
    @scroll_pane = JScrollPane.new(@fs_tree)
    content_pane.add(@scroll_pane, BorderLayout::CENTER)

  end
  
end

class FileSystemTree < JTree

  def initialize
    super()    
    init_components()
  end
  
  def init_components()
    home_dir = System.get_property('user.home')
    model = FileSystemTreeModel.new(home_dir)
    set_model(model)
  end
  
  def convertValueToText(value, selected, expanded, leaf, row, has_focus)
    return value.name
  end
  
end

SwingUtilities.invoke_later do
  UIManager.get_installed_look_and_feels().each do |info|
    if info.name == 'GTK+'
      UIManager.set_look_and_feel(info.class_name)
    end
  end
  TopFrame.new
end
