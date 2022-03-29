#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module NSTableViewPatches
  include OSX

  def cell_for_window_point(window_point)   # (1) 
    table_point = convertPoint_fromView(window_point, nil)
    column_index = columnAtPoint(table_point)
    row_index = rowAtPoint(table_point)
    return column_index, row_index
  end
  
  def row_for_window_point(window_point)
    ignored, row_index = cell_for_window_point(window_point)
    row_index
  end

  def select_row(index)
    row_set = NSIndexSet.indexSetWithIndex(index)
    selectRowIndexes_byExtendingSelection(row_set, false)
  end

  def identifier_for_column_index(column_index)
    tableColumns[column_index].identifier
  end
end
