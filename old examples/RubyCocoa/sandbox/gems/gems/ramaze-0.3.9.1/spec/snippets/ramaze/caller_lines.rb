#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe "Ramaze#caller_info" do
  before do
    @file = File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/ramaze/gestalt.rb'))
  end

  it 'should show  line numbers' do
   res = Ramaze.caller_lines(@file, 68, 2)
   res.size.should == 5
   res.map{|e| e[0]}.should == (66..70).to_a
  end

  it 'should show which line we asked for' do
   res = Ramaze.caller_lines(@file, 68, 2)
   res.size.should == 5
   res.map {|e| e[2]}.should == [false,false,true,false,false]
  end

  it 'should show the code' do
   res = Ramaze.caller_lines(__FILE__, __LINE__, 1)
   res.size.should == 3
   res.map {|e| e[1].strip}.should == [
      "it 'should show the code' do",
      "res = Ramaze.caller_lines(__FILE__, __LINE__, 1)",
      "res.size.should == 3"
   ]
  end

end
