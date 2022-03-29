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
    # Superclass does not have an awakeFromNib
    notifiable_awakeFromNib
    registerForDraggedTypes([NSFilenamesPboardType])
  end

  def draggingEntered(info); evaluate_location(tailored(info)); end
  def draggingUpdated(info); evaluate_location(tailored(info)); end
  def performDragOperation(info); drop(tailored(info)); end
  def draggingExited(info); forget_drag(tailored(info)); end

  testable


  def evaluate_location(tailored_info)
    if tailored_info.drop_would_work?
      select_row(tailored_info.row)   # (1)
      NSDragOperationCopy
    else
      deselectAll(self)
      NSDragOperationNone
    end
  end



  def drop(tailored_info)
    post(HasRubySource, :source => tailored_info.pathname,
                        :row => tailored_info.row)
    true
  end



  def forget_drag(ignored_info)
    deselectAll(self)
  end

  private

  def tailored(raw_info)
    PrefsTableDraggingInfo.alloc.initWithTable_rawInfo(self, raw_info)
  end

end
