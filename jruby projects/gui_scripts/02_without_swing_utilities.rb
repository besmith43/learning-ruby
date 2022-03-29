#02_without_swing_utilities.rb

require 'java_imports.rb'

puts '----------------------------------------'
puts 'Before JFrame.new():'
puts "Thread name: #{JavaThread.current_thread.name}"
puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
JavaThread.current_thread.thread_group.list

frame = JFrame.new()

frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
frame.set_preferred_size(Dimension.new(400, 300))

button = JButton.new('Button with action listener')
button.add_action_listener do |event|
  puts '----------------------------------------'
  puts 'In action listener:'
  puts "Thread name: #{JavaThread.current_thread.name}"
  puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
  JavaThread.current_thread.thread_group.list
end

frame.get_content_pane.add(button, BorderLayout::WEST)
frame.pack()

puts '----------------------------------------'
puts 'Before JFrame.setVisible():'
puts "Thread name: #{JavaThread.current_thread.name}"
puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
JavaThread.current_thread.thread_group.list

frame.set_visible(true)
