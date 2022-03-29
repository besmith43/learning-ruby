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
  class PrefsControllerChangeSourceTest < Test::Unit::TestCase
    include PrefsWindowUtils
    include Announcements

    def setup
      super
      
      make_fake_defaults_controller(random_prefs(2))

      @sut = @preferences_controller = PreferencesController.alloc.init
      the_universe_revolves_around(@sut) { 
        including_random_watchers_for(NeedsRubySource)
        including_random_announcers
      }
      connect_objects_in_universe
      awaken_all_objects
    end

    def teardown
      disconnect_objects_in_universe
      super
    end

    context 'initialization' do
      should "make the preferences controller the target of the table" do
        assert { @table.target == @sut } 
      end

      should "make :doubleClick the action taken on doubleclick" do
        assert { @table.doubleAction == 'doubleClick:' }
      end
    end

    context 'after initialization' do
      setup do 
        @source_column_index = PreferencesController.column_index_of(:source)
        @display_name_column_index = PreferencesController.column_index_of(:display_name)

        @original_sources = self.current_sources
      end

      context "in cases that do not launch file browser," do 
        context "clicking on non-source column" do 
          should 'still perform normal editing' do
            during_doubleclick_on(@display_name_column_index, 1).behold! {

              @table.should_receive(:editColumn_row_withEvent_select, 4).once.
                     with(@display_name_column_index, 1, any, 1)

              watchers_are_notified.never
            }
            assert { @original_sources == self.current_sources } 
            assert { selection_indexes(@table) == [1] }
          end
        end

        context "clicking outside normal bounds" do
          should 'do nothing (if out of row bounds)' do
            during_doubleclick_on(@source_column_index, -1).behold! {
              nothing_happens
            }
            assert { @original_sources == self.current_sources } 
          end

          should 'do nothing (if out of column bounds)' do
            during_doubleclick_on(-1, 1).behold! {
              nothing_happens
            }
            assert { @original_sources == self.current_sources } 
          end
        end
      end

      context "clicking in Source cell of a row" do
        should "post a notification asking for a Ruby file" do
          during_doubleclick_on(@source_column_index, 0).behold! {
            watchers_are_notified.once.
                                  with(on { | notification |
                                         row = notification.userInfo[:row]
                                         name = notification.name
                                         0 == row && name == NeedsRubySource
                                       })
            no_editing_starts
          }
        end
      end

      context "receiving a source file notification" do
        should "store the new source in preferences" do
          new_file = "/tmp/mumble.rb"

          some_object_announces(HasRubySource,
                                { :row => 0,
                                  :source => new_file })

          expected = [new_file] + @original_sources[1..-1] 
          assert { self.current_sources == expected }
        end
      end

    end

    def working_on(col, row)

      @table.should_receive(:clickedColumn).and_return(col)
      @table.should_receive(:clickedRow).and_return(row)

    end

    def current_sources
      sources = @sut.arrangedObjects.to_a.collect { | o | o.source }

      # For these tests, the default values and arranged objects
      # should always be in sync.
      assert { sources == @defaults_controller.sources }

      sources
    end

    def during_doubleclick_on(col, row)
      working_on(col, row)
      during { @sut.doubleClick('ignored') }
    end

    # Of the things that are perhaps supposed to happen, nothing does.
    # Doesn't prevent code under test from doing completely random
    # things, since this method doesn't check that nothing happens
    # anywhere in the universe of objects.
    def nothing_happens
      watchers_are_notified.never
      no_editing_starts
    end

    def no_editing_starts
      @table.should_receive(:editColumn_row_withEvent_select, 4).never
    end

  end
end
