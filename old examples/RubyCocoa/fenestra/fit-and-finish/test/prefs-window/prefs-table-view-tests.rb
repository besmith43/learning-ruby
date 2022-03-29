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
  class PrefsTableViewTests < Test::Unit::TestCase
    include TableViewUtils
    include Announcements
    
    class SomeDataSource < OSX::NSObject
      def numberOfRowsInTableView(view); 3; end
      
      def tableView_objectValueForTableColumn_row(view, column, row)
        "#{column}-#{row}"
      end
    end

    def setup
      @sut = @table = PreferencesTableView.alloc.init
      
      @table.extend(Fenestrable)
      @table.addTableColumn(NSTableColumn.alloc.initWithIdentifier(:first))
      @table.addTableColumn(NSTableColumn.alloc.initWithIdentifier(:second))
      @table.dataSource = SomeDataSource.alloc.init

      @sut.awakeFromNib
    end

    context "A PreferencesTableView" do
      should "be a NSTableView subclass" do
        assert {PreferencesTableView.superclass == NSTableView}
      end

      should "allow filenames to be dropped on it" do
        assert { @table.registeredDraggedTypes.include?(NSFilenamesPboardType) }
      end
    end

    context "checking a location where a drop is possible" do
      setup do
        @info = rubycocoa_flexmock("drop info")
 
        @info.should_receive(:drop_would_work?, 0).at_least.once.
              and_return(true)
        @info.should_receive(:row, 0).at_least.once.
              and_return(1)
      end
      
      should "select the current row" do
        assert { @sut.numberOfSelectedRows == 0 } 
        @sut.fenestra.evaluate_location(@info)
        assert { @sut.numberOfSelectedRows == 1 } 
        assert { @sut.selectedRow == 1 }
      end

      should "signal that a copy is permitted" do
        retval = @sut.fenestra.evaluate_location(@info)
        assert { NSDragOperationCopy == retval }
      end
    end

    context "checking a location where a drop is not possible" do
      setup do 
        @info = rubycocoa_flexmock("drop info")
        @info.should_receive(:drop_would_work?, 0).at_least.once.
              and_return(false)
      end

      should "leave no row selected" do
        @sut.fenestra.evaluate_location(@info)
        assert { @sut.numberOfSelectedRows == 0 }
      end

      should "signal that no operation is permitted" do 
        retval = @sut.fenestra.evaluate_location(@info)
        assert { NSDragOperationNone == retval }
      end
    end

    context "exiting dragging" do
      should "leave no rows highlighted" do
        @sut.select_row(1)
        @sut.fenestra.forget_drag('ignored')
        assert { @sut.numberOfSelectedRows == 0 }
      end
    end

    context "dropping" do
      setup do
        inject_watchers_for(HasRubySource)
        watchers_are_notified.once.by_default
        @pathname = "/path/to/file.rb"
        @info = rubycocoa_flexmock("drop info")
        @info.should_receive(:pathname).at_least.once.
              and_return(@pathname)
        @info.should_receive(:row).at_least.once.
          and_return(1)
      end

      teardown do
        no_more_watchers
      end

      should "announce that a row's source should be updated" do
        during {
          @sut.drop(@info)
        }.behold! {
          expected = this_notification(HasRubySource,
                                       @sut,
                                       { :source => @pathname,
                                         :row => 1 })
          watchers_are_notified.once.with(expected)
        }
      end
      
      should "return true" do
        assert { @sut.drop(@info) }
      end
    end
  end
end
