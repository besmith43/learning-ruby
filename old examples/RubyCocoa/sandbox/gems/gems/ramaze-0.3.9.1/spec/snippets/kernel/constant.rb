#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe 'constant' do
  it 'should load from string' do
    constant('Fixnum').should == Fixnum
  end

  it 'should load from symbol' do
    constant(:Fixnum).should == Fixnum
  end

  it 'should handle hierarchy' do
    constant('Math::PI').should == Math::PI
  end

  it 'should be callable with explicit self' do
    Math.constant('PI').should == Math::PI
  end

  it 'should be callable with explicit self' do
    Math.constant('::Math').should == Math
  end
end
