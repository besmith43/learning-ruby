#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

# Extensions for Kernel

module Kernel
  # Original from Trans (Facets 1.4.5)
  # This is similar to +Module#const_get+ but is accessible at all levels,
  # and, unlike +const_get+, can handle module hierarchy.
  #
  #   constant("Fixnum")                  # -> Fixnum
  #   constant(:Fixnum)                   # -> Fixnum
  #
  #   constant("Process::Sys")            # -> Process::Sys
  #   constant("Regexp::MULTILINE")       # -> 4
  #
  #   require 'test/unit'
  #   Test.constant("Unit::Assertions")   # -> Test::Unit::Assertions
  #   Test.constant("::Test::Unit")       # -> Test::Unit

  def constant(const)
    const = const.to_s.dup
    base = const.sub!(/^::/, '') ? Object : ( self.kind_of?(Module) ? self : self.class )
    const.split(/::/).inject(base){ |mod, name| mod.const_get(name) }
  end
end
