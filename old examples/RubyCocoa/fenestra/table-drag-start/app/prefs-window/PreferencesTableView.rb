#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---


class PreferencesTableView < OSX::NSTableView


  include OSX
  include FenestraNotifiable
  include NSTableViewPatches



  def awakeFromNib

    # ...


    # Superclass does not have an awakeFromNib
    notifiable_awakeFromNib   # (1)
    registerForDraggedTypes([NSFilenamesPboardType])   # (2)

  end



=begin
     # Solution template - a first cut

  def draggingEntered(info)
    # ...
  end

  def draggingUpdated(info)
    # ...
  end

  def performDragOperation(info)
    # ...
  end

  def draggingExited(info)
    # ...
  end


=end

     # Solution template - a better version

  def draggingEntered(info); evaluate_location(tailored(info)); end  # (3)
  def draggingUpdated(info); evaluate_location(tailored(info)); end
  def performDragOperation(info); drop(tailored(info)); end
  def draggingExited(info); forget_drag(tailored(info)); end  # (4)

  testable


  def evaluate_location(tailored_info)  # (5) 
    if tailored_info.drop_would_work?
      # ...
    else
      # ...
    end
  end


  def forget_drag(tailored_info)  # (6) 
    # ...
  end

  def drop(tailored_info)  # (7) 
    # ...
  end

  private

  def tailored(raw_info)  # (8) 
    PrefsTableDraggingInfo.alloc.initWithTable_rawInfo(self, raw_info)
  end

end


