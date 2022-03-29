#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/hello'

describe 'Hello' do
  behaves_like 'http'
  ramaze

  it '/' do
    get('/').body.should == 'Hello, World!'
  end
end
