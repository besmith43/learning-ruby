#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/element'

describe 'Element' do
  behaves_like 'http'
  ramaze

  it '/' do
    r = get('/').body
    r.should.include('<title>examples/element</title>')
    r.should.include('<h1>Test</h1>')
    r.should.include('<a href="http://something.com">something</a>')
    r.should.include('Hello, World!')
  end
end
