#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Mixin to provide class methods that define instance methods 
# to receive delegated methods.

module DelegatableClass
  def delegate_method(selector, &block)
    define_method(selector, &block)
  end
end

module Delegatable
  def self.included(mod)
    mod.extend DelegatableClass
  end
end



