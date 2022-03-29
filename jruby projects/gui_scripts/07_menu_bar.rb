# 7_menu_bar.rb

require 'java_imports.rb'

class TopFrame < JFrame

  attr_accessor :main_menu_bar

  def initialize
    super
    init_components()
    pack()
    set_visible(true)
  end
  
  def init_components()
  
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(600, 400))

    @main_menu_bar = MainMenuBar.new()
    set_jmenu_bar(@main_menu_bar)

  end
  
end

class MainMenuBar < JMenuBar

  attr_accessor :file_menu, :new_menu_item, :exit_menu_item,
    :edit_menu, :cut_menu_item, :copy_menu_item 
  
  def initialize  
    super()
    init_components()
  end
  
  def init_components
    
    @file_menu = JMenu.new('File')
    
    @new_menu_item = JMenuItem.new('New')
    @new_menu_item.add_action_listener do |event|
      puts 'the New menu item clicked'
    end
    @file_menu.add(@new_menu_item)
         
    @exit_menu_item =  JMenuItem.new('Exit')
    @exit_menu_item.add_action_listener do |event|
      System.exit(0)
    end
    @file_menu.add(@exit_menu_item)

    add(@file_menu)
            
    @edit_menu = JMenu.new('Edit')
    
    @cut_menu_item = JMenuItem.new('Cut')
    @cut_menu_item.add_action_listener do |event|
      puts 'The Cut menu item clicked'
      puts 'Source: ' + event.source.to_s
      puts 'Action command: ' + event.action_command
    end
    @edit_menu.add(@cut_menu_item)
    
    @copy_menu_item = JMenuItem.new('Copy')
    @copy_menu_item.add_action_listener do |event|
      puts 'The Copy menu item clicked'
    end
    @edit_menu.add(@copy_menu_item)

    add(@edit_menu)

  end
  
end

SwingUtilities.invoke_later do
  TopFrame.new
end
