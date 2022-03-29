#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
class C
  def my_attribute=(value)
    @p = value
  end
  
  def my_attribute
    @p
  end
end

obj = C.new
obj.my_attribute = 'some value'
obj.my_attribute    # => "some value"

require_relative '../test/assertions'
assert_equals "some value", obj.my_attribute
