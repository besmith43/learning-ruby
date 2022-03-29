#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'test/unit'
require 'flexmock/test_unit'

# This file contains methods I find useful when using mocks. 

# These methods are used to change the flow of control so that the 
# test can state what is to happen before stating what the mock should
# receive.
class Test::Unit::TestCase
  def because(&block)
    @because = block
    self
  end
  alias_method :during, :because
  alias_method :whenever, :because
  
  def behold!
    yield
    @result = @because.call
  end

  alias_method :then_behold_these_conclusions!, :behold!
  alias_method :then_behold_this_conclusion!, :behold!
  
  def observe_this_cooperation! 
    yield
    self
  end


  # Shouldn't use this with partial mocks, since it doesn't 
  # trap the underlying class's methods. You don't know that 
  # *nothing* happens, only that default mocks weren't called.
  def behold_nothing_happens!
    behold! {}
  end
end

# Mocks are used in testing of delegate methods. This method is a way of 
# saying that delegation happens within a mock test's "because" clause.

# Note: assumption is that name of notification is also name of method
# that handles it.
module OSX
  class NSObject
    # For the moment, no delegate methods make use of the argument, so 
    # I don't bother with it.
    def is_delegated(name)
      self.send(name, nil)
    end
  end
end

# This makes FlexMock work better w/ RubyCocoa.
class FlexMock
  def self.next_mock_class_name(superclass)
    @count = 0 unless @count
    @count += 1
    supername = superclass.name.split('::').last
    "RubyCocoa_mock_class_#{@count}_of_#{supername}"
  end
end

require 'enumerator'
require 'generator'

class Test::Unit::TestCase
  include OSX 
  def Mockable(superclass)
    mock_class_name = FlexMock.next_mock_class_name(superclass)
    name_arity_definer_defn = %Q{
      def define_method_to_be_mocked(name, arity)
        arglist =  (0...arity).collect { | i | "arg\#{i}" }.join(', ')
        defn = "def \#{name}(\#{arglist})
                  raise 'This method is supposed to be covered with a mock.'
                end
               "
        #{mock_class_name}.class_eval(defn)
      end
    }
    class_def = %Q{
                  class #{mock_class_name} < #{superclass.name} 
                    #{name_arity_definer_defn}
                  end
                }
    # puts class_def            
    self.class.class_eval(class_def)
    self.class.const_get(mock_class_name)
  end

  def rubycocoa_flexmock(base_class = NSObject, mock_name = nil)
    if base_class.is_a? String
      mock_name = base_class
      base_class = NSObject
    end

    mock_class = Mockable(base_class)
    partial = if block_given?
                yield mock_class
              else
                mock_class.alloc.init
              end
    mock = if mock_name
             flexmock(partial, mock_name)
           else
             flexmock(partial)
           end

    mock.instance_eval { alias flexmock__old_should_receive should_receive } 
    def mock.should_receive(*args)
      return flexmock__old_should_receive(*args) unless args[1].is_a?(Integer)
      define_method_to_be_mocked(*args)
      flexmock__old_should_receive(args.first)
    end
    mock
  end

end
              
# Note: can't seem to define usable anonymous subclass of NSObject:
# irb(main):013:0> k = Class.new(NSObject)
# irb(main):014:0> k.alloc
# k.alloc
# TypeError: no implicit conversion from nil to integer
# 	from /System/Library/Frameworks/RubyCocoa.framework/Resources/ruby/osx/objc/oc_wrapper.rb:50:in `ocm_send'
# 	from /System/Library/Frameworks/RubyCocoa.framework/Resources/ruby/osx/objc/oc_wrapper.rb:50:in `method_missing'
# 	from (irb):14

