require_relative './java_imports'
require_relative './optparse'
require_relative './ostruct'

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

class GUI
  def initialize
    if $os == 'Mac OS X'
      System.setProperty("apple.laf.useScreenMenuBar", "true")
    end

    puts "creating JFrame with title of #{$options.title}"
    @frame = JFrame.new($options.title)
    puts "creating JLabel with message of #{$options.message}"
    @label = JLabel.new($options.message)

    @menubar = JMenuBar.new
    @menu = JMenu.new('File')

=begin
    @menu = Class.new(JMenu) {
      accelerator = javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::ALT_DOWN_MASK)
    
    def getAccelerator
      return accelerator
    end

    def setAccelerator(keyStroke)
      oldAccelerator = accelerator
      accelerator = keyStroke
      repaint
      revalidate
      firePropertyChange('accelerator'.to_java, oldAccelerator, accelerator)
    end
    }.new('File')

    # this works with the sole exception being that hte firePropertyChange function isn't working.  I believe it's an issue of the
    # fact that the proper overload is protected and thus java doesn't want to allow jruby to use it.
    # with that said, jruby is fighting me on importing a .class file where I override the same features in java directly.
=end
    
    # setMnemonic works, but on mac os the modifiers aren't alt + f like I thought it should be, but ctrl + alt + f.  it clashes on my 
    # system with magnets
    @menu.setMnemonic(java.awt.event.KeyEvent::VK_F)
    #@menu.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_H, java.awt.event.KeyEvent::ALT_DOWN_MASK))

    mi1 = JMenuItem.new('Menu Item 1')
    mi1.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_1, $mask))

    mi1.addActionListener do |_event|
      @label.text = 'You selected Menu Item 1'
    end

    mi2 = JMenuItem.new('Menu Item 2')
    mi2.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_2, $mask))

    mi2.addActionListener do |_event|
      @label.text = 'You selected Menu Item 2'
    end

    mi3 = JMenuItem.new('Menu Item 3')
    mi3.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_3, $mask))

    mi3.addActionListener do |_event|
      @label.text = 'You selected Menu Item 3'
    end

    mi4 = JMenuItem.new('Menu Item 4')
    mi4.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_4, $mask))

    mi4.addActionListener do |_event|
      label2 = JLabel.new('You selected Menu Item 4')
      @panel.add(label2, 'Center')
      @panel.revalidate
      @panel.repaint
    end

    @menu.add(mi1)
    @menu.add(mi2)
    @menu.add(mi3)
    @menu.addSeparator
    @menu.add(mi4)

    @help_menu = JMenu.new('Help')
    @help_menu.setMnemonic(java.awt.event.KeyEvent::VK_H)

    version_help_menu_item = JMenuItem.new('Version')
    version_help_menu_item.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent::VK_V, java.awt.event.KeyEvent::ALT_DOWN_MASK))

    version_help_menu_item.addActionListener do |_event|
      d = JDialog.new(@frame, 'Version')
      # l = JLabel.new(File.read("jar:file:#{$root}/swing_menubar.jar!/version.txt").strip)
      l = JLabel.new(File.read('./version.txt').strip)
      b = JButton.new('Ok')

      b.addActionListener do |_event|
        d.dispose
      end

      d.setLayout(GridLayout.new(0, 1))
      d.add(l, 'Center')
      d.add(b, 'Bottom')
      d.setSize(300, 100)
      d.setVisible(true)
    end

    @help_menu.add(version_help_menu_item)

    @menubar.add(@menu)
    @menubar.add(@help_menu)

    dialog_button = JButton.new('Open Dialog')

    dialog_button.addActionListener do |_event|
      d = JDialog.new(@frame, 'testing dialog boxes')
      l = JLabel.new("This probably isn't going to work")
      b = JButton.new('Ok')

      b.addActionListener do |_event|
        d.dispose
      end

      d.setLayout(GridLayout.new(0, 1))
      d.add(l, 'Center')
      d.add(b, 'Bottom')
      d.setSize(300, 100)
      d.setVisible(true)
    end

    close_button = JButton.new('Close')

    close_button.addActionListener do |_event|
      @frame.dispose
    end

    @frame.setJMenuBar(@menubar)

    @panel = JPanel.new
    @panel.setBorder(BorderFactory.createEmptyBorder(30, 30, 10, 30))
    @panel.setLayout(GridLayout.new(0, 1))
    @panel.add(@label, 'Center')
    @panel.add(close_button, 'Right')
    @panel.add(dialog_button, 'Right')

    @frame.getContentPane.add(@panel)
    @frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    @frame.setSize(640, 480)
    @frame.visible = true
  end
end

GUI.new
