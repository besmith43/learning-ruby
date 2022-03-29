#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class CellOrientedDraggingInfo < OSX::NSObject
  include OSX

  def column; colrow[0]; end    # (1) 
  def row; colrow[1]; end    # (2) 
  def column_id; table.identifier_for_column_index(column); end     # (3) 

  def initWithTable_rawInfo(table, raw_info)    # (4) 
    @table = table
    @raw_info = raw_info
    init
  end

  private
  attr_reader :table, :raw_info    # (5) 
  
  def colrow
    table.cell_for_window_point(raw_info.draggingLocation)  # (6) 
  end
end
