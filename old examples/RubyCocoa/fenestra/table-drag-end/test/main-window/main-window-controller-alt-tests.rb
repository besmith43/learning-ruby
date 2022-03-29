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

class MainWindowControllerAltTest < Test::Unit::TestCase
  include OSX


  def setup
    super
    @outbox = NotificationOutBox.new(:local)
    @sut = MainWindowController.alloc.init  
    @sut.window = @window = rubycocoa_flexmock('window')
    @window.should_receive(:title=, 1).by_default
    @sut.awakeFromNib
  end

  def teardown
    @sut.disconnect_all_notification_observers
    super
  end

  context "awakening from nib (alt)" do

    # Note: need to do own setup/teardown. The outermost one
    # has already called awakeFromNib.
    should "set the title to its default value (alt)" do
      begin
        sut = MainWindowController.alloc.init
        sut.window = window = flexmock
        during { 
          sut.awakeFromNib
        }.behold! { 
          window.should_receive(:title=, 1).once.with(NO_APP_DESIGNATION)
        }
      ensure
        sut.disconnect_all_notification_observers
      end
    end
  end

  context "an AppChosen notification (alt)" do
    should "set the title to the app name (alt)" do
      during { 
        @outbox.post(Announcements::AppChosen, :app_name => 'test')
      }.behold! { 
        @window.should_receive(:title=, 1).once.with('test') 
      }
    end
  end

  context "a TimeToForgetApp notification (alt)" do
    should "set the title back to its default value (alt)" do 
      during { 
        @outbox.post(Announcements::TimeToForgetApp)
      }.behold! {
        @window.should_receive(:title=, 1).once.with(NO_APP_DESIGNATION)
      }
    end
  end
end
