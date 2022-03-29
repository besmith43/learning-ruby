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

# Extensions for Struct

class Struct

  # Action = Struct.new('Action', :template, :method, :params)
  #
  # a = Action.fill(:template => nil, :method => :meth, :params => [1])
  # # => #<struct Struct::Action template=nil, method=:meth, params=[1]>

  def self.fill(hash = {})
    instance = new
    to_s = members.first.respond_to?(:to_str)
    hash.each do |key, value|
      key = to_s ? key.to_s : key.to_sym
      next unless members.include?(key)
      instance.send("#{key}=", value)
    end
    instance
  end
end
