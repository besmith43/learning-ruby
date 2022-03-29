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

module PrefsWindowTests

  # This is how you fill an NSTableView without bindings - you hand
  # it a data source that defines particular methods. In this case,
  # the data source is read-only.
  class TableDataSource < OSX::NSObject
    def numberOfRowsInTableView(sender)
      2
    end

    def tableView_objectValueForTableColumn_row(view, col, row)
      "(#{col}, #{row})"
    end
  end

  class NSTableViewCharacterizationTests < Test::Unit::TestCase
    include OSX
    
    def setup
      super
      window_rect = NSRect.new(50, 50, 500, 500)
      make_window_with_rect(window_rect)

      @sut = @table = NSTableView.alloc.init

      ('col_A'..'col_C').each do | col_id |
        col = NSTableColumn.alloc.initWithIdentifier(col_id)
        @sut.addTableColumn(col)
      end
      @sut.dataSource = @table_data_source = TableDataSource.alloc.init

      @window.contentView.addSubview(@sut)

      assert { @table.frameOrigin == NSPoint.new(0.0, 0.0) }
      @table.frameOrigin = NSPoint.new(300.0, 300.0)
      assert { @table.frameOrigin == NSPoint.new(300.0, 300.0) }
    end

    def make_window_with_rect(window_rect)
      @window = NSWindow.alloc.objc_send(:initWithContentRect, window_rect,
                                         :styleMask, NSTitledWindowMask,
                                         :backing, NSBackingStoreBuffered,
                                         :defer, true)
    end


    context "A table view" do
      should "have (as normal) have its X coordinates increase from left to right" do
        col_0_rect = @sut.frameOfCellAtColumn_row(0, 0)
        col_1_rect = @sut.frameOfCellAtColumn_row(1, 0)
        assert { col_0_rect.x < col_1_rect.x }
      end

      should "have its Y coordinates increase from top down" do
        assert { @sut.isFlipped }

        row_0_rect = @sut.frameOfCellAtColumn_row(0, 0)
        row_1_rect = @sut.frameOfCellAtColumn_row(0, 1)
        assert { row_0_rect.y < row_1_rect.y }
      end

      should "have a frame that includes only rows and inter-cell spacing" do
        header_frame = @sut.headerView.frame
        @sut.headerView.frameSize = NSSize.new(100, header_frame.width)

        expected_height = @table_data_source.numberOfRowsInTableView('ignored') * 
                          (@sut.rowHeight + @sut.intercellSpacing.height)
        assert { @sut.frame.height == expected_height }

        # Demonstrate that the NSTableView frame height cannot include
        # the header view.
        assert { @sut.frame.height < 100 }
      end
    end
  end
end
