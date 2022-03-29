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

class PrefsTableDraggingInfoTests  < Test::Unit::TestCase
  include OSX

  def setup

    @raw_info = rubycocoa_flexmock("raw dragging info")
    @sut = rubycocoa_flexmock(PrefsTableDraggingInfo) do | klass |   
      klass.alloc.objc_send(:initWithTable, :unused,  # (1)
                            :rawInfo, @raw_info)

    end
  end

  should "extend CellOrientedDraggingInfo" do
    assert { @sut.is_a? CellOrientedDraggingInfo }
  end

  context "pathnames method" do
    should "provide pathnames found in dragging info" do
      during { 
        @sut.pathnames  
      }.behold! {
        @raw_info.should_receive(:draggingPasteboard, 0).once.
                  and_return(pasteboard_with_files(*some_paths))
      }
      assert { @result == some_paths }  
    end
  end

  context "pathname method" do
    should "provide only pathname found in dragging info" do
      during { 
        @sut.pathname
      }.behold! {
        @raw_info.should_receive(:draggingPasteboard, 0).once.
                  and_return(pasteboard_with_files(some_path))
      }
      assert { @result == some_path }
    end
  end
  
  context "evaluating a drop" do
    setup do    
      @sut.should_receive(:row, 0).and_return(1).by_default
      @sut.should_receive(:column_id, 0).
            and_return("source".to_ns).
            by_default
      @sut.should_receive(:pathnames, 0).
            and_return(["/path/to/file.rb"].to_ns).
            by_default
    end

    should "reject when nonexistent row" do  
      during { 
        @sut.drop_would_work?
      }.behold! {
        @sut.should_receive(:row, 0).at_least.once.
              and_return(-1)
      }
      deny { @result }
    end

    should "reject when column_id is not source" do  
      during { 
        @sut.drop_would_work?
      }.behold! {
        @sut.should_receive(:column_id, 0).at_least.once.
              and_return("display_name".to_ns)
      }
      deny { @result }
    end

    should "reject when pathname doesn't name a Ruby file" do
      during { 
        @sut.drop_would_work?
      }.behold! {
        @sut.should_receive(:pathnames, 0).at_least.once.
              and_return(["/path/to/foorb"].to_ns)
      }
      deny { @result }
    end

    should "reject dragging multiple files" do
      during { 
        @sut.drop_would_work?
      }.behold! {
        @sut.should_receive(:pathnames, 0).at_least.once.
              and_return(["/path/to/file.rb", "/path/to/other.rb"].to_ns)
      }
      deny { @result }
    end

    should "accept otherwise" do  
      assert { @sut.drop_would_work? }
    end
  end


  def pasteboard_with_files(*pathnames)
    pasteboard = NSPasteboard.pasteboardWithUniqueName
    pasteboard.objc_send(:declareTypes, [NSFilenamesPboardType],
                         :owner, nil)
    pasteboard.objc_send(:setPropertyList, pathnames,
                         :forType, NSFilenamesPboardType)
    pasteboard
  end

  def some_path
    some_paths[0]
  end

  # You can't put any old string on an NSFilenamesPboardType
  # pasteboard.  It has to really exist. This is yet more evidence
  # that knowledge of files should be separated into one or more
  # business logic classes.  Low-level tests that have to touch the
  # file system (database, network, ...) often indicate poor
  # separation of concerns.
  def some_paths
    Dir['*']
  end
end
