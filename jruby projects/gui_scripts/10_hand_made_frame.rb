# 10_hand_made_frame.rb

require 'java_imports.rb'
require 'file_system_tree_model.rb'

class TopFrame < JFrame

  attr_accessor :split_pane, :main_menu_bar, :toolbar, :clipboard

  def initialize
    super
    init_components()
    pack()
    set_visible(true)
  end
  
  def init_components()
  
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(600, 400))

    content_pane = get_content_pane()
    
    @main_menu_bar = MainMenuBar.new()
    set_jmenu_bar(@main_menu_bar)  
        
    @split_pane = TreeSplitPane.new()
    content_pane.add(@split_pane, BorderLayout::CENTER)
    
    @toolbar = MainToolBar.new()
    content_pane.add(@toolbar, BorderLayout::NORTH)
    
    @clipboard = Toolkit.default_toolkit.system_clipboard    
    
    copy_listener = ActionListener.impl do |event|
      selection = StringSelection.new(@split_pane.text_area.text)
      @clipboard.set_contents(selection, selection)
    end
      
    @toolbar.copy_button.add_action_listener(copy_listener)
    @main_menu_bar.copy_menu_item.add_action_listener(copy_listener)
    
    open_directory_listener = ActionListener.impl do |event|
      
      file_chooser = JFileChooser.new()
      file_chooser.file_selection_mode = JFileChooser::DIRECTORIES_ONLY
      file_chooseraccept_all_file_filter_used = false
      
      return_value = file_chooser.show_open_dialog(self)
      
      if return_value == JFileChooser::APPROVE_OPTION
        root_dir = file_chooser.selected_file.path
        model = FileSystemTreeModel.new(root_dir)
        @split_pane.tree.set_model(model)
      end
      
    end
    
    @main_menu_bar.open_menu_item.add_action_listener(open_directory_listener)
    @toolbar.open_button.add_action_listener(open_directory_listener)  
    
  end
  
end

class TreeSplitPane < JSplitPane

  attr_accessor :tree, :text_area, :scroll_pane

  def initialize
    
    super()
    init_components()    
    
    set_left_component(@scroll_pane)
    set_right_component(@text_area)
    java_send :setDividerLocation, [Java::int], 250
    
  end
  
  def init_components()
  
    @tree = FileSystemTree.new()
    @tree.selection_model.selection_mode = TreeSelectionModel::SINGLE_TREE_SELECTION

    
    @tree.add_tree_selection_listener do |event|
      node = @tree.last_selected_path_component
      if node.instance_of?(JavaFile)
        info = <<-INFO
  Path: #{node.path}
  Name: #{node.name}
  Size: #{node.length}
            INFO
      else
        info = ''
      end
      @text_area.text = info
      
    end
      
    @scroll_pane = JScrollPane.new(@tree)
    
    @text_area = JTextArea.new()
    @text_area.editable = false
    
  end

end

class MainMenuBar < JMenuBar

  attr_accessor :file_menu, :open_menu_item, :exit_menu_item,
    :edit_menu, :copy_menu_item 
  
  def initialize  
    super()
    init_components()
  end
  
  def init_components
    
    @file_menu = JMenu.new('File')
    
    @open_menu_item = JMenuItem.new('Open')
    @file_menu.add(@open_menu_item)
         
    @exit_menu_item =  JMenuItem.new('Exit')
    @exit_menu_item.add_action_listener do |event|
      System.exit(0)
    end
    @file_menu.add(@exit_menu_item)

    add(@file_menu)
            
    @edit_menu = JMenu.new('Edit')
    
    @copy_menu_item = JMenuItem.new('Copy')
    @edit_menu.add(@copy_menu_item)

    add(@edit_menu)

  end
  
end

class MainToolBar < JToolBar

  attr_accessor :open_button, :copy_button

  def initialize()
    super()
    init_components()
    set_floatable(false)    
  end
  
  def init_components()
    
    open_file_icon = ImageIcon.new('assets/document-open.png')
    @open_button = JButton.new(open_file_icon)
    add(@open_button)
    
    copy_icon = ImageIcon.new('assets/edit-copy.png')
    @copy_button = JButton.new(copy_icon)
    add(@copy_button)
        
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
