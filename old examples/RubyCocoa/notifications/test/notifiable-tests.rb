#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'testutil'
require 'Notifiable'

module NotifiableTests

class NotificationObserver < NSObject
  include Notifiable
    
  attr_reader :received
    
  def init
    @received = {}
    connect_all_notification_observers
    super_init
  end

  def record(type, notification)
    @received[type] = [] unless @received[type]
    @received[type] << notification.copy
    # Note that notifications are often reused, so don't store
    # them without making a copy.
  end

  on_local_notification "matching name" do | notification |
    record :name_only, notification
  end

  # Objects are matched with pointer-equality, so must 
  # use NSString, not Ruby String (which would be converted).
  IMPORTANT_OBJECT = "arbitrary object".to_ns

  on_local_notification(nil, IMPORTANT_OBJECT) do | notification |
    record :object_only, notification
  end

  on_local_notification("both name and object count", IMPORTANT_OBJECT) do | notification |
    record :name_and_object, notification
  end

  REMOTE_OBJECT = "com.exampler.foo".to_ns

  on_remote_notification("some name", REMOTE_OBJECT) do | notification |
    record :remote, notification
  end

  include Test::Unit::Assertions
  def assert_structure(hash)
    hash.each do | type, expected_list |
      actual_list = @received[type]
      assert_not_nil(actual_list, "Nothing has been received for #{type.inspect}.")
      assert_equal(expected_list.length, actual_list.length,
                   "Actual: #{actual_list}")
      expected_list.each_with_index do | expected, i |
        actual = actual_list[i]
        assert_equal(expected[0], actual.name,
                     "#{actual.name} unexpected for #{type.inspect}. Should be #{expected[0]}.")
        if expected[1]
          assert_equal(expected[1], actual.object,
                       "#{actual.object} unexpected for #{type.inspect}. Should be #{expected[1]}.")
        end
      end
    end

    unwanted_types = [:name_only, :object_only, :name_and_object, :remote] - hash.keys
    unwanted_types.each do | type | 
      assert_nil(@received[type],
                 "Why does #{type.inspect} have contents?")
    end
  end

  def display_structure
    @received.each do | type, actual_list | 
      puts type.inspect
      actual_list.each do | notification | 
        name = notification.name.to_s
        object = notification.object && notification.object.to_s 
        puts "\t#{name.inspect}, #{object.inspect}"
      end
    end
  end
end


class TypicalExampleTest < Test::Unit::TestCase
  def setup
    super
    @observer = NotificationObserver.alloc.init
    @outbox = NotificationOutbox.new(:local, :object => self)
  end

  def teardown
    @observer.disconnect_all_notification_observers
    super
  end

  should "trigger observing on name alone, not using object" do
    begin
      @outbox.post("matching name")
      @outbox.post("matching name", nil, :object => "irrelevant")
      @outbox.post("some name that doesn't match")

      
      @observer.assert_structure(
              :name_only => [ ["matching name"],
                              ["matching name", "irrelevant"],
                            ])
    end
  end 

  should "describe object with optional second arg" do
    @outbox.post("both name and object count", nil,
                 :object => "not right".to_ns)
    @outbox.post("both name and object count", nil,
                 :object => NotificationObserver::IMPORTANT_OBJECT)
    @outbox.post("mismatching name", nil,
                 :object => NotificationObserver::IMPORTANT_OBJECT)

    @observer.assert_structure(
              :object_only => [ 
                               ["both name and object count", NotificationObserver::IMPORTANT_OBJECT],
                               ["mismatching name", NotificationObserver::IMPORTANT_OBJECT],
                              ],
              :name_and_object => [ 
                               ["both name and object count", NotificationObserver::IMPORTANT_OBJECT],
                              ])
  end

  should "use an NSDistributedNotificationCenter for remote version" do
    @outbox.post("note name", :app => NotificationObserver::REMOTE_OBJECT) # app synonym for :object
    # Posted to local but supposedly from remote app, so not received.

    @observer.assert_structure({})
    # Can't test actual receipt from remote apps because they 
    # can only be received in the run loop.
  end


end
   
class EvaluationAtRuntimeTests < Test::Unit::TestCase
  class DeferredNameObserver < NotificationObserver

    def initWithName(name)
      @name = name
      init
    end

    on_local_notification(lambda{ @name }) do | notification |
      record :local, notification
    end

    on_local_notification(nil, lambda{ @name }) do | notification |
      record :object, notification
    end
  end

  should "defer construction of a name" do
    begin
      name = "some name".to_ns
      not_name = "not " + name
      @observer = DeferredNameObserver.alloc.initWithName(name)
      @outbox = NotificationOutbox.new(:local, :object => self)
      @outbox.post(name)
      @outbox.post(name, nil, :object => "irrelevant")
      @outbox.post(not_name)
      @outbox.post(not_name, nil, :object => name)

      @observer.assert_structure(
              :local => [ [name],
                          [name, "irrelevant"],
                        ],
              :object => [ [not_name, name] ])
    ensure
      @observer.disconnect_all_notification_observers
    end
  end

end

class SuperClassTests < Test::Unit::TestCase
  class SuperClass < NotificationObserver
    on_local_notification("super") do | notification | 
      record :super, notification
    end
  end

  class SubClass < SuperClass
    on_local_notification("sub") do | notification |
      record :sub, notification
    end
  end

  should "apply superclass definitions to subclasses as well" do
    begin
      @observer = SubClass.alloc.init
      @outbox = NotificationOutbox.new(:local, :object => self)
      @outbox.post("super")
      @outbox.post("sub")
      @observer.assert_structure(
              :super => [ ["super"] ],
              :sub => [ ["sub"] ])
    ensure
      @observer.disconnect_all_notification_observers
    end

  end

end



class NotifiableHelperTest < Test::Unit::TestCase
  context "an observer" do
    should "contains two inboxes, one for local and one for remote notifications." do
      begin
        observer = NotificationObserver.alloc.init
        
        local = observer.notification_inbox(:local)
        assert(local.delegate.is_a?(NSNotificationCenter))
        
        remote = observer.notification_inbox(:remote)
        assert(remote.delegate.is_a?(NSDistributedNotificationCenter))
      ensure
        observer.disconnect_all_notification_observers
      end
    end
  end
end

end # module
