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
      prefs = [{ :display_name => 'originally at 0' }, # (1) 
               { :display_name => 'originally at 1'}, 
               { :display_name => 'originally at 2' },
               { :display_name => 'originally at 3' },
               { :display_name => 'originally at 4' }]
      make_fake_defaults_controller(*prefs)

      @sut = @preferences_controller = PreferencesController.alloc.init # (2) 
      the_universe_revolves_around(@sut) # (3) 
      connect_objects_in_universe# (4) 
      awaken_all_objects# (5) 
    end

    def teardown
      disconnect_objects_in_universe   # (6)
      super   # (7)
    end


    context "adding a row" do 





      should "grow the table" do



        # ARRANGE

        old_table_length = row_count(@table)



        # ...





        # ACT


        @add_button.performClick('ignored sender')




        # ...








        # ASSERT



        assert { old_table_length + 1 == row_count(@sut) }
        assert { old_table_length + 1 == row_count(@table) }
      end






      should "put the new row in the last position" do
        old_names = @sut.valueForKeyPath('arrangedObjects.display_name')   # (8)

        @add_button.performClick('ignored sender')

        new_names = @sut.valueForKeyPath('arrangedObjects.display_name')
        assert { old_names == new_names[0...-1] }   # (9)
      end



      should "add a defaulted translator preference" do
        @add_button.performClick('ignored sender')

        names = @sut.valueForKeyPath('arrangedObjects.display_name')
        assert { names.last == DEFAULT_TRANSLATOR_DISPLAY_NAME }   # (10)
      end



      should "NOT mark the new preference as the favorite" do
        @add_button.performClick('ignored sender')

        deny { @sut.arrangedObjects.last.favorite }    # (11)
      end


=begin

      should "edit initial cell of the new row" do
        # ...
        assert { ... first cell of last row is edited ... }
      end

=end


      should_eventually "edit initial cell of the new row" do
        new_row_index = row_count(@table)
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                 with(0, new_row_index, any, any)
        }
      end


=begin

      should_eventually "edit initial cell of the new row" do
        new_row_index = row_count(@table)
        puts "expected row index = #{new_row_index}"  # (12)
        during { 
          @add_button.performClick('ignored sender')
          puts "table count: #{row_count(@table)}"  # (13)
          puts "sut count: #{row_count(@sut)}"  # (14)
        }.behold! {
#         @table.should_receive(:editColumn_row_withEvent_select, 4).once.
#                with(0, new_row_index, any, any)
        }
      end

=end



      should_eventually "select all text in edited cell" do
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {

=begin


             @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                    with(any, any, any, true)


=end
=begin

          # A version with debugging info printed.
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                 with(any, any, any, 
                      on { | arg |     # (15)
                        puts "select text: #{arg.inspect}"
                        arg == true
                      })

=end
# This will be needed to make this test pass. "Boolean-ness" is lost.
#=begin

          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                 with(any, any, any, 1)

#=end

        }
      end


      should_eventually "edit first cell in row even if columns have been rearranged" do
        @table.moveColumn_toColumn(0, 3)
        
        during { 
          @add_button.performClick('ignored sender')
        }.behold! {
          @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                 with(0, any, any, any)
        }
      end


      should_eventually "select the rest of the row so that tabbing out " +
                        "of the first cell moves to the second" do
        @add_button.performClick('ignored sender')
        
        assert { selection_indexes(@sut) == [row_count(@sut) - 1] }
        assert { selection_indexes(@table) == [row_count(@table) - 1] }
      end

    end

  end
end
