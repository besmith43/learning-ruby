#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "String#camel_case" do

  it 'should camelize snake_case' do
    'foo_bar'.camel_case.should == 'FooBar'
  end

  it 'should camelize snake_case_long' do
    'foo_bar_baz'.camel_case.should == 'FooBarBaz'
  end

  it 'should ignore starting _' do
    '_foo_bar_baz'.camel_case.should == 'FooBarBaz'
  end

  it 'should ignore trailing _' do
    'foo_bar_baz_'.camel_case.should == 'FooBarBaz'
  end

  it 'messes up existing CamelCase' do
    'foo_barBaz'.camel_case.should == 'FooBarbaz'
  end

end
