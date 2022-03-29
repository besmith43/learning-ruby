#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'stock-classes'
include OSX

# How do you get notified when an element is added to a
# to-many relationship (where a single object is related to 
# many component objects). 

# A Collection holds a collection of objects as its _content_. It
# plays a role analogous to an NSArrayController in Interface
# Builder's use of key-value binding.
#
# Notice that it holds onto an explicit Cocoa array.

class ObservableCollection < OSX::NSObject
  include OSX
  kvc_accessor :content

  def init
    initWithValues([])
  end

  def initWithValues(array)
    @content = NSMutableArray.alloc.init
    array.each do | elt | 
      @content << elt
    end
    super_init
  end

  def insertObject_inContentAtIndex(object, index)
    puts "called insert"
    willChange_valuesAtIndexes_forKey(NSKeyValueChangeInsertion,
                                      NSIndexSet.indexSetWithIndex(index),
                                      "content")

    @content[index] = object
    didChange_valuesAtIndexes_forKey(NSKeyValueChangeInsertion,
                                      NSIndexSet.indexSetWithIndex(index),
                                      "content")

  end

  def removeObjectFromContentAtIndex(index)
    puts "called delete"
    @contact.delete_at(index)
  end
end

# Here's the collection in question:
c = ObservableCollection.alloc.initWithValues([
               Observed.alloc.initWithValue(1),
               Observed.alloc.initWithValue(2)])  

w = Watcher.alloc.init

# This does NOT work: adding an observer on the collection's property 
# that identifies the components.

c.addObserver_forKeyPath_options_context(w, 'content',
                                         NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
                                         nil)


puts "Intial values: #{c.valueForKeyPath('content.value').to_ruby.inspect}"



puts "About to change, but nothing will be printed by watcher."
c.content.addObject(Observed.alloc.initWithValue(3))  

puts "Values after addition: #{c.valueForKeyPath('content.value').to_ruby.inspect}"

puts "The watcher does notice when the content is set to a new value."
puts "For example, here the content is replaced with an empty array:"

c.content = NSMutableArray.alloc.init

c.removeObserver_forKeyPath(w, 'content')

puts '====== Part that I cannot make work'

m = c.mutableArrayValueForKey('content')
indirect = Observed.alloc.initWithValue(m)

indirect.addObserver_forKeyPath_options_context(w, 'value',
                                         NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
                                         nil)

m.addObject(Observed.alloc.initWithValue(4))
puts indirect.value.inspect
puts c.content.inspect
