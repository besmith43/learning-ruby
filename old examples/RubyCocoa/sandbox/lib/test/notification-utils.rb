#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Use this class when creating a mock that's to receive a notification.
# I don't know why you can't use NSObject, but you can't -- the notification
# will not be received.
class SomeRandomWatcher < OSX::NSObject
end

class Test::Unit::TestCase

  # Use these in _with_ expectations.
  def notification_name(name)
    on { | notification | 
      notification.name == name
    }
  end

  def this_notification(name, object = nil, userInfo = nil)
    on { | notification |
      object = notification.object if object == any
      notification.name == name && 
      notification.object == object && 
      notification.userInfo == userInfo.to_ns
    }
  end

  def userinfo(expected)
    on { | notification |
      if notification.userInfo == expected.to_ns
        true
      else
        puts "actual: #{notification.userInfo.inspect}"
        puts "expected: #{expected.to_ns.inspect}"
        false
      end
    }
  end

end
