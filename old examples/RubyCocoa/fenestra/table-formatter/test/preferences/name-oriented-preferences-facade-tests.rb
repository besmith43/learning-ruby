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

class NameOrientedPreferencesFacadeTest < Test::Unit::TestCase
  include OSX
  include UserDefaultsHelpers

  context "display_name_of_favorite_translator" do
    should "return a favorite if there is one" do
      @sut = new_preferences_facade_faking( { :display_name => 'not favorite',
                                              :favorite => false }, 
                                            { :display_name => 'favorite name',
                                              :favorite => true })
      actual = @sut.display_name_of_favorite_translator
      assert { 'favorite name' == actual }
    end

  end

  should "return the empty string if there's no favorite" do
    @sut = new_preferences_facade_faking({ :display_name => 'other name',
                                           :favorite => false })
    actual = @sut.display_name_of_favorite_translator
    assert { '' == actual }
  end



  context "Method translator_display_names" do
    should "return a list of display names" do
      expected = ['first name', 'second name']
      @sut = new_preferences_facade_faking({ :display_name => expected[0]},
                                           { :display_name => expected[1]})
      actual = @sut.translator_display_names
      assert { expected.sort == actual.sort }
    end
  end


  context "choosing a translator preference" do
    context "from the existing list" do 

      setup do
        @sut = new_preferences_facade_faking({ :display_name => 'first',
                                               :favorite => true },
                                             { :display_name => 'second',
                                               :favorite => false })
        @sut.extend(Fenestrable)
        @actual = @sut.fenestra.translator_pref_for_display_name('second')
      end

      should "return the matching translator" do
        assert { 'second' == @actual.display_name }
      end

      should "set the matching translator to be the only favorite" do
        both = @sut.fenestra.all_translator_prefs
        deny { both[0].favorite } 
        assert { both[1].favorite }
      end
    end

    context "that doesn't exist yet" do
      setup do
        @sut = new_preferences_facade_faking({ :display_name => 'only',
                                                    :favorite => true })
        @sut.extend(Fenestrable)
        @actual = @sut.fenestra.translator_pref_for_display_name('com.exampler.app')
      end

      should "produce a new entry" do
        assert { @actual.is_a? TranslatorPreference }
      end

      should "set both display name and app name to choice" do
        assert { 'com.exampler.app' == @actual.display_name }
        assert { 'com.exampler.app' == @actual.app_name }
      end

      should "use ToString as the translator" do
        assert { 'ToString' == @actual.class_name }
      end

      should "leave the translator source as nil" do
        assert { nil == @actual.source }
      end

      should "set new entry to be the only favorite" do
        both = @sut.fenestra.all_translator_prefs
        deny { both[0].favorite } 
        assert { both[1].favorite }
      end

      should "add the new entry to the list" do
        names = @sut.translator_display_names
        assert { names.sort == ['only', 'com.exampler.app'].sort }
      end
    end

    should  "archive changes" do
      @sut = new_preferences_facade_mocking({ :display_name => 'first',
                                              :favorite => true },
                                            { :display_name => 'second',
                                              :favorite => false })
      @sut.extend(Fenestrable)
      during { 
        @sut.fenestra.translator_pref_for_display_name('second')
      }.behold! {
        @defaults_controller.should_receive(:setValue_forKeyPath).
        once.
        with(on { | archived |
               original = unarchived_translator_prefs(archived)
               ! original[0].favorite && original[1].favorite
             },
             'values.translators')
      }
    end

    context "choosing a translator" do

      setup do 
        @sut = new_preferences_facade_faking({ :display_name => 'first',
                                               :app_name => 'com.exampler.first',
                                               :class_name => 'ToString'})
        @actual = @sut.translator_for_display_name('first')
      end
      
      should "produce an object of the class described in preferences" do
        assert { Translators::ToString == @actual.class }
      end

      should "initialize the object with the app name" do
        @actual.extend(Fenestrable)
        assert { 'com.exampler.first' == @actual.fenestra.app }
      end
    end

  end

end

