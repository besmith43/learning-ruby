require_relative './java_imports.rb'
#require 'jruby'
#require 'java'

class GUI
  def initialize
    @clicks = 0
    @label = JLabel.new "Number of clicks: 0"
    @frame = JFrame.new "JRuby Test"

    # this isn't currently working from within the jar file
    # picture = JLabel.new ImageIcon.new "./img/test.png"
    # url = JRuby.runtime.jruby_class_loader.get_resource("./img/test.png")
    # how to build this string?
    #url = URL.new "jar:file:/Users/besmith/Library/Mobile Documents/com~apple~CloudDocs/Files/Development/learning-ruby/jruby projects/swing_base/hello_gui.jar!/img/test.png"
    url = URL.new "jar:file:" + Dir.getwd + "/hello_gui.jar!/img/test.png"
    image = ImageIcon.new(url)
    picture = JLabel.new image

    puts url.toString

    button = JButton.new "Click Me"
    button.addActionListener do |event|
      @clicks += 1
      @label.text = "Number of clicks: #{@clicks}"
    end

    panel = JPanel.new
    panel.setBorder BorderFactory.createEmptyBorder 30, 30, 10, 30
    panel.setLayout GridLayout.new 0, 1
    panel.add picture, "Center"
    panel.add button, "Center"
    panel.add @label, "Center"

    @frame.getContentPane.add panel
    @frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    @frame.setSize 640, 480
    #@frame.pack
    @frame.visible = true
  end
end

GUI.new
