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


class StructureSampleTest < Test::Unit::TestCase   # (1) 

    def setup     # (2) 
        # ...
    end

    def teardown
        # ...
    end

    context "adding a row" do  # (3) 
        setup do   # (4) 
            # ...
        end
    
        teardown do   # (5) 
            # ...
        end
    
        should "grow the table" do   # (6)
            # ...
        end
        
        should "put the new row in the last position" do
            # ...
        end
    end
  
    context "removing a row" do 
        # ...
    end
end

