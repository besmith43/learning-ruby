#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'testutil'
require 'NotificationBox'

module NotificationBoxTests

  class Base < Test::Unit::TestCase
    def setup
      super
      @observed = NSObject.alloc.init
      @watcher = flexmock(SomeRandomWatcher.alloc.init)
    end
  end


  class TypicalUseTests < Base

    should "fill in the 'from' and 'to' objects with NotificationBoxes" do
      watcher_inbox = NotificationInBox.new(:local,
                                            :object => @observed,
                                            :observer => @watcher)
      watcher_inbox.observe(:name => 'name',
                            :selector => :posted)
      
      observed_outbox = NotificationOutBox.new(:local,
                                               :object => @observed)

      during {
        observed_outbox.post('name', :key => :value)
      }.behold! {
        @watcher.should_receive(:posted).
        once.
        with(this_notification("name", @observed, :key => :value))
      }
      watcher_inbox.stop_observing
    end

    should "explicitly stop observing before forgetting an object" do
      watcher_inbox = NotificationInBox.new(:local,
                                            :object => @observed,
                                            :observer => @watcher)
      watcher_inbox.observe(:name => 'name',
                            :selector => :posted)
      # Various notifications would be handled in here.
      watcher_inbox.stop_observing   # Moved stopping up here means...
      
      observed_outbox = NotificationOutBox.new(:local,
                                               :object => @observed)
      
      during {
        observed_outbox.post('name', :key => :value)
      }.behold! {
        @watcher.should_receive(:posted).never # ... nothing observed down here
      }
    end
  end

  # Note: everything interesting about the Outbox is tested indirectly
  # by inbox tests.

  class InboxVariations < Base
    context "the observe() method" do

      should "allow inbox to fill in all values" do
        @watcher_inbox = NotificationInBox.new(:local,
                                               :object => @observed,
                                               :observer => @watcher,
                                               :name => 'name',
                                               :selector => :posted)
        @watcher_inbox.observe
        and_so_the_watcher_gets_the_notification
      end

      should "allow inbox's defaults to be overriden" do
        @watcher_inbox = NotificationInBox.new(:local,
                                               :object => 'broken',
                                               :observer => 'broken',
                                               :name => 'broken',
                                               :selector => 'broken')
        @watcher_inbox.observe(:object => @observed,
                               :observer => @watcher,
                               :name => 'name',
                               :selector => :posted)
        and_so_the_watcher_gets_the_notification
      end

      should "allow the :object to be nicknamed :sender, for convenience" do
        @watcher_inbox = NotificationInBox.new(:local,
                                               :object => @observed,
                                               :observer => @watcher)
        @watcher_inbox.observe(:name => 'name', :selector => :posted)
        and_so_the_watcher_gets_the_notification
      end

      should "allow the :object to be nicknamed :app" do
        # This is for convenience with distributed notifications, but 
        # it can only be tested with local ones.
        @watcher_inbox = NotificationInBox.new(:local,
                                               :app => @observed,
                                               :observer => @watcher)
        @watcher_inbox.observe(:name => 'name', :selector => :posted)
        and_so_the_watcher_gets_the_notification
      end
    end

    def and_so_the_watcher_gets_the_notification
      observed_outbox = NotificationOutBox.new(:local,
                                               :object => @observed)
      
      during {
        observed_outbox.post('name', :key => :value)
        # Make sure object matters:
        observed_outbox.post('name', {:key => :value },
                             {:object => 'something irrelevant'})
        # Make sure name matters:
        observed_outbox.post('different name', :key => :value )
      }.behold! {
        @watcher.should_receive(:posted).
        once.
        with(this_notification("name", @observed, :key => :value))
      }
    ensure  # In case of test failure.
      @watcher_inbox.stop_observing
    end
  end

  class Base < Test::Unit::TestCase
    def run(result)
      super unless self.class == Base
    end
  end
end # module
