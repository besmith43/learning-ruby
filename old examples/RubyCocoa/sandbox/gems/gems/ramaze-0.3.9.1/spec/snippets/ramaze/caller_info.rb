#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'

#TODO test parse_backtrace explicitly
describe "Ramaze#caller_info" do

  def foo(n=0)
    Ramaze.caller_info(n)
  end

  def bar
    foo
  end

  def baz
    foo(1)
  end

  it "should report correct informations" do
    file,line,meth=foo()
    file.should == __FILE__
    line.should.match(/\d+/)
    meth.should == 'foo'
  end

  it "should report correct informations on nested defs" do
    file,line,meth=bar()
    file.should == __FILE__
    line.should.match(/\d+/)
    meth.should == 'foo'
  end

  it "should report correct informations on other callers" do
    file,line,meth=baz()
    file.should == __FILE__
    line.should.match(/\d+/)
    meth.should == 'baz'
  end

end
