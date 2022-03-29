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
  class PrefsControllerInitialTest < Test::Unit::TestCase
    include PrefsWindowUtils

    def setup
      super
      prefs = [{ :display_name => 'first' },
               { :display_name => 'second'}, 
               { :display_name => 'third' },
               { :display_name => 'fourth' },
               { :display_name => 'fifth' }]
      make_fake_defaults_controller(*prefs)
      @original_prefs_length = prefs.length
    end

    def teardown
      @sut.disconnect_all_notification_observers if @sut
      super
    end

    context "initialization" do
      setup do
         @sut = rubycocoa_flexmock(PreferencesController, 'sut')
      end

      should "connect the PreferencesController to the translators array in preferences" do
        during { 
          @sut.useDefaultsController(@defaults_controller)
        }.behold! {
          @sut.should_receive(BindToObject, 4).once.
          with('contentArray',
               @defaults_controller,
               'values.translators',
               on { | options |
                 options[NSValueTransformerBindingOption] != nil &&
                 options[NSHandlesContentAsCompoundValueBindingOption]
               })
        }
      end

      should "therefore propagate a change to preferences to the controller" do
        @sut.useDefaultsController(@defaults_controller)

        assert { @sut.arrangedObjects.length == @original_prefs_length } 
        remove_last_translator(@defaults_controller)
        assert { @sut.arrangedObjects.length == @original_prefs_length - 1} 
      end
    end

    context "awaking from Nib" do
      setup do 
        @sut = PreferencesController.alloc.init
        @sut.useDefaultsController(@defaults_controller)
      end

      should "include a mapping of each table column to a field in a translator preference" do
        @sut.table = create_table_with(mock_columns)
        during { 
          @sut.awakeFromNib
        }.behold! {
          @table.tableColumns.each do | col |
            col.should_receive(BindToObject, 4).once.
              with('value',
                   @sut,
                   "arrangedObjects.#{col.identifier}",
                   any)  # Should probably check options
          end
        }
      end

      should "therefore propagate initial preferences to table" do
        @sut.table = create_table_with(real_columns)
        assert { @table.numberOfRows == 0 }
        @sut.awakeFromNib
        assert { @table.numberOfRows == @original_prefs_length }
      end

      should "therefore propagate changed preferences to table" do 
        @sut.table = create_table_with(real_columns)
        @sut.awakeFromNib
        remove_last_translator(@defaults_controller)
        assert { @table.numberOfRows == @original_prefs_length - 1 }
      end
    end
  end
end
