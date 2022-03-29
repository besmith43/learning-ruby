#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "Struct#values_at" do
  Point = Struct.new(:x,:y)

  before do
    @point = Point.new(1,2)
  end

  it "should access a single value" do
    @point.values_at(:x).should == [1]
  end

  it "should access multiple values" do
    @point.values_at(:x,:y).should == [1,2]
  end

  it "should access values regardless of order" do
    @point.values_at(:y,:x).should == [2,1]
  end

  it "should get same value twice" do
    @point.values_at(:x,:x).should == [1,1]
  end

  it "should raise on wrong value" do
    should.raise(NameError){
      @point.values_at(:k)
    }
  end

  it "should work with strings" do
    @point.values_at('x').should == [1]
  end

  it "should work with numbers (ruby compat)" do
    @point.values_at(0).should == [1]
  end

  it "should work with mixed args" do
    @point.values_at(0,:x,'x',:y).should == [1,1,1,2]
  end

end
