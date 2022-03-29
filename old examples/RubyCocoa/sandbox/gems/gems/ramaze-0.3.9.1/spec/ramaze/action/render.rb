#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

class TCActionOne < Ramaze::Controller
  map '/'

  def index
    'Hello, World!'
  end

  def foo
    Ramaze::Action(:controller => self.class, :method => :bar).render
  end

  def bar
    "yo from bar"
  end
end

ramaze

describe 'Action rendering' do
  behaves_like "http"

  it 'should render' do
    action = Ramaze::Action(:method => :index, :controller => TCActionOne)
    action.render.should == 'Hello, World!'
  end

  it 'should render inside the controller' do
    get('/foo').body.should == 'yo from bar'
  end
end
