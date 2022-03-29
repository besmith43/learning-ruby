#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'lib/ramaze/spec/helper/snippets'

describe '__DIR__' do
  # this is hardly exhaustive, but better than nothing
  it 'should report the directory of the current file' do
    __DIR__.should == File.dirname(File.expand_path(__FILE__))
  end
end
