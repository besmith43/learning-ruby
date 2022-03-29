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

class Page < Ezamar::Element
  def render
    %{
     <html>
      <head>
        <title>examples/element</title>
      </head>
      <body>
        <h1>#{@title}</h1>
        #{content}
      </body>
    </html>
    }
  end
end

class SideBar < Ezamar::Element
  def render
    %{
     <div class="sidebar">
       <a href="http://something.com">something</a>
     </div>
     }
  end
end

class MainController < Ramaze::Controller
  map '/'

  def index
    %{
    <Page title="Test">
      <SideBar />
      <p>
        Hello, World!
      </p>
    </Page>
    }
  end
end

Ramaze.start