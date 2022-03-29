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
  class RubyFileChooserControllerTest < Test::Unit::TestCase
    include RubyFileChooserControllerUniverse
    include Announcements
    
    context 'initialization' do
      should "use an NSOpenPanel unless handed a special one" do
        sut = RubyFileChooserController.alloc.init
        sut.extend(Fenestrable)
        assert { sut.fenestra.panel.is_a? NSOpenPanel }
      end

      should "allow the panel object to be specified" do
        panel = rubycocoa_flexmock(NSOpenPanel) do | klass |
          klass.openPanel
        end
        sut = RubyFileChooserController.alloc.initWithPanel(panel)
        sut.extend(Fenestrable)
        assert { sut.fenestra.panel == panel }
      end

      should "prohibit multiple selections" do 
        sut = RubyFileChooserController.alloc.init
        sut.extend(Fenestrable)
        deny { sut.fenestra.panel.allowsMultipleSelection }
      end
    end

    context "in action" do
      setup do
        @chooser_panel = rubycocoa_flexmock(NSOpenPanel) do | klass |
          klass.openPanel
        end

        @sut = @ruby_chooser_controller = RubyFileChooserController.alloc
        the_universe_revolves_around(@sut) {
          including_random_watchers_for(HasRubySource)
          including_random_announcers
        }
        connect_objects_in_universe
        awaken_all_objects
      end

      teardown do
        disconnect_objects_in_universe
      end


      should_eventually "respond to NeedsRubySource by starting chooser" do
        during { 
          some_object_announces(NeedsRubySource)
        }.behold! {
          @chooser_panel.should_receive(:runModalForTypes, 1).once
        }
      end

      should_eventually "restrict chooseable files to ruby files" do
        during { 
          some_object_announces(NeedsRubySource)
        }.behold! {
          @chooser_panel.should_receive(:runModalForTypes, 1).once.
                         with(['rb'])
        }
      end

      should_eventually "do nothing if panel cancels" do
        during { 
          some_object_announces(NeedsRubySource)
        }.behold! {
          @chooser_panel.should_receive(:runModalForTypes, 1).once.
                         and_return(NSCancelButton)
          watchers_are_notified.never
        }
      end

      context "when file is chosen," do
        should_eventually "announce HasRubySource with source and row" do
          during { 
            some_object_announces(NeedsRubySource, { :row => 1000 })
          }.behold! {
            chosen_source = 'path/to/ruby/file.rb'

            @chooser_panel.should_receive(:runModalForTypes, 1).once.
                           and_return(NSOKButton)
            @chooser_panel.should_receive(:filename).once.
                           and_return(chosen_source)

            expected = this_notification(HasRubySource,
                                         @sut,
                                         { :source => chosen_source,
                                           :row => 1000 })
            watchers_are_notified.once.with(expected)
          }
        end
      end

    end
  end
end
