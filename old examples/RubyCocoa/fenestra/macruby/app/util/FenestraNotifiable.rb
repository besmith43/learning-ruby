#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Fenestra-specific additions to the Notifiable module. Note that I'm
# pretending that Notifiable was written by someone else so that I can
# show something in .../third-party/lib.

require 'Notifiable'
require 'util/Constants'

module FenestraNotifiable
  include Notifiable
  include Announcements

  $stderr.puts 1
  $stderr.puts Announcements::AppChosen
  $stderr.puts ancestors.inspect
  $stderr.puts AppChosen

  def self.included(mod)
    mod.extend NotifiableClass
  end

  def post(*args); @outbox.post(*args); end

  def notifiable_awakeFromNib
    connect_all_notification_observers
    @outbox = NotificationOutBox.new(:local, :object => self)
  end
end
