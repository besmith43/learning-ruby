#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "Struct.fill" do
  Point = Struct.new(:x,:y)

  it "should return a well set struct" do
    point = Point.fill(:x=>1,:y=>2)
    point.should.instance_of? Point
    point[0].should == 1
    point[1].should == 2
  end

  it "should work with partial arguments" do
    point = Point.fill(:x=>1)
    point.should.instance_of(Point)
    point[0].should == 1
    point[1].should == nil
  end

  it "should not fail with foreign keys" do
    point = Point.fill(:k=>1)
    point.should.instance_of(Point)
    point[0].should == nil
    point[1].should == nil
  end
end
