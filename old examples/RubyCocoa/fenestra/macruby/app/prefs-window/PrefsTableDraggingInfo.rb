#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class PrefsTableDraggingInfo < CellOrientedDraggingInfo

  def drop_would_work?
    return false if row == -1
    return false unless column_id == 'source'
    return false unless pathnames.length == 1
    return false unless /\.rb$/ =~ pathname
    true
  end

  def pathnames
    pasteboard.propertyListForType(NSFilenamesPboardType)
  end

  def pathname; pathnames[0]; end

  private 

  def pasteboard; raw_info.draggingPasteboard; end
end
