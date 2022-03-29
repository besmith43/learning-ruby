#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'rubygems'
require 'osx/cocoa'
include OSX

class Fenestration < OSX::NSObject
  def self.to_observe(*event_tags, &block)
    const_set('Selectors', {}) unless const_defined?('Selectors')
    event_tags.each do | event_tag | 
      const_get('Selectors')[event_tag] = selector = selector_for(event_tag)
      define_method(selector, &block)
    end
    self
  end

  def self.selector_for(string)
    "notification_selector_for__" + string.gsub(/\./, '_').gsub(/\W/, '')
  end

  def open_fenestration(app_name)
    center = OSX::NSDistributedNotificationCenter.defaultCenter
    self.class.const_get('Selectors').each do | event_tag, selector | 
      center.addObserver_selector_name_object(self, selector,
                                              app_name + '.' + event_tag,
                                              nil)
    end
  end
end

class App < Fenestration

  to_observe('all.before') do  | notification |
    puts "action: #{notification.userInfo[:action]}"
  end

  to_observe('show.before', 'show.after') do | notification | 
    show_one_user(notification.userInfo[:user])
  end

  to_observe('index.after') do | notification |
    users = notification.userInfo[:users]
    puts "User count: #{users.size}"
    users.each do | user | 
      show_one_user(user)
    end
  end

  def show_one_user(user)
    puts "#{user['name']} created #{user['creations']}, viewed #{user['views']}"
  end

end

NSApplication.sharedApplication
app = App.alloc.init
app.open_fenestration('com.exampler.counting')
puts App::Selectors.inspect
NSApp.delegate = app
NSApp.run                         

