#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'testutil'
require 'Notifiable'

module PatchTests

  class Super < Object
  end

  class Sub < Super
  end

  class ClassPatchesTests < Test::Unit::TestCase
    should "reveal the entire class hierarchy" do
      assert_equal([Object], Object.hierarchy_including_self)
      assert_equal([Sub, Super, Object],
                   Sub.hierarchy_including_self)
    end

    should "filter the hierarchy with a block" do
      assert_equal([Super],
                   Sub.hierarchy_including_if { | c | c == Super })
    end
  end

end
