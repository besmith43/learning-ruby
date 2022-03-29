# 05_set_lool_and_feel.rb

java_import javax.swing.JFrame
java_import javax.swing.SwingUtilities
java_import java.awt.Dimension
java_import java.awt.BorderLayout
java_import javax.swing.JButton
java_import javax.swing .JLabel
java_import javax.swing.UIManager

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
    button = JButton.new('Swing JButton look and feel')
    get_content_pane.add(button, BorderLayout::NORTH)
    label = JLabel.new(BorderLayout::NORTH)
    label.text = 'JLabel look and feel'
    get_content_pane.add(label)
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
