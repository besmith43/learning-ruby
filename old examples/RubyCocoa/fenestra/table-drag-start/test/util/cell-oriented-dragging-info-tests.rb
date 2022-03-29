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

class CellOrientedDraggingInfoTests  < Test::Unit::TestCase
  include OSX

  def setup    
    @raw_info = rubycocoa_flexmock("raw dragging info")
    @table = rubycocoa_flexmock("table")
    @sut = CellOrientedDraggingInfo.alloc.objc_send(:initWithTable, @table,
                                                :rawInfo, @raw_info)
  end

  [:row, :column].each do |axis|
    should "provide #{axis} index" do
      during {
        @sut.send(axis)
      }.behold! {
        @raw_info.should_receive(:draggingLocation, 0).
                  and_return("a dragging location")
        @table.should_receive(:cell_for_window_point, 1).
               with('a dragging location').
               and_return(["a column index", "a row index"])
      }
      assert { @result == "a #{axis} index" }
    end
  end

  should "provide column id" do
    during {
      @sut.column_id
    }.behold! {
      @raw_info.should_receive(:draggingLocation, 0).
                and_return("a dragging location")
      @table.should_receive(:cell_for_window_point, 1).
             with('a dragging location').
             and_return(["a column index", "a row index"])
      @table.should_receive(:identifier_for_column_index, 1).
             with('a column index').
             and_return('a column id')
    }
    assert { @result == "a column id" }
  end
end
