#!/usr/bin/env jruby

require_relative '../lib/java_imports.rb'
#require 'jruby'
#require 'java'

class GUI
  def initialize

    @clicks = 0
    @label = JLabel.new "Number of clicks: 0"
    @frame = JFrame.new "JRuby Test"

    # this isn't currently working from within the jar file
    # url = "../lib/img/test.png"
    url = URL.new "jar:file:/Users/besmith/Library/Mobile%20Documents/com~apple~CloudDocs/Files/Development/learning-ruby/jruby%20projects/warble_test/warble_test.jar!/warble_test/lib/img/test.png"
    #url = JRuby.runtime.jruby_class_loader.get_resource("warble_test/lib/img/test.png")
    image = ImageIcon.new(url)
    picture = JLabel.new image
    # picture = JLabel.new(ImageIcon.new(getClass.getResource("../lib/img/test.png")))

    #puts url.toString

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
