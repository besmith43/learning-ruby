# This is the 'magical Java require line'.
require 'java'

# With the 'require' above, we can now refer to things that are part of the
# standard Java platform via their full paths.

frame = javax.swing.JFrame.new("Window") # Creating a Java JFrame
panel = javax.swing.JPanel.new()
label = javax.swing.JLabel.new("Hello")
#label.setFont(new java.awt.Font(java.awt.Font.SERIF, java.awt.Font.PLAIN, 10))

# We can transparently call Java methods on Java objects, just as if they were defined in Ruby.

#frame.add(label)  # Invoking the Java method 'add'.
panel.add(label)
frame.getContentPane.add(panel)
frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
frame.setSize(640, 480)
#frame.pack
frame.setVisible(true)
