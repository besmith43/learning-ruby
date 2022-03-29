#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")
require File.dirname(__FILE__) + "/testutil"

class NSTableViewPatchTests < Test::Unit::TestCase

  class PatchDataSource < OSX::NSObject
    def numberOfRowsInTableView(view); 3; end
    
    def tableView_objectValueForTableColumn_row(view, column, row)
      "#{column}-#{row}"
    end
  end

  def setup
    @sut = @table = NSTableView.alloc.init
    @table.extend(NSTableViewPatches)
    @table.addTableColumn(NSTableColumn.alloc.initWithIdentifier(:first))
    @table.addTableColumn(NSTableColumn.alloc.initWithIdentifier(:second))
    @table.dataSource = PatchDataSource.alloc.init

    @table_origin = NSPoint.new(300, 300) # offset to show coordinate transforms
    @table.frame = NSRect.new(@table_origin.x, @table_origin.y,
                              @table.frame.width, @table.frame.height)
  end

  context "geometry support" do
    setup do 
      @expected_col = @sut.columnWithIdentifier(:second)
      @expected_row = 0
      table_pt = point_in_cell(@expected_col, @expected_row)
      @window_pt = @sut.objc_send(:convertPoint, table_pt,
                                  :toView, nil)
    end

    should "be able to discover column and row containing point" do 
      actual_col, actual_row = @sut.cell_for_window_point(@window_pt)
      assert { actual_col == @expected_col }
      assert { actual_row == @expected_row }
    end

    should "be able to discover just the row containing point" do 
      actual_row = @sut.row_for_window_point(@window_pt)
      assert { actual_row == @expected_row }
    end
  end

  context "shorthand methods" do
    should "allow terse selection of single row" do 
      assert { @sut.numberOfSelectedRows == 0 }
      @sut.select_row(0)
      assert { @sut.numberOfSelectedRows == 1 }
      assert { @sut.selectedRow == 0 }
    end

    should "allow terse discovery of column identifier" do
      assert { @sut.tableColumns[1].identifier.to_s == 'second' }
      assert { @sut.identifier_for_column_index(1).to_s == 'second' }
      # Well, *conceptually terser*, at least.
    end
  end

  def point_in_cell(column_index, row_index)
    cell_frame = @sut.frameOfCellAtColumn_row(column_index, row_index)
    x = cell_frame.x + cell_frame.width / 2 
    y = cell_frame.y + cell_frame.height / 2
    return NSPoint.new(x, y)
  end
end
