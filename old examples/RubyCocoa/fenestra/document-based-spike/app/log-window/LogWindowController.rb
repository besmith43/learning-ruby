#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---







class LogWindowController < OSX::NSWindowController 







  include OSX
  include FenestraNotifiable
  include Delegatable


  ib_outlet :textView  # (1)
  # ...



  def init
    $stderr.puts "#{self.class} springs into life!"
    $stderr.puts "#{self.class} will load the nib named 'Log'."
    initWithWindowNibName("Log")
    self
  end




  def awakeFromNib

    $stderr.puts "#{self.class} is told the Nib is loaded."
    $stderr.puts "#{self.class} now has an outlet to #{window.class}."

    # ...

    @textView.textStorage.attributedString = document.content  # (2)
    $stderr.puts "#{self.class} stuffs " + 
                 "'#{document.content.to_s}' into text view."

    notifiable_awakeFromNib

    # ...

  end



  on_local_notification AppChosen do | notification | 
    addLine("Logging started for '#{notification[:app_name]}'...")
  end

  on_local_notification TimeToForgetApp do | notification | 
    addLine("Logging finished for '#{notification[:app_name]}'.")
  end


  on_local_notification AppFactAvailable do | notification | 
    addLine(notification[:message])
  end


  

  def setDocument(doc)
    $stderr.puts "#{self.class} has been given a pointer to #{doc.class}."
    super_setDocument(doc)
  end



  def showWindow(sender)
    $stderr.puts "#{self.class} has been asked to show its window."
    $stderr.puts "  (Is the Nib actually loaded yet? #{isWindowLoaded})"
    super_showWindow(sender)
  end



  def textDidChange(unused_notification)
    document.content = @textView.textStorage
  end



  def addLine(line)
    @textView.addLine(line)
    textDidChange(:irrelevant)
  end









end







