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

# Extensions for Symbol

class Symbol
  unless method_defined?(:to_proc)

    # Turns the symbol into a simple proc, which is especially useful for enumerations. Examples:
    #
    #   # The same as people.collect { |p| p.name }
    #   people.collect(&:name)
    #
    #   # The same as people.select { |p| p.manager? }.collect { |p| p.salary }
    #   people.select(&:manager?).collect(&:salary)
    #
    #   [1, 2, 3].map(&:to_s)    # => ['1', '2', '3']
    #   %w[a b c].map(&:to_sym)  # => [:a, :b, :c]

    def to_proc
      Proc.new{|*args| args.shift.__send__(self, *args) }
    end
  end
end
