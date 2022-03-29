#require 'java'
include Java

java_import javax.swing.JFrame
java_import javax.swing.JPanel
java_import javax.swing.JLabel
java_import javax.swing.SwingUtilities
java_import java.awt.Dimension
java_import javax.swing.JSplitPane
java_import javax.swing.JTextArea
java_import java.awt.BorderLayout
java_import java.awt.GridLayout
java_import javax.swing.BorderFactory
java_import javax.swing.JMenuBar
java_import javax.swing.JMenu
java_import javax.swing.JMenuItem
java_import java.lang.System
java_import javax.swing.JToolBar
java_import javax.swing.JButton
java_import javax.swing.ImageIcon
java_import java.awt.Toolkit
java_import java.awt.datatransfer.StringSelection
java_import java.awt.datatransfer.Transferable
java_import java.awt.datatransfer.DataFlavor
java_import javax.swing.JScrollPane
java_import javax.swing.JTree
java_import javax.swing.tree.DefaultTreeModel
java_import javax.swing.tree.DefaultMutableTreeNode
java_import javax.swing.tree.TreeModel
java_import javax.swing.event.TreeWillExpandListener
java_import javax.swing.tree.TreeSelectionModel
java_import javax.swing.JFileChooser
java_import javax.swing.JProgressBar
java_import java.awt.event.ActionListener
java_import javax.swing.UIManager
java_import javax.swing.WindowConstants
java_import java.net.URL
JavaFile = java.io.File
JavaThread = java.lang.Thread

class GUI
  def initialize
    @clicks = 0
    @label = JLabel.new "Number of clicks: 0"
    @frame = JFrame.new "JRuby Test"

    button = JButton.new "Click Me"
    button.addActionListener do |event|
      @clicks += 1
      @label.text = "Number of clicks: #{@clicks}"
    end

    panel = JPanel.new
    panel.setBorder BorderFactory.createEmptyBorder 30, 30, 10, 30
    panel.setLayout GridLayout.new 0, 1
    panel.add button, "Center"
    panel.add @label, "Center"

    @frame.getContentPane.add panel
    @frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    @frame.setSize 640, 480
    @frame.visible = true
  end
end

GUI.new
