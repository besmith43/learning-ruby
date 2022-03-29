#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

Ramaze.contrib :route

class MainController < Ramaze::Controller
  def text(num)
    "text: #{num}"
  end

  def bar
    "bar"
  end
end

describe 'Route' do
  behaves_like 'http'
  ramaze
  @route = Ramaze::Contrib::Route

  it 'should provide backwards compat wrapper to Ramaze::Route' do
    @route[ %r!^/(\d+)\.te?xt$! ] = "/text/%d"
    @route[ 'foobar' ] = lambda{ |path, request|
      '/bar' if path == '/foo' and request[:bar] == '1'
    }
  end

  it 'should work' do
    r = get('/123.txt')
    r.status.should == 200
    r.body.should == 'text: 123'

    r = get('/foo', 'bar=1')
    r.status.should == 200
    r.body.should == 'bar'
  end
end
