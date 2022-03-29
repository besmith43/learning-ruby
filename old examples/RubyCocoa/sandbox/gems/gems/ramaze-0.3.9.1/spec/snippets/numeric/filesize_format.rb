#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "Numeric#filesize_format" do
  it 'it should convert filesizes to human readable format' do
    1.filesize_format.should == '1'
    1024.filesize_format.should == '1.0K'
    (1 << 20).filesize_format.should == '1.0M'
    (1 << 20).filesize_format.should == '1.0M'
    (1 << 30).filesize_format.should == '1.0G'
    (1 << 40).filesize_format.should == '1.0T'
  end
end
