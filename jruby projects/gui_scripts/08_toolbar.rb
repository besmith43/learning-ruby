# 08_toolbar.rb

require 'java_imports.rb'

class TopFrame < JFrame

  attr_accessor :main_toolbar, :text_area

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
    puts get_layout().class
    
    @text_area = JTextArea.new()
    content_pane.add(@text_area, BorderLayout::CENTER)
    
    @main_toolbar = MainToolBar.new(@text_area)
    content_pane.add(@main_toolbar, BorderLayout::NORTH)    

  end
  
end

class MainToolBar < JToolBar

  attr_accessor :copy_button, :paste_button, :text_container, :clipboard

  def initialize(text_container)
    super()
    init_components()
    set_floatable(false)
    @text_container = text_container
    @clipboard = Toolkit.default_toolkit.system_clipboard
  end
  
  def init_components()
    
    copy_icon = ImageIcon.new('assets/edit-copy.png')
    @copy_button = JButton.new(copy_icon)
    @copy_button.add_action_listener do |event|
      selection = StringSelection.new(@text_container.selected_text)
      @clipboard.set_contents(selection, selection)
    end
    add(@copy_button)
    
    paste_icon = ImageIcon.new('assets/edit-paste.png')
    @paste_button = JButton.new(paste_icon)
    @paste_button.add_action_listener do |event|
      transferable = @clipboard.get_contents(nil)
      if transferable.is_data_flavor_supported(DataFlavor::stringFlavor)
        text = transferable.get_transfer_data(DataFlavor::stringFlavor)
        position = @text_container.caret_position
        @text_container.insert(text, position)
      end
    end
    add(@paste_button)
    
  end

end

SwingUtilities.invoke_later do
  TopFrame.new
end
