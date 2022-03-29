#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# This is a simple example of how bound and root objects are
# implemented in key-value binding.

require 'util'
require 'ostruct'


class Root < NSObject


=begin
  # Shorthand definition of KVO-compliant setter (and getter)

  kvc_accessor :property

=end

  # Defining the KVO-compliant setter by hand.

  attr_reader :property

  def property=(value)
    willChangeValueForKey(:property)  #(1)
    @property = value
    didChangeValueForKey(:property)  #(2)
    @property
  end

  def initWithValue(value)
    @property = value
    self
  end
end





class BoundObject < NSObject


  def init
    @data = {}
    @tracker = BindingTracker.new
    self
  end



  ib_action :upcase do | sender |
    older = @data['some binding name']
    newer = older.upcase
    @data['some binding name'] = newer
    @tracker.propagate('some binding name', newer)  # (3) 
  end


  def some_binding_name; @data['some binding name']; end



  def bind_toObject_withKeyPath_options(bound_name, root, keypath, options)

    @tracker.remember(bound_name, root, keypath)   # (4)
    
    root.objc_send(:addObserver, self,  # (5)
                   :forKeyPath, keypath,
                   :options, NSKeyValueObservingOptionInitial |
                             NSKeyValueObservingOptionNew |
                             NSKeyValueObservingOptionOld,
                   :context, nil)
  end



  # ...


  def observeValueForKeyPath_ofObject_change_context(keypath, root,
                                                     change, context)

    # ...


=begin


    puts "Received update from #{root}://#{keypath}:"
    puts change.to_ruby.inspect

=end

    bound_name = @tracker.bound_name_for(root, keypath)
    @data[bound_name] = change['new']


  end



end



class BindingTracker
  # ...

  def initialize
    @bindings = []
  end

  def remember(bound_name, root, keypath)
    bound_name = bound_name.to_s
    keypath = keypath.to_s
    @bindings << OpenStruct.new(:bound_name => bound_name,
                                :root => root,
                                :keypath => keypath)
  end


  def propagate(bound_name, value)
    target = rooted_keypath_for(bound_name)
    target.root.setValue_forKeyPath(value, target.keypath)
  end


  def bound_name_for(root, keypath)
    keypath = keypath.to_s
    @bindings.find { | binding | 
      binding.root == root && binding.keypath == keypath
    }.bound_name
  end

  private

  def rooted_keypath_for(bound_name)
    bound_name = bound_name.to_s
    @bindings.find do | binding | 
      binding.bound_name == bound_name
    end
    # Retval has bound_name too - no matter.
  end

end


if $0 == __FILE__

  def puts_root_info(root)
    puts "        root.property is #{root.property.inspect}."
  end

  def puts_bound_object_info(bound_object)
    puts "        bound_object holds #{bound_object.some_binding_name.inspect} for 'some binding name'."
  end

  puts "Step 1: Creating an object to be root."
  root = Root.alloc.initWithValue('initial')
  puts_root_info(root)

  puts "Step 2: Creating a bound object to track the root."
  bound_object = BoundObject.alloc.init
  puts_bound_object_info(bound_object)

  puts "Step 3: Bind the objects."
  bound_object.objc_send(:bind, 'some binding name',
                         :toObject, root,
                         :withKeyPath, 'property',
                         :options, nil)
  puts_bound_object_info(bound_object)


  update = 'new'
  puts "Step 4: Updating root property to #{update.inspect}."
  root.property = update
  puts_bound_object_info(bound_object)

  puts "Step 5: Pretending to click upcase button."
  bound_object.upcase(self)
  puts_bound_object_info(bound_object)
  puts_root_info(root)

  exit
end
