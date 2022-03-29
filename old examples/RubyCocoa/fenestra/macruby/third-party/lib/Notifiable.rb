#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'NotificationBox'

class NSNotification
  def [](user_info_key)
    self.userInfo[user_info_key]
  end
end

module NotifiableClass
  def notification_seeds
    @notification_seeds = [] unless @notification_seeds
    @notification_seeds
  end

  def wire_together(inbox_type, notification_name, object, selector_name, &block)
    seed = {
      :inbox_type => inbox_type,
      :name => notification_name,
      :object => object,
      :selector => selector_name }
    notification_seeds << seed
    define_method(selector_name, &block)
  end

  def on_local_notification(notification_name, object = nil, &block)
    wire_together(:local, notification_name, object, selectorize(notification_name), &block)
  end

  def on_remote_notification(notification_name, object = nil, &block)
    wire_together(:remote, notification_name, object, selectorize(notification_name), &block)
  end


  # Todo: If same notification name is used for different objects, 
  # there will be two methods with same value. Uniqueify.
  # Should be enough to use object_id of the name, right? Strings
  # aren't interned.

  # Utilities
  def selectorize(name)
    if name.is_a? Proc
      "results_of_lambda_#{name.object_id.to_s}:"
    else
      suffix = (name.nil? ? '__any_old_name' : ruby_id_from(name))
      "notification_action_for__#{suffix}:"
    end
  end

  def ruby_id_from(string)
    string.gsub(/\./, '_').gsub(/\W/, '')
  end

end

class Class
  def hierarchy_including_self
    if superclass
      [self] + superclass.hierarchy_including_self
    else
      [self]
    end
  end

  def hierarchy_including_if(&block)
    hierarchy_including_self.find_all(&block)
  end
end

module Notifiable
  def self.included(mod)
    mod.extend NotifiableClass
  end

  class << self
    # Some classes for testing
    attr_reader :forcing_local_notifications, :notification_object

    def force_local_notifications
      @forcing_local_notifications = true
    end

    def resume_remote_notifications
      @forcing_local_notifications = false
    end

    def use_notification_object(value)
      @notification_object = value
    end

    def forget_notification_object
      @notification_object = nil
    end
  end
  

  def notification_inbox(type)
    @notification_inboxes = {} unless @notification_inboxes
    unless @notification_inboxes.has_key?(type)
      @notification_inboxes[type] = NotificationInBox.new(type, :observer => self)
    end
    @notification_inboxes[type]
  end
  
  # TODO: Might be better to use self.class.instance_variable_get
  # instead of polluting the namespace.

  def connect_all_notification_observers
    with_each_notifiable_class do | klass | 
      klass.notification_seeds.each do | seed |
        seed = seed.dup   # Original might be reused.
        notifiables_resolve_procs(seed)
        notifiables_tweek_for_testing(seed)
        notification_inbox(seed[:inbox_type]).observe(seed)
      end
    end
  end

  def notifiables_resolve_procs(seed)
    seed[:name] = instance_eval(&seed[:name]) if seed[:name].is_a?(Proc)
    seed[:object] = instance_eval(&seed[:object]) if seed[:object].is_a?(Proc)
  end

  def notifiables_tweek_for_testing(seed)
    if Notifiable.forcing_local_notifications && seed[:inbox_type] == :remote
      seed[:inbox_type] = :local
      seed[:object] = Notifiable.notification_object if Notifiable.notification_object
    end
  end

  def disconnect_all_notification_observers
    with_each_notifiable_class do | klass | 
      klass.notification_seeds.each do | seed |
        seed = seed.dup   # Original might be reused.
        notifiables_resolve_procs(seed)
        notifiables_tweek_for_testing(seed)
        notification_inbox(seed[:inbox_type]).stop_observing(seed)
      end
    end
  end

  def with_each_notifiable_class(&block)
    notifiables = self.class.hierarchy_including_if { | klass |
      klass.ancestors.include?(Notifiable)
    }
    notifiables.each(&block)
  end

end
