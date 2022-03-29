require_relative './java_imports.rb'
require_relative './optparse.rb'
require_relative './ostruct.rb'

$options = OpenStruct.new
$options.message = "default message value"
$options.title = "default title value"

OptionParser.new do |opt|
  opt.set_program_name('messagebox.jar')
  opt.on('-m', '--message MESSAGE', String, 'The body of the message to be displayed') { |o| $options.message = o }
  opt.on('-t', '--title TITLE', String, 'The title of the messagebox') { |o| $options.title = o }
end.parse!

class GUI
  def initialize
    @frame = JFrame.new($options.title)
    @label = JLabel.new($options.message)

    panel = JPanel.new
    panel.setBorder(BorderFactory.createEmptyBorder(30, 30, 10, 30))
    panel.setLayout(GridLayout.new(0, 1))
    panel.add(@label, "Center")

    @frame.getContentPane.add(panel)
    @frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    @frame.setSize(640,480)
    @frame.visible = true
  end
end

