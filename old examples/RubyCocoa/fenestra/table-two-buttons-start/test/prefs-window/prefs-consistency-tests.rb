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
  class PrefsControllerConsistencyTest < Test::Unit::TestCase
    include PrefsWindowUtils

    def setup
      super

      prefs = [{ :display_name => 'original bff', :favorite => true },
               { :display_name => 'new bff', :favorite => false },
               { :display_name => 'identical', :favorite => false },
               { :display_name => 'identical', :favorite => false }
              ]
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

    context "choosing a favorite" do
      setup do

        assert { favorites(@sut) == [true, false, false, false] } 
        make_this_the_favorite(1)           #^

      end

      should_eventually "cause any old favorite to cease being favorite" do

        assert { favorites(@sut) == [false, true, false, false] } 

      end

      should_eventually "propagate change into the defaults controller" do
        assert { favorites(@defaults_controller) == [false, true, false, false] } 
      end
    end

    context "identical rows" do
      should_eventually "not fool Fenestra into resetting a just-set row back to false (bugfix)" do
        make_this_the_favorite(3)                                         
        assert { favorites(@defaults_controller) == [false, false, false, true] } 
        make_this_the_favorite(2)                                   #^
        assert { favorites(@defaults_controller) == [false, false, true, false] } 
        # Bug produced this pattern:                [false, false, false, false] } 

        # And try it the other way, for grins.
        make_this_the_favorite(3)                                          #^
        assert { favorites(@defaults_controller) == [false, false, false, true] } 
      end
    end

    context "changing the current favorite so it's no longer favorite" do
      should "cause all preferences to be not-favorite" do
        assert { favorites(@sut) == [true, false, false, false] } 
        make_this_not_favorite(0)     #^
        assert { favorites(@sut) == [false, false, false, false] }
      end
    end

    context "resetting a non-favorite to non-favorite" do
      should "leave the favorite alone" do
        assert { favorites(@sut) == [true, false, false, false] } 
        make_this_not_favorite(1)           #^
        assert { favorites(@sut) == [true, false, false, false] } 
      end
    end

    context "a change to any other keypath" do
      should "do nothing" do
         @sut.objc_send(:observeValueForKeyPath, 'something.else',
                       :ofObject, 'ignored',
                       :change, nil,
                       :context, nil)
        assert { favorites(@sut) == [ true, false, false, false ] }
      end
    end

    def make_this_the_favorite(index)
      make_this(index, true)
    end

    def make_this_not_favorite(index)
      make_this(index, false)
    end

    def make_this(index, value)

      @sut.arrangedObjects[index].favorite = value


      @sut.objc_send(:observeValueForKeyPath, 'favorite',
                     :ofObject, @sut.arrangedObjects[index],
                     :change, nil,
                     :context, nil)

    end
  end
end
