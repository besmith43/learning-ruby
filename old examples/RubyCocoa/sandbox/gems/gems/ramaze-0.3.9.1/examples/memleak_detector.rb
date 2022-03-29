#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'rubygems'
require 'ramaze'

# you can access it now with http://localhost:7000/
# This should output
# Hello, World!
# in your browser

class MainController < Ramaze::Controller
  def index
    "Hello, World!"
  end
end

def check
  os = []
  ObjectSpace.each_object{|o| os << o }
  p os.inject(Hash.new(0)){|s,v| s[v.class] += 1; s}.sort_by{|k,v| v}
end

Thread.new do
  loop do
    check
    sleep 5
  end
end

Ramaze::Log.loggers.clear
Ramaze.start :adapter => :mongrel, :sourcereload => false
