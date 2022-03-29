#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
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

Ramaze.start
