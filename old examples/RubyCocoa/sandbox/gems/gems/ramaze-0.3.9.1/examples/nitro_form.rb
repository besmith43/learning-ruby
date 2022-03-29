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

gem 'facets', '=1.4.5'
require '/home/manveru/prog/projects/nitroproject/glycerin'
require 'nitro'
require 'og'

class Article
  attr_accessor :title, String
end

Og.setup :store => :sqlite, :destroy => true

class MainController < Ramaze::Controller
  helper :nitroform

  def index
    form(Article.new).to_s
  end
end

Ramaze.start
