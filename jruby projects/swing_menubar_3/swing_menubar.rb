require_relative './java_imports'
require_relative './GUI.rb'
require 'optparse'
require 'ostruct'

puts ARGV
$root = Dir.getwd
$os = System.getProperty("os.name")
$mask = Toolkit.getDefaultToolkit().getMenuShortcutKeyMask
look_and_feels = javax.swing.UIManager.getInstalledLookAndFeels

for item in look_and_feels
  puts item.getName
  if item.getName == "Mac OS X"
    javax.swing.UIManager.setLookAndFeel(item.getClassName)
  end
end

$options = OpenStruct.new
$options.message = 'default message value'
$options.title = 'default title value'

OptionParser.new do |opt|
  opt.on('-m', '--message MESSAGE', 'The body of the message to be displayed') { |o| $options.message = o }
  opt.on('-t', '--title TITLE', 'The title of the messagebox') { |o| $options.title = o }
end.parse!

GUI.new
