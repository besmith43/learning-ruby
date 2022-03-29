# 06_adding_widgets.rb

require 'java_imports.rb'

class TopFrame < JFrame

  attr_accessor :button, :label

  def initialize
    super
    init_components()
    pack()
    set_visible(true)
  end
  
  def init_components()
  
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)   
    content_pane = get_content_pane()
    
    @button = JButton.new('Button text')
    @label = JLabel.new('Label text')
    
    content_pane.add(@button, BorderLayout::NORTH)
    content_pane.add(@label, BorderLayout::SOUTH)
    
  end
  
end

SwingUtilities.invoke_later do
  TopFrame.new
end
