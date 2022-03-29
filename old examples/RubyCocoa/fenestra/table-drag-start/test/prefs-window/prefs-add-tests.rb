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
  class PrefsControllerAddActionTest < Test::Unit::TestCase
    include PrefsWindowUtils

    def setup
      super
      prefs = [{ :display_name => 'originally at 0' },
               { :display_name => 'originally at 1'}, 
               { :display_name => 'originally at 2' },
               { :display_name => 'originally at 3' },
               { :display_name => 'originally at 4' }]
      make_fake_defaults_controller(*prefs)

      @sut = @preferences_controller = PreferencesController.alloc.init
      the_universe_revolves_around(@sut)
      connect_objects_in_universe
      awaken_all_objects
    end

    def teardown
      disconnect_objects_in_universe
      super
    end

    context "adding a row" do 

      should "grow the table" do
        old_table_length = row_count(@table)

        @add_button.performClick('ignored sender')

        assert { old_table_length + 1 == row_count(@sut) }
        assert { old_table_length + 1 == row_count(@table) }
      end

      should "put the new row in the last position" do
        old_names = @sut.valueForKeyPath('arrangedObjects.display_name')

        @add_button.performClick('ignored sender')

        new_names = @sut.valueForKeyPath('arrangedObjects.display_name')
        assert { old_names == new_names[0...-1] } 
      end

      should "add a defaulted translator preference" do
        @add_button.performClick('ignored sender')

        names = @sut.valueForKeyPath('arrangedObjects.display_name')
        assert { names.last == DEFAULT_TRANSLATOR_DISPLAY_NAME }
      end

      should "NOT mark the new preference as the favorite" do
        @add_button.performClick('ignored sender')

        deny { @sut.arrangedObjects.last.favorite }  
      end

      should "edit initial cell of the new row" do
        new_row_index = row_count(@table)
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
          with(0, new_row_index, any, any)
        }
      end

      should "edit select all text in edited cell" do
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                 with(any, any, any, 1)
        }
      end

      should "edit first cell in row even if columns have been rearranged" do
        @table.moveColumn_toColumn(0, 3)
        
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
          with(0, any, any, any)
        }
      end

      should "select the rest of the row so that tabbing out of first cell" +
             " moves to the second" do
        @add_button.performClick('ignored sender')
        
        assert { selection_indexes(@sut) == [row_count(@sut) - 1] }
        assert { selection_indexes(@table) == [row_count(@table) - 1] }
      end
    end

  end
end
