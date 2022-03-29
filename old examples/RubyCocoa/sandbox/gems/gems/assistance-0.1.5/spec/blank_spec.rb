#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require File.join(File.dirname(__FILE__), 'spec_helper')

describe "blank?" do
  it "should mark empty objects as blank" do
    [ nil, false, '', '   ', "  \n\t  \r ", [], {} ].each { |f| f.should be_blank }
    [ Object.new, true, 0, 1, 'a', [nil], { nil => 0 } ].each { |t| t.should_not be_blank }
  end
end
