#03_with_swing_utilities.rb

require 'java_imports.rb'

class TopFrame < JFrame

  def initialize
    super
    init_components()
    
    pack()
    set_visible(true)
    
    puts '----------------------------------------'
    puts 'In JFrame constructor:'
    puts "Thread name: #{JavaThread.current_thread.name}"
    puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
    JavaThread.current_thread.thread_group.list
    
  end
  
  def init_components()
    
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(400, 300))
      
    button = JButton.new('Button with action listener')
    button.add_action_listener do |event|
      puts '----------------------------------------'
      puts 'In action listener:'
      puts "Thread name: #{JavaThread.current_thread.name}"
      puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
      JavaThread.current_thread.thread_group.list
    end
    
    get_content_pane.add(button, BorderLayout::EAST)
    
  end
  
end

puts '----------------------------------------'
puts 'Before SwingUtilties.invokeLater():'
puts "Thread name: #{JavaThread.current_thread.name}"
puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
JavaThread.current_thread.thread_group.list

SwingUtilities.invoke_later do
  TopFrame.new
end

puts '----------------------------------------'
puts 'After SwingUtilities.invokeLater():'
puts "Thread name: #{JavaThread.current_thread.name}"
puts "Is event dispatch thread: #{SwingUtilities.event_dispatch_thread?}"
JavaThread.current_thread.thread_group.list
