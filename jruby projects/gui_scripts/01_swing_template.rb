#01_swing_template.rb

require './java_imports.rb'

class TopFrame < JFrame

  def initialize
    super
    init_components()
    pack()
    set_visible(true)
  end
  
  def init_components()
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(400, 300))
  end
  
end

SwingUtilities.invoke_later do
  TopFrame.new
end
