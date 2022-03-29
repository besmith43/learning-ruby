#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'
include OSX

class KVC < NSObject
  # Key-value coding depends two methods existing:
  def instance; @instance; end
  def instance=(value); @instance = value; end

  def init
    @instance = 'starting value of @instance'
    self
  end
end
  
k = KVC.alloc.init
puts "Initial value of k: #{k.valueForKey('instance')}"
puts "Setting k."
k.setValue_forKey('new value', 'instance')
puts "New value of k: #{k.valueForKey('instance')}"

k2 = KVC.alloc.init
puts "Setting k's instance to k2."
k.setValue_forKey(k2, 'instance')
puts "instance.instance value is: #{k.valueForKeyPath('instance.instance')}"
puts "Setting k.instance.instance."
k.setValue_forKeyPath('new value', 'instance.instance')
puts "instance.instance value is: #{k.valueForKeyPath('instance.instance')}"
