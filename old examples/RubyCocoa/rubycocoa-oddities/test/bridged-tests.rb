#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'testutil'

# .bridgesupport files are used for adding information to what 
# RubyCocoa can deduce about methods at runtime. Here, Objective-C
# truth values (which are integers) are converted into Ruby truth values. 


require 'Bridged'
OSX.load_bridge_support_file 'Bridged.bridgesupport'

class BridgedTests < Test::Unit::TestCase
  should "produce booleans, not integers" do
    @sut = Bridged.alloc.init
    assert { @sut.hasEvenLength('1') == false }
    assert { @sut.hasEvenLength('12') == true }
  end
end

