#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/simple'

describe 'Simple' do
  behaves_like 'http'
  ramaze

  def check(url)
    response = get(url)
    response.status.should == 200
    response.body
  end

  it '/' do
    check('/').should == 'simple'
  end

  it '/simple' do
    check('/simple').should =~ /^#<Ramaze::Request/
  end

  it '/join/foo/bar' do
    check('/join/foo/bar').should == 'foobar'
  end

  it '/join/bar/baz' do
    check('/join/bar/baz').should == 'barbaz'
  end

  it '/join_all' do
    check('/join_all/a/b/c/d/e/f').should == 'abcdef'
  end

  it '/sum' do
    check('/sum/1/2').should == '3'
  end

  it '/post_or_get' do
    check('/post_or_get').should == 'GET'
  end

  it '/other' do
    check('/other').should == "Hello, World from OtherController"
  end
end
