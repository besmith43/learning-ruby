#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'spec/helper'
require 'examples/caching'

describe 'Caching' do
  behaves_like 'http'
  ramaze

  it '/' do
    3.times do
      lambda{ get('/') }.
        should.not.change{ get('/').body }
    end

    3.times do
      lambda{ get('/invalidate') }.
        should.change{ get('/').body }
    end
  end
end
