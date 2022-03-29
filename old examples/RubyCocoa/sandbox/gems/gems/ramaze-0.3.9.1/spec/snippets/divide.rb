#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe 'String#/ and Symbol#/' do
  it 'should join two strings' do
    ('a' / 'b').should == 'a/b'
  end

  it 'should join a string and a symbol' do
    ('a' / :b).should == 'a/b'
  end

  it 'should join two symbols' do
    (:a / :b).should == 'a/b'
  end

  it 'should be usable in concatenation' do
    ('a' / :b / :c).should == 'a/b/c'
  end
end
