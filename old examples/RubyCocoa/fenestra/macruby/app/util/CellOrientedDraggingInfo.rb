#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class CellOrientedDraggingInfo

  def initWithTable(table, rawInfo:raw_info)
    @table = table
    @raw_info = raw_info
    init
  end

  def column; colrow[0]; end
  def row; colrow[1]; end

  def column_id
    table.identifier_for_column_index(column)
  end

  private
  attr_reader :table, :raw_info
  
  def colrow
    table.cell_for_window_point(raw_info.draggingLocation)  # (1) 
  end
end
