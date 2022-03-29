#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---





class Document < OSX::NSDocument





  include OSX

  attr_reader :content


  def content=(new_content)

    # puts "Changing #{content.object_id} to #{new_content.object_id}"
    # puts content
    # puts '-vs-'
    # puts new_content

    updateChangeCount(NSChangeDone)
    @content = new_content
  end



  def makeWindowControllers
    $stderr.puts "#{self.class} will now create its controller."
    main = LogWindowController.alloc.init
    addWindowController(main)
  end



  def init
    $stderr.puts "#{self.class} springs into life!"
    @content = NSMutableAttributedString.alloc.init # (1)
    super_init  # (2)
  end



  def showWindows
    $stderr.puts "#{self.class} has been asked to show its windows."
    super_showWindows
  end



  def dataOfType_error(type, error)
    content.objc_send(:RTFFromRange, NSRange.new(0, content.length),
                      :documentAttributes, nil)
  end

  def readFromData_ofType_error(data, type, error)
    string = NSMutableAttributedString.alloc
    @content = string.objc_send(:initWithRTF, data,
                                :documentAttributes, nil)
    true
  end







end





