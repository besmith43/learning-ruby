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
  class PrefsControllerRemoveActionTest < Test::Unit::TestCase
    include PrefsWindowUtils

    def setup
      super
      @prefs = [{ :display_name => 'originally at 0' },
               { :display_name => 'originally at 1'}, 
               { :display_name => 'originally at 2' },
               { :display_name => 'originally at 3' },
               { :display_name => 'originally at 4' }]
      make_fake_defaults_controller(*@prefs)

      @sut = @preferences_controller = PreferencesController.alloc.init
      the_universe_revolves_around(@sut)
      connect_objects_in_universe
      awaken_all_objects
    end

    def teardown
      disconnect_objects_in_universe
      super
    end

    context "removing a row" do
      should "remove the currently selected row from the table" do
        assert { row_count(@table) == 5 }

        make_row_selection(1)
        @remove_button.performClick('ignored sender')
        # This is the best we can check:
        assert { row_count(@table) == 4 }
      end

      should "remove the currently selected row from the preferences" do
        make_row_selection(2)
        chosen_name = @prefs[2][:display_name]

        assert { defaults_contains?(chosen_name) } 
        @remove_button.performClick('ignored sender')

        deny { defaults_contains?(chosen_name) } 
      end

      should "do nothing if no row is selected" do
        select_nothing

        @remove_button.performClick('ignored sender')

        assert { row_count(@table) == 5 }
        assert { row_count(@sut)  == 5 }
        assert { selection_indexes(@sut) == [] } 
        assert { selection_indexes(@table) == [] } 
      end

      should "remove multiple preferences if multiple rows selected" do 
        selected = [2, 4]
        make_row_selection(*selected)

        @remove_button.performClick('ignored sender')

        assert { row_count(@table) == 3 }
        selected.each do | index | 
          name = @prefs[index][:display_name]
          deny { defaults_contains?(name) } 
        end
      end

      # In the following, selected elements are surrounded by underscores

      # 0 1 _2_ 3 4   => 
      # 0 1 _3_ 4
      should "select the next row, if there is one" do
        make_row_selection(2)

        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [2] } 
        assert { selection_indexes(@table) == [2] } 
      end

      # 0 _1_ _2_ 3 4 => 
      # 0 _3_  4
      should "even select the next row if given a selected range" do
        make_row_selection(1, 2)

        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [1] } 
        assert { selection_indexes(@table) == [1] } 
      end

      # _0_ _1_ 2 _3_ 4 =>
      #  2  _4_
      should "even select next row if given a disjoint set" do
        make_row_selection(0, 1, 3)
        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [1] } 
        assert { selection_indexes(@table) == [1] } 
      end

      # 0 1 2  3 _4_ => 
      # 0 1 2 _3_ 
      should "select the last table row, if there is no next row" do
        make_row_selection(4)

        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [3] } 
        assert { selection_indexes(@table) == [3] } 
      end

      # 0 1  2 _3_ _4_ => 
      # 0 1 _2_ 
      should "even select the last row if given a contiguous range" do
        make_row_selection(3, 4)

        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [2] } 
        assert { selection_indexes(@table) == [2] } 
      end

      # 0 1  _2_ 3 _4_ => 
      # 0 1 _3_ 
      should "even select the last row in a disjoint range" do
        make_row_selection(2, 4)

        @remove_button.performClick('ignored sender')

        assert { selection_indexes(@sut) == [2] } 
        assert { selection_indexes(@table) == [2] } 
      end

      # _0_ _1_ _2_ _3_ _4_ =>
      # 
      should "select nothing if the table is now empty" do
        make_row_selection(*(0..4).to_a)
        @remove_button.performClick('ignored sender')

        assert { row_count(@sut) == 0 } # Just to make sure
        assert { selection_indexes(@sut) == [] } 
        assert { selection_indexes(@table) == [] } 
      end
      
    end
  end
end
