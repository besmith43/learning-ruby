#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.expand_path("#{File.dirname(__FILE__)}/../path-setting")
require File.dirname(__FILE__) + "/testutil"

class NSPatchesTests < Test::Unit::TestCase
  include OSX

  context "inverting OSX booleans" do 	

    should "inverting false.to_ns is true.to_ns" do
      assert { false.to_ns.negate == true.to_ns } 
    end

    should "inverting true.to_ns is false.to_ns" do
      assert { true.to_ns.negate == false.to_ns } 
    end
  end
end
