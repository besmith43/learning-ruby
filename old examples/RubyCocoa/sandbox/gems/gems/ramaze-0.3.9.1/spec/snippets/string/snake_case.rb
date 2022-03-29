#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "String#snake_case" do

  it 'should snake_case a camelCase' do
    'CamelCase'.snake_case.should == 'camel_case'
  end

  it 'should snake_case a CamelCaseLong' do
    'CamelCaseLong'.snake_case.should == 'camel_case_long'
  end

  it 'will keep existing _' do
    'Camel_Case'.snake_case.should == 'camel__case'
  end

  it 'should replace spaces' do
    'Linked List'.snake_case.should == 'linked_list'
  end

  it 'should group uppercase words together' do
    'CSSController'.snake_case.should == 'css_controller'
  end
end
