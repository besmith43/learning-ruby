#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe 'Array#put_within' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_within(:foobar, :after => :bar, :before => :baz)
    array.should == [:foo, :bar, :foobar, :baz]
  end

  it 'should raise on uncertainity' do
    array = [:foo, :bar, :baz]
    lambda{
      array.put_within(:foobar, :after => :foo, :before => :baz)
    }.should.raise(ArgumentError).
      message.should == "Too many elements within constrain"
  end
end

describe 'Array#put_after' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_after(:bar, :foobar)
    array.should == [:foo, :bar, :foobar, :baz]
  end
end

describe 'Array#put_within' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_before(:bar, :foobar)
    array.should == [:foo, :foobar, :bar, :baz]
  end
end
