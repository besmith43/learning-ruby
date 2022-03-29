#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "String#unindent" do
  it "should remove indentation" do
    %(
      hello
        how
          are
        you
      doing
    ).ui.should == \
%(hello
  how
    are
  you
doing)
  end

  it 'should not break on a single line' do
    'word'.unindent.should == 'word'
  end

  it 'should find the first line with indentation' do
%(  hi
  there
    bob).ui.should == \
%(hi
there
  bob)
  end

  it 'should have destructive version' do
    str = %(  1\n    2\n  3)
    str.ui!
    str.should == %(1\n  2\n3)
  end
end
