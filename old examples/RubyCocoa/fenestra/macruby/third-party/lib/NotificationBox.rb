#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class NotificationBox

  attr_reader :delegate # for testing
  
  def initialize(source_kind, state = {})
    klass = case source_kind.to_s
            when 'local'
              NSNotificationCenter
            when 'remote'
              NSDistributedNotificationCenter
            end
    @delegate = klass.defaultCenter
    @state = state
  end

  def add_state_to(hash = {})
    hash = @state.merge(hash)
    hash[:object] ||= hash[:sender]
    hash[:object] ||= hash[:app]
    hash
  end

  def required(hash, key)
    hash.fetch(key) do
      NSLog "key #{key.inspect} is not present in #{hash.inspect}."
      caller.each do | line | 
        NSLog line
      end
      NSApp.terminate(self)
    end
  end  
end


class NotificationInBox < NotificationBox
  def observe(hash = {})
    hash = add_state_to(hash)
    @delegate.addObserver required(hash, :observer),
              selector: required(hash, :selector),
              name: hash[:name],
              object: hash[:object]
  end

  def stop_observing(hash = {})
    hash = add_state_to(hash)
    @delegate.removeObserver(required(hash, :observer))
  end


end
NotificationInbox = NotificationInBox

class NotificationOutBox < NotificationBox
  def post(name, userInfo = nil, hash={})
    puts "Posting #{name}, #{userInfo.inspect} to #{@delegate}"
    hash = add_state_to(hash)
    @delegate.postNotificationName name,
              object: hash[:object],
              userInfo: userInfo
  end


end
NotificationOutbox = NotificationOutBox
