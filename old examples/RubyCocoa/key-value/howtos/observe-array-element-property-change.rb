#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'stock-classes'

# How do you get notified when an array element has its property change?


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
    @content[index] = object
  end

  def removeObjectFromContentAtIndex(index)
    puts "called delete"
    @contact.delete_at(index)
  end
end



c = ObservableCollection.alloc.initWithValues([Observed.alloc.initWithValue(1), Observed.alloc.initWithValue(2)]) 


w = Watcher.alloc.init
key = 'content.value'

# This will fail:
c.addObserver_forKeyPath_options_context(w, key,
                                         OSX::NSKeyValueObservingOptionNew | OSX::NSKeyValueObservingOptionOld,
                                         nil)


c.content[0].value = 'newval'

c.removeObserver_forKeyPath(w, key)
