#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe 'Symbol#to_proc' do
  it 'should convert symbols to procs' do
    [:one, :two, :three].map(&:to_s).should == %w[ one two three ]
  end

  it 'should work with list objects' do
    { 1 => "one",
      2 => "two",
      3 => "three" }.sort_by(&:first).map(&:last).should == %w[ one two three ]
  end
end
