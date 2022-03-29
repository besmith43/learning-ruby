#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
class C
  def m1
    def m2; end
  end
end

class D < C; end

obj = D.new
obj.m1

C.instance_methods(false) # => [:m1, :m2]

require_relative '../test/assertions'
assert_equals [:m1, :m2], C.instance_methods(false)
