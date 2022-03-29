#!/usr/local/bin/ruby -w
#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---

begin require 'rubygems' rescue LoadError end
require 'inline'

class Hello
  inline do |builder|
    builder.include "<stdio.h>"
    builder.c 'void hello() { puts("hello world"); }'
  end
end

Hello.new.hello
