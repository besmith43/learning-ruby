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

class LinkingController < Ramaze::Controller
  map '/'

  def index
    %{simple link <br/> <a href="#{Rs(:help)}">Help?</a>}
  end
  
  def new
    "something new!"
  end
  
  def help
    %{you have help <br/> <a href="#{R(LinkToController, :another)}">A Different Controller</a>}
  end

end

class LinkToController < Ramaze::Controller
  map '/link_to'
  
  def another
    %{<a href="#{R(LinkingController, :index)}">Back to Original Controller</a>}
  end
end

Ramaze.start :adapter => :mongrel